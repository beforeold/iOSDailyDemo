# DemoOpenApps

一个最小化的 iOS SwiftUI Demo，用来演示点击列表项后通过 URL scheme 打开第三方 App。

当前 Demo 已接入 3 个 App：

- Telegram
- WhatsApp
- SHAREit

项目里真正的“数据源”在 `DemoOpenApps/ContentView.swift`，每个条目都包含：

- `name`
- `deepLink`
- `appStoreURL`

如果调用 `UIApplication.shared.open(...)` 失败，界面会弹出提示，并允许用户跳转到对应 App Store 页面。

## URL Scheme 台账

下表记录的是这个项目当前使用的 scheme 配置。重点是把项目里实际写死的值记录清楚，便于后续维护。

| App | 当前使用的 URL scheme | 当前示例 | App Store |
| --- | --- | --- | --- |
| Telegram | `tg://` | `tg://` | `https://apps.apple.com/app/telegram-messenger/id686449807` |
| WhatsApp | `whatsapp://` | `whatsapp://` | `https://apps.apple.com/us/app/whatsapp-messenger/id310633997` |
| SHAREit | `shareit://` | `shareit://` | `https://apps.apple.com/us/app/shareit-connect-transfer/id725215120` |

## 记录说明

### 1. Telegram

- 项目当前使用：`tg://`
- 官方 deep link 文档公开说明了 Telegram 客户端需要处理 `tg:` 和 `tg://...` 形式的链接。
- 如果只是测试“能否拉起 App”，使用根 scheme `tg://` 就足够直接。

### 2. WhatsApp

- 项目当前使用：`whatsapp://`
- 这个值是当前项目里用于拉起 WhatsApp 的根 scheme。
- 公开、稳定、易检索到的官方 scheme 文档不如 Telegram 明确，因此这里把它定义为“项目当前采用值”，不是“官方永久保证值”。
- 如果后续需要做“直接打开某个聊天”或“预填消息”，通常会扩展到更具体的链接格式，而不是只用根 scheme。

### 3. SHAREit

- 项目当前使用：`shareit://`
- 这个值同样属于“项目当前采用值”。
- 目前没有在公开官方文档里找到像 Telegram 那样明确的 deep link 说明，因此真机验证优先级最高。
- 如果未来 SHAREit 版本升级后无法拉起，优先检查这个 scheme 是否变更。

## 当前代码位置

当前 3 个 App 的 scheme 都定义在：

- `DemoOpenApps/ContentView.swift`

对应字段如下：

```swift
let deepLink: URL
let appStoreURL: URL
```

实际配置示例：

```swift
SocialApp(
    name: "Telegram",
    description: "Open the Telegram app via tg://",
    iconName: "paperplane.fill",
    tint: Color(red: 0.16, green: 0.61, blue: 0.98),
    deepLink: URL(string: "tg://")!,
    appStoreURL: URL(string: "https://apps.apple.com/app/telegram-messenger/id686449807")!
)
```

## 运行逻辑

点击列表项后，项目会执行：

```swift
UIApplication.shared.open(app.deepLink, options: [:]) { success in
    if !success {
        unavailableApp = app
    }
}
```

这表示：

- 能打开：直接跳到目标 App
- 不能打开：弹出提示
- 用户可以继续跳转到 App Store

## 注意事项

### 第三方 App 的 scheme 不是强契约

- URL scheme 属于第三方 App 的实现细节。
- 即使今天可用，也可能因为版本更新而变化。
- README 的主要目的，是记录“这个项目此刻用了什么”，而不是断言这些 scheme 永远有效。

### `open` 和 `canOpenURL` 的区别

- 当前 Demo 使用的是 `open(...)`，没有先调用 `canOpenURL(...)`。
- 这种写法足够简单，适合 Demo。
- 如果后续要在点击前判断是否已安装某个 App，再决定按钮状态，需要补 `canOpenURL(...)`。
- 一旦使用 `canOpenURL(...)`，还要在 `Info.plist` 里添加 `LSApplicationQueriesSchemes`。

### 真机验证优先

- `Telegram` 的 `tg://` 有公开官方 deep link 说明。
- `WhatsApp` 和 `SHAREit` 这里更适合视为“当前项目采用值”。
- 发布前建议在真机上分别验证 3 个目标 App。

## 如何新增一个 App

在 `DemoOpenApps/ContentView.swift` 的 `socialApps` 数组里新增一项：

```swift
SocialApp(
    name: "New App",
    description: "Open via newapp://",
    iconName: "app.fill",
    tint: .blue,
    deepLink: URL(string: "newapp://")!,
    appStoreURL: URL(string: "https://apps.apple.com/...")!
)
```

## 参考链接

- Apple: `UIApplication.open(_:options:completionHandler:)`
  - https://developer.apple.com/documentation/uikit/uiapplication/open%28_%3Aoptions%3Acompletionhandler%3A%29
- Apple: URL schemes in Shortcuts
  - https://support.apple.com/guide/shortcuts/use-another-apps-url-scheme-apd68802640c/ios
- Telegram official deep links
  - https://core.telegram.org/api/links
- Telegram App Store
  - https://apps.apple.com/app/telegram-messenger/id686449807
- WhatsApp App Store
  - https://apps.apple.com/us/app/whatsapp-messenger/id310633997
- SHAREit App Store
  - https://apps.apple.com/us/app/shareit-connect-transfer/id725215120
