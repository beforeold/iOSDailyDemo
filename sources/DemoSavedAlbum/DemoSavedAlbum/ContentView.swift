import Photos
import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = AlbumListViewModel()

  var body: some View {
    NavigationStack {
      Color(uiColor: .systemGroupedBackground)
        .ignoresSafeArea()
        .overlay {
          ScrollView {
            VStack(alignment: .leading, spacing: 20) {
              header

              switch viewModel.state {
              case .idle, .loading:
                loadingCard
              case .needsPermission:
                permissionCard
              case .loaded:
                albumList
              case .failed(let message):
                messageCard(title: "Unable to load albums", message: message, icon: "exclamationmark.triangle")
              }
            }
            .padding(24)
            .frame(maxWidth: 640, alignment: .leading)
            .frame(maxWidth: .infinity)
          }
        }
        .navigationTitle("Albums")
        .toolbar {
          Button {
            viewModel.refresh()
          } label: {
            Label("Refresh", systemImage: "arrow.clockwise")
          }
        }
    }
    .task {
      await viewModel.requestAccessAndLoadAlbums()
    }
  }

  private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Photo Albums")
        .font(.system(size: 28, weight: .bold))
        .foregroundStyle(Color(uiColor: .label))

      Text("Lists user albums fetched with Photos using subtype .any.")
        .font(.body)
        .foregroundStyle(Color(uiColor: .secondaryLabel))
    }
  }

  private var albumList: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Label("PHAssetCollectionSubtype.any", systemImage: "photo.stack")
          .font(.caption.weight(.semibold))
          .foregroundStyle(Color(red: 0.04, green: 0.5, blue: 0.49))

        Spacer()

        Text("\(viewModel.albums.count) albums")
          .font(.caption)
          .foregroundStyle(Color(uiColor: .secondaryLabel))
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(Color(uiColor: .secondarySystemGroupedBackground))
      .clipShape(Capsule())

      if viewModel.albums.isEmpty {
        messageCard(title: "No user albums", message: "Create an album in Photos and refresh this demo.", icon: "rectangle.stack.badge.plus")
      } else {
        LazyVStack(spacing: 12) {
          ForEach(viewModel.albums) { album in
            AlbumRow(album: album)
          }
        }
      }
    }
  }

  private var loadingCard: some View {
    HStack(spacing: 12) {
      ProgressView()

      Text("Loading albums")
        .font(.headline)
        .foregroundStyle(Color(uiColor: .label))
    }
    .padding(20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(uiColor: .systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }

  private var permissionCard: some View {
    VStack(alignment: .leading, spacing: 16) {
      Label("Photo access needed", systemImage: "lock.fill")
        .font(.headline)
        .foregroundStyle(Color(uiColor: .label))

      Text("Allow Photos access to fetch albums with PHAssetCollection.fetchAssetCollections.")
        .font(.body)
        .foregroundStyle(Color(uiColor: .secondaryLabel))

      Button {
        viewModel.openSettings()
      } label: {
        Label("Open Settings", systemImage: "gearshape")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
    }
    .padding(20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(uiColor: .systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }

  private func messageCard(title: String, message: String, icon: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Label(title, systemImage: icon)
        .font(.headline)
        .foregroundStyle(Color(uiColor: .label))

      Text(message)
        .font(.body)
        .foregroundStyle(Color(uiColor: .secondaryLabel))
    }
    .padding(20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(uiColor: .systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

private struct AlbumRow: View {
  let album: PhotoAlbum

  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "rectangle.stack")
        .font(.title3)
        .foregroundStyle(Color(red: 0, green: 0.34, blue: 0.72))
        .frame(width: 36, height: 36)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

      VStack(alignment: .leading, spacing: 4) {
        Text(album.title)
          .font(.headline)
          .foregroundStyle(Color(uiColor: .label))

        Text(album.assetCount == 1 ? "1 item" : "\(album.assetCount) items")
          .font(.caption)
          .foregroundStyle(Color(uiColor: .secondaryLabel))
      }

      Spacer()
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(uiColor: .systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

private struct PhotoAlbum: Identifiable {
  let id: String
  let title: String
  let assetCount: Int
}

@MainActor
private final class AlbumListViewModel: ObservableObject {
  enum State {
    case idle
    case loading
    case needsPermission
    case loaded
    case failed(String)
  }

  @Published private(set) var albums: [PhotoAlbum] = []
  @Published private(set) var state: State = .idle

  func requestAccessAndLoadAlbums() async {
    state = .loading

    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    let authorizedStatus: PHAuthorizationStatus

    if status == .notDetermined {
      authorizedStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    } else {
      authorizedStatus = status
    }

    guard authorizedStatus == .authorized || authorizedStatus == .limited else {
      state = .needsPermission
      return
    }

    loadAlbums()
  }

  func refresh() {
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

    if status == .authorized || status == .limited {
      loadAlbums()
    } else {
      state = .needsPermission
    }
  }

  func openSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
      return
    }

    UIApplication.shared.open(settingsURL)
  }

  private func loadAlbums() {
    state = .loading

    let fetchResult = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .any,
      options: nil
    )

    var loadedAlbums: [PhotoAlbum] = []

    fetchResult.enumerateObjects { collection, _, _ in
      let assets = PHAsset.fetchAssets(in: collection, options: nil)

      if collection.localizedTitle == "Recently Saved" {
        Self.printRecentlySavedAlbumInfo(collection: collection, assets: assets)
      }

      loadedAlbums.append(
        PhotoAlbum(
          id: collection.localIdentifier,
          title: collection.localizedTitle ?? "Untitled Album",
          assetCount: assets.count
        )
      )
    }

    albums = loadedAlbums.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    state = .loaded
  }

  private static func printRecentlySavedAlbumInfo(collection: PHAssetCollection, assets: PHFetchResult<PHAsset>) {
    print("===== Recently Saved Album =====")
    print("localizedTitle: \(collection.localizedTitle ?? "nil")")
    print("localIdentifier: \(collection.localIdentifier)")
    print("assetCollectionType: \(assetCollectionTypeName(collection.assetCollectionType)) (\(collection.assetCollectionType.rawValue))")
    print("assetCollectionSubtype: \(assetCollectionSubtypeName(collection.assetCollectionSubtype)) (\(collection.assetCollectionSubtype.rawValue))")
    print("estimatedAssetCount: \(collection.estimatedAssetCount)")
    print("assetCount: \(assets.count)")
    print("startDate: \(String(describing: collection.startDate))")
    print("endDate: \(String(describing: collection.endDate))")
    print("approximateLocation: \(String(describing: collection.approximateLocation))")
    print("canContainAssets: \(collection.canContainAssets)")
    print("canContainCollections: \(collection.canContainCollections)")
    print("canPerformAddContent: \(collection.canPerform(.addContent))")
    print("canPerformRemoveContent: \(collection.canPerform(.removeContent))")
    print("canPerformDelete: \(collection.canPerform(.delete))")
    print("canPerformRename: \(collection.canPerform(.rename))")
    print("===== End Recently Saved Album =====")
  }

  private static func assetCollectionTypeName(_ type: PHAssetCollectionType) -> String {
    switch type {
    case .album:
      return "album"
    case .smartAlbum:
      return "smartAlbum"
    case .moment:
      return "moment"
    @unknown default:
      return "unknown"
    }
  }

  private static func assetCollectionSubtypeName(_ subtype: PHAssetCollectionSubtype) -> String {
    switch subtype {
    case .albumRegular:
      return "albumRegular"
    case .albumSyncedEvent:
      return "albumSyncedEvent"
    case .albumSyncedFaces:
      return "albumSyncedFaces"
    case .albumSyncedAlbum:
      return "albumSyncedAlbum"
    case .albumImported:
      return "albumImported"
    case .albumMyPhotoStream:
      return "albumMyPhotoStream"
    case .albumCloudShared:
      return "albumCloudShared"
    case .smartAlbumGeneric:
      return "smartAlbumGeneric"
    case .smartAlbumPanoramas:
      return "smartAlbumPanoramas"
    case .smartAlbumVideos:
      return "smartAlbumVideos"
    case .smartAlbumFavorites:
      return "smartAlbumFavorites"
    case .smartAlbumTimelapses:
      return "smartAlbumTimelapses"
    case .smartAlbumAllHidden:
      return "smartAlbumAllHidden"
    case .smartAlbumRecentlyAdded:
      return "smartAlbumRecentlyAdded"
    case .smartAlbumBursts:
      return "smartAlbumBursts"
    case .smartAlbumSlomoVideos:
      return "smartAlbumSlomoVideos"
    case .smartAlbumUserLibrary:
      return "smartAlbumUserLibrary"
    case .smartAlbumSelfPortraits:
      return "smartAlbumSelfPortraits"
    case .smartAlbumScreenshots:
      return "smartAlbumScreenshots"
    case .smartAlbumDepthEffect:
      return "smartAlbumDepthEffect"
    case .smartAlbumLivePhotos:
      return "smartAlbumLivePhotos"
    case .smartAlbumAnimated:
      return "smartAlbumAnimated"
    case .smartAlbumLongExposures:
      return "smartAlbumLongExposures"
    case .smartAlbumUnableToUpload:
      return "smartAlbumUnableToUpload"
    case .smartAlbumRAW:
      return "smartAlbumRAW"
    case .smartAlbumCinematic:
      return "smartAlbumCinematic"
    case .smartAlbumSpatial:
      return "smartAlbumSpatial"
    case .any:
      return "any"
    @unknown default:
      return "unknown"
    }
  }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
