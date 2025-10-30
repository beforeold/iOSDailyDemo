import CoreLocation
import Photos
import SwiftUI
import UIKit

private struct AssetDump: Identifiable {
    let id: String
    let asset: PHAsset
    let title: String
    let detailLines: [String]
}

struct LatestAssetsView: View {
    @State private var statusMessage = "Loading latest assets..."
    @State private var assets: [AssetDump] = []
    @State private var isLoading = false

    var body: some View {
        List {
            Section("Status") {
                Text(statusMessage)
            }

            Section("Latest 100 Assets") {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if assets.isEmpty {
                    Text("No assets available.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(assets) { assetDump in
                        HStack(alignment: .top, spacing: 12) {
                            AssetThumbnailView(asset: assetDump.asset)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(assetDump.title)
                                    .font(.headline)
                                ForEach(assetDump.detailLines, id: \.self) { line in
                                    Text(line)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Latest Assets Dump")
        .task(loadAssetsIfNeeded)
    }

    private func loadAssetsIfNeeded() {
        guard !isLoading, assets.isEmpty else { return }
        loadAssets()
    }

    private func loadAssets() {
        let authorization = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        guard authorization == .authorized || authorization == .limited else {
            statusMessage = "Photo access is required to read assets."
            assets = []
            return
        }

        isLoading = true
        statusMessage = "Loading latest assets..."

        DispatchQueue.global(qos: .userInitiated).async {
            let fetchedAssets = self.fetchLatestAssets()

            DispatchQueue.main.async {
                self.isLoading = false
                if fetchedAssets.isEmpty {
                    self.assets = []
                    self.statusMessage = "No assets available."
                } else {
                    self.assets = fetchedAssets
                    self.statusMessage = "Loaded \(fetchedAssets.count) latest asset(s)."
                }
            }
        }
    }

    private func fetchLatestAssets() -> [AssetDump] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.fetchLimit = 100

        let fetchResult = PHAsset.fetchAssets(with: options)
        var dumps: [AssetDump] = []
        fetchResult.enumerateObjects { asset, index, _ in
            dumps.append(self.buildDump(for: asset, index: index + 1))
        }
        return dumps
    }

    private func buildDump(for asset: PHAsset, index: Int) -> AssetDump {
        var lines: [String] = []
        lines.append("Local identifier: \(asset.localIdentifier)")
        let mediaTypeDescription = describe(mediaType: asset.mediaType)
        lines.append("Media type: \(mediaTypeDescription)")

        let subtypes = describe(mediaSubtypes: asset.mediaSubtypes)
        if !subtypes.isEmpty {
            let subtypesDescription = subtypes.joined(separator: ", ")
            lines.append("Media subtypes: \(subtypesDescription)")
        }
        if let creationDate = asset.creationDate {
            lines.append("Creation date: \(format(date: creationDate))")
        }
        if let modificationDate = asset.modificationDate {
            lines.append("Modification date: \(format(date: modificationDate))")
        }
        if asset.duration > 0 {
            lines.append("Duration: \(format(duration: asset.duration))")
        }
        lines.append("Pixel size: \(asset.pixelWidth) x \(asset.pixelHeight)")
        lines.append("Playback style: \(describe(playbackStyle: asset.playbackStyle))")
        lines.append("Source type: \(describe(sourceType: asset.sourceType))")
        lines.append("Is favorite: \(format(bool: asset.isFavorite))")
        lines.append("Is hidden: \(format(bool: asset.isHidden))")
        lines.append("Represents burst: \(format(bool: asset.representsBurst))")
        if let burstIdentifier = asset.burstIdentifier, !burstIdentifier.isEmpty {
            lines.append("Burst identifier: \(burstIdentifier)")
            let burstDescription = describe(burstTypes: asset.burstSelectionTypes).joined(separator: ", ")
            lines.append("Burst selection types: \(burstDescription)")
        }
        if let location = asset.location {
            lines.append("Location: \(format(location: location))")
        }
        if #available(iOS 26.0, *) {
            lines.append("Content Type: \(asset.contentType)")
        }
        let title = "#\(index) \(describe(mediaType: asset.mediaType))"
        return AssetDump(
            id: asset.localIdentifier,
            asset: asset,
            title: title,
            detailLines: lines
        )
    }

    private func describe(mediaType: PHAssetMediaType) -> String {
        switch mediaType {
        case .image:
            return "Image"
        case .video:
            return "Video"
        case .audio:
            return "Audio"
        case .unknown:
            fallthrough
        @unknown default:
            return "Unknown"
        }
    }

    private func describe(mediaSubtypes: PHAssetMediaSubtype) -> [String] {
        var values: [String] = []
        if mediaSubtypes.contains(.photoPanorama) { values.append("Photo Panorama") }
        if mediaSubtypes.contains(.photoHDR) { values.append("Photo HDR") }
        if mediaSubtypes.contains(.photoScreenshot) { values.append("Photo Screenshot") }
        if mediaSubtypes.contains(.photoLive) { values.append("Photo Live") }
        if mediaSubtypes.contains(.photoDepthEffect) { values.append("Photo Depth Effect") }
        if mediaSubtypes.contains(.videoStreamed) { values.append("Video Streamed") }
        if mediaSubtypes.contains(.videoHighFrameRate) { values.append("Video High Frame Rate") }
        if mediaSubtypes.contains(.videoTimelapse) { values.append("Video Timelapse") }
        if #available(iOS 16, *), mediaSubtypes.contains(.spatialMedia) { values.append("Spatial Media") }
        if values.isEmpty { values.append("None") }
        return values
    }

    private func describe(playbackStyle: PHAsset.PlaybackStyle) -> String {
        switch playbackStyle {
        case .unsupported:
            return "Unsupported"
        case .image:
            return "Image"
        case .imageAnimated:
            return "Animated Image"
        case .livePhoto:
            return "Live Photo"
        case .video:
            return "Video"
        case .videoLooping:
            return "Video Looping"
        @unknown default:
            return "Unknown"
        }
    }

    private func describe(sourceType: PHAssetSourceType) -> String {
        if sourceType == .typeUserLibrary {
            return "User Library"
        }
        var components: [String] = []
        if sourceType.contains(.typeUserLibrary) { components.append("User Library") }
        if sourceType.contains(.typeCloudShared) { components.append("Cloud Shared") }
        if sourceType.contains(.typeiTunesSynced) { components.append("iTunes Synced") }
        return components.isEmpty ? "Unknown" : components.joined(separator: ", ")
    }

    private func describe(burstTypes: PHAssetBurstSelectionType) -> [String] {
        var values: [String] = []
        if burstTypes.contains(.autoPick) { values.append("Auto Pick") }
        if burstTypes.contains(.userPick) { values.append("User Pick") }
        if values.isEmpty { values.append("None") }
        return values
    }

    private func format(date: Date) -> String {
        if let cached = LatestAssetsView.dateFormatter {
            return cached.string(from: date)
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        LatestAssetsView.dateFormatter = formatter
        return formatter.string(from: date)
    }

    private func format(duration: TimeInterval) -> String {
        let formatter: DateComponentsFormatter
        if let cached = LatestAssetsView.durationFormatter {
            formatter = cached
        } else {
            let newFormatter = DateComponentsFormatter()
            newFormatter.allowedUnits = [.hour, .minute, .second]
            newFormatter.unitsStyle = .abbreviated
            LatestAssetsView.durationFormatter = newFormatter
            formatter = newFormatter
        }
        return formatter.string(from: duration) ?? "\(duration)s"
    }

    private func format(location: CLLocation) -> String {
        let latitude = String(format: "%.4f", location.coordinate.latitude)
        let longitude = String(format: "%.4f", location.coordinate.longitude)
        return "\(latitude), \(longitude)"
    }

    private func format(bool value: Bool) -> String {
        value ? "Yes" : "No"
    }

    private static var dateFormatter: DateFormatter?
    private static var durationFormatter: DateComponentsFormatter?
}

private struct AssetThumbnailView: View {
    let asset: PHAsset
    @State private var thumbnail: UIImage?
    @State private var isLoading = false

    private let imageManager = PHCachingImageManager.default()

    var body: some View {
        ZStack {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding(12)
                    .foregroundStyle(.secondary)
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .task(loadThumbnail)
    }

    private func loadThumbnail() {
        guard thumbnail == nil, !isLoading else { return }
        isLoading = true

        let targetSize = CGSize(width: 160, height: 160)
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(for: asset,
                                              targetSize: targetSize,
                                              contentMode: .aspectFill,
                                              options: options) { image, _ in
            DispatchQueue.main.async {
                self.thumbnail = image
                self.isLoading = false
            }
        }
    }
}
