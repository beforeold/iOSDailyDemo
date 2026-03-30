import Foundation
import OSLog
import Security

enum KeychainBookmarkStore {
  private static let account = "DemoBookmarkDataKeyChain.folderBookmark"
  private static var service: String {
    Bundle.main.bundleIdentifier ?? "com.darkp.DemoBookmarkDataKeyChain"
  }

  private static let log = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.darkp.DemoBookmarkDataKeyChain",
    category: "KeychainBookmark"
  )

  static func save(_ data: Data) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
      kSecValueData as String: data,
    ]
    SecItemDelete(query as CFDictionary)
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw BookmarkKeychainError.saveFailed(status)
    }
  }

  static func load() -> Data? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    switch status {
    case errSecSuccess:
      guard let data = item as? Data else {
        log.error("Keychain 读取：status 成功但数据为空")
        return nil
      }
      log.info("Keychain 读取成功，bookmark 字节数: \(data.count, privacy: .public)")
      return data
    case errSecItemNotFound:
      log.info("Keychain 读取：无已存书签 (errSecItemNotFound)")
      return nil
    default:
      log.error("Keychain 读取失败，OSStatus: \(status, privacy: .public)")
      return nil
    }
  }

  /// 移除已存书签（例如解析失败、重装后授权失效时，避免下次启动反复报错）。
  static func deleteBookmark() {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
    ]
    let status = SecItemDelete(query as CFDictionary)
    switch status {
    case errSecSuccess:
      log.info("Keychain 已删除书签项")
    case errSecItemNotFound:
      log.info("Keychain 删除书签：原本即不存在")
    default:
      log.error("Keychain 删除书签失败，OSStatus: \(status, privacy: .public)")
    }
  }
}

enum BookmarkKeychainError: Error {
  case saveFailed(OSStatus)
}
