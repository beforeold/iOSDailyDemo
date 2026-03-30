import Combine
import Foundation
import OSLog

@MainActor
final class FolderBookmarkStore: ObservableObject {
  @Published var folderName: String?
  @Published var fileCount: Int?
  @Published var errorText: String?
  @Published var mockWriteStatus: String?

  private var securityScopedURL: URL?
  private var isAccessingSecurityScope = false

  private static let log = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.darkp.DemoBookmarkDataKeyChain",
    category: "FolderBookmark"
  )

  init() {
    restoreFromKeychainIfPresent()
  }

  func restoreFromKeychainIfPresent() {
    errorText = nil
    mockWriteStatus = nil
    guard let data = KeychainBookmarkStore.load() else {
      folderName = nil
      fileCount = nil
      return
    }
    applyBookmarkData(data)
  }

  func handlePickedFolder(at url: URL) {
    errorText = nil
    mockWriteStatus = nil
    stopSecurityScopedAccess()
    guard url.startAccessingSecurityScopedResource() else {
      Self.log.error("书签链路(选取器): 开启 security-scoped 访问失败 path=\(url.path, privacy: .public)")
      errorText = "无法获得对该文件夹的访问权限。"
      return
    }
    isAccessingSecurityScope = true
    securityScopedURL = url
    do {
      // iOS 上不支持 .withSecurityScope；从文件选取器得到的 URL 仍须配合 security-scoped 访问。
      let data = try url.bookmarkData(
        options: [],
        includingResourceValuesForKeys: nil,
        relativeTo: nil
      )
      try KeychainBookmarkStore.save(data)
      updateDisplay(for: url)
      Self.log.info(
        "书签链路(选取器): 生成书签并写入钥匙串成功 folder=\(self.folderName ?? "", privacy: .public) fileCount=\(self.fileCount ?? 0, privacy: .public) bookmarkBytes=\(data.count, privacy: .public)"
      )
    } catch {
      stopSecurityScopedAccess()
      errorText = error.localizedDescription
      Self.log.error("书签链路(选取器): 失败 \(error.localizedDescription, privacy: .public)")
    }
  }

  private func applyBookmarkData(_ data: Data) {
    stopSecurityScopedAccess()
    do {
      var stale = false
      let url = try URL(
        resolvingBookmarkData: data,
        options: [.withoutUI],
        relativeTo: nil,
        bookmarkDataIsStale: &stale
      )
      guard url.startAccessingSecurityScopedResource() else {
        Self.log.error(
          "书签链路(恢复): 解析得到 URL 但开启 security-scoped 失败 path=\(url.path, privacy: .public)；将清除钥匙串中的无效书签"
        )
        KeychainBookmarkStore.deleteBookmark()
        errorText = Self.bookmarkRestoreFailedUserMessage(underlying: nil)
        folderName = nil
        fileCount = nil
        return
      }
      isAccessingSecurityScope = true
      securityScopedURL = url
      updateDisplay(for: url)
      Self.log.info(
        "书签链路(恢复): 解析书签并访问成功 stale=\(stale, privacy: .public) folder=\(self.folderName ?? "", privacy: .public) fileCount=\(self.fileCount ?? 0, privacy: .public)"
      )
      if stale {
        let refreshed = try url.bookmarkData(
          options: [],
          includingResourceValuesForKeys: nil,
          relativeTo: nil
        )
        try KeychainBookmarkStore.save(refreshed)
        Self.log.info("书签链路(恢复): 书签已过期，已重新生成并写回钥匙串 bytes=\(refreshed.count, privacy: .public)")
      }
    } catch {
      Self.log.error(
        "书签链路(恢复): 解析或刷新失败 \(error.localizedDescription, privacy: .public)；将清除钥匙串中的无效书签。说明：iOS 上卸载重装后，文档选取器授予的访问权不会延续，钥匙串里即使仍有数据也无法再解析/打开，必须重新选择文件夹。"
      )
      KeychainBookmarkStore.deleteBookmark()
      errorText = Self.bookmarkRestoreFailedUserMessage(underlying: error)
      folderName = nil
      fileCount = nil
    }
  }

  /// 系统无法再用已存书签恢复对「文件」中文件夹的访问时（常见于卸载重装后仍残留钥匙串数据）。
  private static func bookmarkRestoreFailedUserMessage(underlying: Error?) -> String {
    let reinstallHint =
      "应用重装或系统已撤销对该文件夹的授权，无法继续使用已保存的书签。请轻点下方按钮，在「文件」中重新选择文件夹。"
    guard let underlying else { return reinstallHint }
    let ns = underlying as NSError
    if ns.domain == NSCocoaErrorDomain, ns.code == NSFileReadNoPermissionError {
      return reinstallHint
    }
    if ns.domain == NSPOSIXErrorDomain, ns.code == Int(EPERM) {
      return reinstallHint
    }
    return "\(reinstallHint)\n（\(underlying.localizedDescription)）"
  }

  /// 在当前已授权文件夹内写入一行 Mock `.txt`（内容为 ISO8601 写入时间与随机 UUID）。
  func writeMockTextFileToBookmarkedFolder() {
    errorText = nil
    mockWriteStatus = nil
    guard let folderURL = securityScopedURL, isAccessingSecurityScope else {
      errorText = "当前没有可写入的文件夹访问权，请先选择或恢复书签。"
      return
    }
    let uuid = UUID().uuidString
    let iso = Self.isoTimestampString(for: Date())
    let body = "writtenAt: \(iso)\nuuid: \(uuid)\n"
    let fileName = "bookmark_mock_\(uuid.prefix(8)).txt"
    let fileURL = folderURL.appendingPathComponent(fileName, isDirectory: false)
    do {
      try body.write(to: fileURL, atomically: true, encoding: .utf8)
      updateDisplay(for: folderURL)
      mockWriteStatus = "已写入：\(fileName)"
      Self.log.info("mock txt 写入成功 path=\(fileURL.path, privacy: .public)")
    } catch {
      errorText = error.localizedDescription
      Self.log.error("mock txt 写入失败 \(error.localizedDescription, privacy: .public)")
    }
  }

  private static func isoTimestampString(for date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.string(from: date)
  }

  private func updateDisplay(for folderURL: URL) {
    folderName = folderURL.lastPathComponent
    fileCount = Self.countFilesRecursively(in: folderURL)
  }

  private static func countFilesRecursively(in directory: URL) -> Int {
    guard
      let enumerator = FileManager.default.enumerator(
        at: directory,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]
      )
    else { return 0 }
    var count = 0
    for case let itemURL as URL in enumerator {
      guard
        let isFile = try? itemURL.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile,
        isFile == true
      else { continue }
      count += 1
    }
    return count
  }

  private func stopSecurityScopedAccess() {
    if isAccessingSecurityScope, let securityScopedURL {
      securityScopedURL.stopAccessingSecurityScopedResource()
    }
    isAccessingSecurityScope = false
    securityScopedURL = nil
  }
}
