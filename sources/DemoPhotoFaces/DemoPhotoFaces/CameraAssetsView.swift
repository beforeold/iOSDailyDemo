import Photos
import SwiftUI

private struct CameraAssetMetrics {
    let totalCount: Int
    let imageCount: Int
    let videoCount: Int
    let latestAssetDate: Date?
    let recentlyAddedCount: Int
}

struct CameraAssetsView: View {
    @State private var statusMessage = "Loading camera assets..."
    @State private var metrics: CameraAssetMetrics?
    @State private var isLoading = false

    var body: some View {
        List {
            Section("Status") {
                Text(statusMessage)
            }

            Section("Camera Assets") {
                if let metrics {
                    Text("Total assets: \(metrics.totalCount)")
                    Text("Images: \(metrics.imageCount)")
                    Text("Videos: \(metrics.videoCount)")
                } else if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text("No data available.")
                        .foregroundStyle(.secondary)
                }
            }

            if let metrics {
                Section("Recently Added") {
                    Text("Recently added assets: \(metrics.recentlyAddedCount)")
                }
            }

            if let metrics, let latestDate = metrics.latestAssetDate {
                Section("Latest Capture") {
                    Text("Most recent asset: \(format(date: latestDate))")
                }
            }
        }
        .navigationTitle("Camera Assets")
        .task(loadMetricsIfNeeded)
    }

    private func loadMetricsIfNeeded() {
        guard !isLoading, metrics == nil else { return }
        loadMetrics()
    }

    private func loadMetrics() {
        let authorization = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        guard authorization == .authorized || authorization == .limited else {
            statusMessage = "Photo access is required to load camera assets."
            metrics = nil
            return
        }

        isLoading = true
        statusMessage = "Loading camera assets..."

        DispatchQueue.global(qos: .userInitiated).async {
            let metrics = self.queryCameraAssetMetrics()

            DispatchQueue.main.async {
                self.isLoading = false
                if let metrics {
                    self.metrics = metrics
                    self.statusMessage = metrics.totalCount > 0
                        ? "Found \(metrics.totalCount) asset(s) captured with the camera."
                        : "No camera assets found."
                } else {
                    self.metrics = nil
                    self.statusMessage = "Unable to load camera assets."
                }
            }
        }
    }

    private func queryCameraAssetMetrics() -> CameraAssetMetrics? {
        guard let cameraRoll = fetchCameraRollCollection() else { return nil }

        let totalOptions = cameraRollFetchOptions(allowSelectImage: true, allowSelectVideo: true)
        let allAssets = PHAsset.fetchAssets(in: cameraRoll, options: totalOptions)

        let imageOptions = cameraRollFetchOptions(allowSelectImage: true, allowSelectVideo: false)
        let imageCount = PHAsset.fetchAssets(in: cameraRoll, options: imageOptions).count

        let videoOptions = cameraRollFetchOptions(allowSelectImage: false, allowSelectVideo: true)
        let videoCount = PHAsset.fetchAssets(in: cameraRoll, options: videoOptions).count

        let latestOptions = cameraRollFetchOptions(allowSelectImage: true,
                                                   allowSelectVideo: true,
                                                   sortedDescendingByDate: true,
                                                   fetchLimit: 1)
        let latestAsset = PHAsset.fetchAssets(in: cameraRoll, options: latestOptions).firstObject

        let recentlyAddedCount = fetchRecentlyAddedCount()

        return CameraAssetMetrics(
            totalCount: allAssets.count,
            imageCount: imageCount,
            videoCount: videoCount,
            latestAssetDate: latestAsset?.creationDate,
            recentlyAddedCount: recentlyAddedCount
        )
    }

    private func fetchCameraRollCollection() -> PHAssetCollection? {
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: .smartAlbumUserLibrary,
                                                                  options: nil)
        return collections.firstObject
    }

    private func fetchRecentlyAddedCollection() -> PHAssetCollection? {
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: .smartAlbumRecentlyAdded,
                                                                  options: nil)
        return collections.firstObject
    }

    private func fetchRecentlyAddedCount() -> Int {
        guard let collection = fetchRecentlyAddedCollection() else { return 0 }
        let options = cameraRollFetchOptions(allowSelectImage: true, allowSelectVideo: true)
        return PHAsset.fetchAssets(in: collection, options: options).count
    }

    private func cameraRollFetchOptions(allowSelectImage: Bool,
                                        allowSelectVideo: Bool,
                                        sortedDescendingByDate: Bool = false,
                                        fetchLimit: Int = 0) -> PHFetchOptions {
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        options.includeAllBurstAssets = true
        // Default source types match Photos.app behaviour; no explicit filter.

        if sortedDescendingByDate {
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        }
        if fetchLimit > 0 {
            options.fetchLimit = fetchLimit
        }

        var predicates: [NSPredicate] = []
        if allowSelectImage {
            predicates.append(NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue))
        }
        if allowSelectVideo {
            predicates.append(NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue))
        }

        if predicates.isEmpty {
            options.predicate = NSPredicate(value: false)
        } else if predicates.count == 1 {
            options.predicate = predicates[0]
        } else {
            options.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }

        return options
    }

    private func format(date: Date) -> String {
        if let cached = CameraAssetsView.dateFormatter {
            return cached.string(from: date)
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        CameraAssetsView.dateFormatter = formatter
        return formatter.string(from: date)
    }

    private static var dateFormatter: DateFormatter?
}
