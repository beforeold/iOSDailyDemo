//
//  ContentView.swift
//  DemoMetaData
//
//  Created by beforeold on 2026/1/15.
//

import Combine
import AVFoundation
import Photos
import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var model = VideoLibraryModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                authorizationSection

                if model.isAuthorized {
                    albumPicker
                    videoList
                    videoMetadata
                }
            }
            .padding()
            .navigationTitle("Video Metadata")
        }
        .onAppear {
            model.refreshAuthorization()
        }
    }

    private var authorizationSection: some View {
        HStack(spacing: 12) {
            Text(model.authorizationDescription)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()

            Button("Request Access") {
                model.requestAccess()
            }
            .buttonStyle(.borderedProminent)
            .disabled(model.isAuthorized)
        }
    }

    private var albumPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Video albums")
                .font(.headline)
            Picker("Album", selection: $model.selectedAlbumId) {
                ForEach(model.albums) { album in
                    Text("\(album.title) (\(album.videoCount))")
                        .tag(Optional(album.id))
                }
            }
            .pickerStyle(.menu)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var videoList: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Videos")
                    .font(.headline)
                Spacer()
                Button("Reload") {
                    model.reloadSelectedAlbum()
                }
            }
            List(model.videos) { video in
                Button {
                    model.selectedVideoId = video.id
                } label: {
                    HStack(spacing: 12) {
                        if let image = video.thumbnail {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(8)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Image(systemName: "video")
                                        .foregroundStyle(.secondary)
                                )
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(video.title)
                                .font(.subheadline)
                            Text(video.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
                .listRowBackground(
                    video.id == model.selectedVideoId
                        ? Color.accentColor.opacity(0.12)
                        : Color.clear
                )
            }
            .listStyle(.plain)
            .frame(minHeight: 220)
        }
    }

    private var videoMetadata: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Selected video metadata")
                .font(.headline)

            if let metadata = model.selectedMetadataLines {
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(metadata, id: \.self) { line in
                            Text(line)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(maxHeight: 220)
            } else {
                Text("Select a video to view details.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}

private struct VideoAlbum: Identifiable {
    let id: String
    let title: String
    let videoCount: Int
    let collection: PHAssetCollection
}

private struct VideoItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let metadata: [String]
    let asset: PHAsset
    let thumbnail: UIImage?
}

@MainActor
private final class VideoLibraryModel: ObservableObject {
    @Published private(set) var authorizationStatus: PHAuthorizationStatus = .notDetermined
    @Published var albums: [VideoAlbum] = []
    @Published var selectedAlbumId: String? {
        didSet { loadVideosForSelectedAlbum() }
    }
    @Published var videos: [VideoItem] = []
    @Published var selectedVideoId: String? {
        didSet { updateSelectedMetadata() }
    }
    @Published private(set) var selectedMetadataLines: [String]?

    var isAuthorized: Bool {
        authorizationStatus == .authorized || authorizationStatus == .limited
    }

    var authorizationDescription: String {
        switch authorizationStatus {
        case .authorized:
            return "Photo access granted."
        case .limited:
            return "Limited photo access granted."
        case .denied:
            return "Photo access denied."
        case .restricted:
            return "Photo access restricted."
        case .notDetermined:
            return "Photo access not determined."
        @unknown default:
            return "Unknown photo access state."
        }
    }

    func refreshAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        authorizationStatus = status
        if isAuthorized {
            loadAlbums()
        }
    }

    func requestAccess() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                guard let self else { return }
                self.authorizationStatus = status
                if self.isAuthorized {
                    self.loadAlbums()
                }
            }
        }
    }

    func reloadSelectedAlbum() {
        loadVideosForSelectedAlbum()
    }

    private func loadAlbums() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)

            var collected: [VideoAlbum] = []
            let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

            func appendAlbums(from fetchResult: PHFetchResult<PHAssetCollection>) {
                fetchResult.enumerateObjects { collection, _, _ in
                    let assets = PHAsset.fetchAssets(in: collection, options: options)
                    guard assets.count > 0 else { return }
                    let title = collection.localizedTitle ?? "Untitled"
                    collected.append(
                        VideoAlbum(
                            id: collection.localIdentifier,
                            title: title,
                            videoCount: assets.count,
                            collection: collection
                        )
                    )
                }
            }

            appendAlbums(from: userAlbums)
            collected.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }

            DispatchQueue.main.async {
                self.albums = collected
                if self.selectedAlbumId == nil {
                    self.selectedAlbumId = collected.first?.id
                } else {
                    self.loadVideosForSelectedAlbum()
                }
            }
        }
    }

    private func loadVideosForSelectedAlbum() {
        guard let selectedAlbum = albums.first(where: { $0.id == selectedAlbumId }) else {
            videos = []
            selectedVideoId = nil
            selectedMetadataLines = nil
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let assets = PHAsset.fetchAssets(in: selectedAlbum.collection, options: options)
            var items: [VideoItem] = []
            items.reserveCapacity(assets.count)

            assets.enumerateObjects { asset, _, _ in
                let resources = PHAssetResource.assetResources(for: asset)
                let filename = resources.first?.originalFilename ?? "Video"
                let duration = String(format: "%.1fs", asset.duration)
                let subtitle = "\(duration) • \(asset.pixelWidth)x\(asset.pixelHeight)"

                var metadata: [String] = []
                metadata.append("Filename: \(filename)")
                metadata.append("Duration: \(duration)")
                metadata.append("Resolution: \(asset.pixelWidth)x\(asset.pixelHeight)")
                if let date = asset.creationDate {
                    metadata.append("Created: \(date.formatted(date: .abbreviated, time: .shortened))")
                }
                metadata.append("Favorite: \(asset.isFavorite ? "Yes" : "No")")
                metadata.append("Media Subtypes: \(asset.mediaSubtypes.rawValue)")

                items.append(
                    VideoItem(
                        id: asset.localIdentifier,
                        title: filename,
                        subtitle: subtitle,
                        metadata: metadata,
                        asset: asset,
                        thumbnail: self.fetchThumbnail(for: asset)
                    )
                )
            }

            DispatchQueue.main.async {
                self.videos = items
                if self.selectedVideoId == nil {
                    self.selectedVideoId = items.first?.id
                } else {
                    self.updateSelectedMetadata()
                }
            }
        }
    }

    private func fetchThumbnail(for asset: PHAsset) -> UIImage? {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .fastFormat
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true

        var image: UIImage?
        let targetSize = CGSize(width: 128, height: 128)
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { result, _ in
            image = result
        }
        return image
    }

    private func updateSelectedMetadata() {
        guard let selected = videos.first(where: { $0.id == selectedVideoId }) else {
            selectedMetadataLines = nil
            return
        }
        selectedMetadataLines = ["Loading metadata..."]
        loadAVAssetMetadata(for: selected.asset)
    }

    private func loadAVAssetMetadata(for asset: PHAsset) {
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true
        let startTime = CFAbsoluteTimeGetCurrent()
        asset.requestContentEditingInput(with: options) { [weak self] input, _ in
            guard let self, let input, let avAsset = input.avAsset else { return }
            let metadataLines = self.formatMetadataLines(for: avAsset)
            DispatchQueue.main.async {
                self.selectedMetadataLines = metadataLines.isEmpty
                    ? ["No AVAsset metadata found."]
                    : metadataLines
            }

            if let urlAsset = avAsset as? AVURLAsset {
                self.getVideoMetadataLines(from: urlAsset.url) { extraLines in
                    DispatchQueue.main.async {
                        let current = self.selectedMetadataLines ?? []
                        let combined = current + ["--- Video Tracks ---"] + extraLines
                        self.selectedMetadataLines = combined
                        let elapsed = CFAbsoluteTimeGetCurrent() - startTime
                        self.logMetadataLines(combined, elapsed: elapsed)
                    }
                }
            } else {
                let elapsed = CFAbsoluteTimeGetCurrent() - startTime
                self.logMetadataLines(metadataLines, elapsed: elapsed)
            }
        }
    }

    private func formatMetadataLines(for asset: AVAsset) -> [String] {
        var lines: [String] = []
        let allMetadata = asset.metadata
        for item in allMetadata {
            let keySpace = item.keySpace?.rawValue ?? "unknown"
            let keyName = item.commonKey?.rawValue ?? (item.key as? String ?? "unknown")
            let value: String
            if let stringValue = item.stringValue {
                value = stringValue
            } else if let valueObject = item.value {
                value = "\(valueObject)"
            } else {
                value = "nil"
            }
            let dataType = item.dataType ?? "unknown"
            lines.append("[\(keySpace)] \(keyName) (\(dataType)): \(value)")
            if let extra = item.extraAttributes, !extra.isEmpty {
                for (key, extraValue) in extra {
                  lines.append("[\(keySpace)] \(keyName) extra.\(key.rawValue): \(extraValue)")
                }
            }
        }
        return lines.sorted()
    }

    private func logMetadataLines(_ lines: [String], elapsed: CFTimeInterval) {
        print("=== AVAsset Metadata ===")
        print(String(format: "Metadata fetch time: %.3f seconds", elapsed))
        if lines.isEmpty {
            print("No AVAsset metadata found.")
            return
        }
        for line in lines {
            print(line)
        }
    }

    private func getVideoMetadataLines(from url: URL, completion: @escaping ([String]) -> Void) {
        let asset = AVAsset(url: url)
        var lines: [String] = []
        let duration = CMTimeGetSeconds(asset.duration)
        if duration.isFinite {
            lines.append(String(format: "Video Duration: %.2f seconds", duration))
        }

        asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "tracks", error: &error)
            if status == .loaded {
                for track in asset.tracks(withMediaType: .video) {
                    let size = track.naturalSize
                    lines.append("Video Resolution: \(Int(size.width)) x \(Int(size.height))")
                    if let formats = track.formatDescriptions as? [CMFormatDescription] {
                        for format in formats {
                            let mediaType = CMFormatDescriptionGetMediaType(format)
                            lines.append("Video Codec: \(mediaType)")
                        }
                    }
                }
                for track in asset.tracks(withMediaType: .audio) {
                    lines.append("Audio Track: \(track)")
                }
            } else {
                let message = error?.localizedDescription ?? "Unknown error"
                lines.append("Failed to load tracks: \(message)")
            }
            completion(lines)
        }
    }
}
