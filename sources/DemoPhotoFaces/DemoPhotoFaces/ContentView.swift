import Photos
import SwiftUI

private struct FaceCollectionInfo: Identifiable {
    let id: String
    let title: String
    let detailLines: [String]
}

struct ContentView: View {
    @State private var statusMessage = "Checking photo access..."
    @State private var faceCollections: [FaceCollectionInfo] = []
    @State private var hasPhotoAccess = false

    var body: some View {
        NavigationView {
            List {
                Section("Status") {
                    Text(statusMessage)
                }

                if hasPhotoAccess {
                    Section("Library Insights") {
                        NavigationLink {
                            CameraAssetsView()
                        } label: {
                            Label("Camera Assets Overview", systemImage: "camera")
                        }
                        NavigationLink {
                            LatestAssetsView()
                        } label: {
                            Label("Latest 100 Assets Dump", systemImage: "list.bullet.rectangle")
                        }
                        Button {
                            PhotoFetcher().test()
                        } label: {
                            Label("Run Smart Album Test", systemImage: "gearshape")
                        }
                        Button {
                            PhotoFetcher().testMetadataRequestTime()
                        } label: {
                            Label("Test Metadata Request Time", systemImage: "clock.arrow.2.circlepath")
                        }
                    }
                }

                Section("Faces Collections") {
                    if faceCollections.isEmpty {
                        Text("No face collections found.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(faceCollections) { info in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(info.title)
                                    .font(.headline)
                                ForEach(info.detailLines, id: \.self) { line in
                                    Text(line)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Photo Faces")
            .onAppear(perform: checkPhotoAccess)
        }
    }

    private func checkPhotoAccess() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            hasPhotoAccess = true
            fetchFaceCollections()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.hasPhotoAccess = true
                        self.fetchFaceCollections()
                    } else {
                        self.hasPhotoAccess = false
                        self.faceCollections = []
                        self.statusMessage = "Photo access was not granted."
                    }
                }
            }
        case .denied, .restricted:
            hasPhotoAccess = false
            faceCollections = []
            statusMessage = "Photo access denied. Please update permissions in Settings."
        @unknown default:
            hasPhotoAccess = false
            faceCollections = []
            statusMessage = "Unknown photo access status."
        }
    }

    private func fetchFaceCollections() {
        guard hasPhotoAccess else { return }
        statusMessage = "Loading face collections..."

        DispatchQueue.global(qos: .userInitiated).async {
            var results: [FaceCollectionInfo] = []

            let faceLists = PHCollectionList.fetchCollectionLists(with: .smartFolder,
                                                                  subtype: .smartFolderFaces,
                                                                  options: nil)
            faceLists.enumerateObjects { list, _, _ in
                let collections = PHCollection.fetchCollections(in: list, options: nil)
                collections.enumerateObjects { collection, _, _ in
                    if let assetCollection = collection as? PHAssetCollection {
                        results.append(self.buildInfo(for: assetCollection, listTitle: list.localizedTitle))
                    } else {
                        results.append(self.buildInfo(for: collection, listTitle: list.localizedTitle))
                    }
                }
            }

            let syncedFacesAlbums = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                            subtype: .albumSyncedFaces,
                                                                            options: nil)
            syncedFacesAlbums.enumerateObjects { album, _, _ in
                results.append(self.buildInfo(for: album, listTitle: "Synced Faces"))
            }

            DispatchQueue.main.async {
                if results.isEmpty {
                    self.statusMessage = "No face collections available."
                } else {
                    self.statusMessage = "Loaded \(results.count) face collection(s)."
                }
                self.faceCollections = results
            }
        }
    }

    private func buildInfo(for collection: PHAssetCollection, listTitle: String?) -> FaceCollectionInfo {
        let title =
            collection.localizedTitle?.isEmpty == false ? collection.localizedTitle! : "Untitled Face Collection"
        let assets = PHAsset.fetchAssets(in: collection, options: nil)

        var lines: [String] = baseDetailLines(for: collection, listTitle: listTitle)
        lines.append("Estimated assets: \(collection.estimatedAssetCount)")
        lines.append("Fetched assets: \(assets.count)")

        if let startDate = collection.startDate {
            lines.append("Start date: \(format(date: startDate))")
        }

        if let endDate = collection.endDate {
            lines.append("End date: \(format(date: endDate))")
        }

        let locations = collection.localizedLocationNames
        if !locations.isEmpty {
            lines.append("Locations: \(locations.joined(separator: ", "))")
        }

        return FaceCollectionInfo(
            id: collection.localIdentifier,
            title: title,
            detailLines: lines
        )
    }

    private func buildInfo(for collection: PHCollection, listTitle: String?) -> FaceCollectionInfo {
        let title = collection.localizedTitle?.isEmpty == false ? collection.localizedTitle! : "Untitled Collection"
        let lines = baseDetailLines(for: collection, listTitle: listTitle)

        return FaceCollectionInfo(
            id: collection.localIdentifier,
            title: title,
            detailLines: lines
        )
    }

    private func baseDetailLines(for collection: PHCollection, listTitle: String?) -> [String] {
        var lines: [String] = []
        if let listTitle, !listTitle.isEmpty {
            lines.append("List: \(listTitle)")
        }
        lines.append("ID: \(collection.localIdentifier)")

        if let assetCollection = collection as? PHAssetCollection {
            lines.append("Subtype: \(describe(assetSubtype: assetCollection.assetCollectionSubtype))")
            lines.append("Type: \(describe(assetType: assetCollection.assetCollectionType))")
        } else if let list = collection as? PHCollectionList {
            lines.append("Subtype: \(describe(listSubtype: list.collectionListSubtype))")
            lines.append("Type: \(describe(listType: list.collectionListType))")
        } else {
            lines.append("Type: \(String(describing: type(of: collection)))")
        }

        lines.append("Can contain assets: \(collection.canContainAssets ? "Yes" : "No")")
        lines.append("Can contain collections: \(collection.canContainCollections ? "Yes" : "No")")
        return lines
    }

    private func describe(assetSubtype: PHAssetCollectionSubtype) -> String {
        let description = String(describing: assetSubtype)
        let trimmed = description.replacingOccurrences(of: "PHAssetCollectionSubtype.", with: "")
        return trimmed.isEmpty ? "rawValue \(assetSubtype.rawValue)" : trimmed
    }

    private func describe(assetType: PHAssetCollectionType) -> String {
        let description = String(describing: assetType)
        let trimmed = description.replacingOccurrences(of: "PHAssetCollectionType.", with: "")
        return trimmed.isEmpty ? "rawValue \(assetType.rawValue)" : trimmed
    }

    private func describe(listSubtype: PHCollectionListSubtype) -> String {
        let description = String(describing: listSubtype)
        let trimmed = description.replacingOccurrences(of: "PHCollectionListSubtype.", with: "")
        return trimmed.isEmpty ? "rawValue \(listSubtype.rawValue)" : trimmed
    }

    private func describe(listType: PHCollectionListType) -> String {
        let description = String(describing: listType)
        let trimmed = description.replacingOccurrences(of: "PHCollectionListType.", with: "")
        return trimmed.isEmpty ? "rawValue \(listType.rawValue)" : trimmed
    }

    private func format(date: Date) -> String {
        dateFormatter.string(from: date)
    }

    private var dateFormatter: DateFormatter {
        if let cached = ContentView.sharedDateFormatter {
            return cached
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        ContentView.sharedDateFormatter = formatter
        return formatter
    }

    private static var sharedDateFormatter: DateFormatter?
}

#Preview {
    ContentView()
}
