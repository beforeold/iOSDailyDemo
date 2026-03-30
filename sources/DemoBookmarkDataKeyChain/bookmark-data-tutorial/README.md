# URL Bookmark Data 简明教程

本教程面向已在写 **iOS / macOS** 文件访问相关代码的开发者，分两课时介绍 **`URL.bookmarkData` / `resolvingBookmarkData`** 的典型用法、**stale** 维护与平台差异。

## 使用方式

按顺序阅读：

| 课时 | 文件 | 内容概要 |
|------|------|----------|
| 第 1 课 | [第1课-书签是什么与如何生成.md](./第1课-书签是什么与如何生成.md) | 概念、适用场景、从用户选取的 URL 生成并保存书签 |
| 第 2 课 | [第2课-解析Stale与实战注意.md](./第2课-解析Stale与实战注意.md) | 冷启动恢复、stale 维护、权限失败与 iOS/macOS 差异 |

每课阅读时间约 **20～40 分钟**（含动手示意）；代码多为片段说明，可与自己的 Demo（例如 Document Picker + Keychain）对照。

## 需要先具备的知识

- Swift 基础、`URL`、`FileManager` 的基本认知  
- 了解「沙盒」「安全作用域（security-scoped）」在 iOS 上从 **文件 App / Document Picker** 取 URL 时的含义（第 1 课会再点到）

---

*教程位于本仓库：`DemoBookmarkDataKeyChain/bookmark-data-tutorial/`。*
