# DemoUTTypeText

一个 SwiftUI demo，验证 `UTType` 的 **rawValue（identifier）** 与 **相等性**，并把这些规则落到真实的 `.fileImporter` / `.fileExporter` 文件流里。重点是想说清一件事：

> **picker 用 conformance（类型继承）放行文件，相等判断用 identity（`==`）—— 两者不是一回事。**

## 三个 Section

1. **rawValue (identifier) of text UTTypes** — 列出文本家族（`.text`/`.plainText`/`.json`/`.swiftSource`/`.lrc`…）的 `type.identifier`、扩展名、MIME，以及每行的两个 conformance 徽章：
   - 🟢 `conforms .plainText`（更窄的子类关系）
   - ⚪️ `conforms .text`（更宽的祖先关系）

   `.lrc`、`.json` 等会同时亮两个，`.rtf`/`.html`/`.xml` 只亮 `.text`。

2. **equality of UTTypes from different constructors** — 用 `==` 对比不同构造路径，badge 区分：🟢 实心 = `==`，⚪️ 空心描边 = `!=`，🔴 红边 = 结果不符合预期。

3. **Files · import & write**（顶部）—
   - **Import 菜单** 提供三种 `allowedContentTypes`：`.plainText only` / `.lrc only` / `[.plainText, .lrc]`，选完读文件真实 UTType 再验证。
   - **Write** 用 `.fileExporter` 写随机 `.txt` / `.lrc` 到 Files 选定文件夹。

## 关键笔记

- **identifier 即 rawValue**：`UTType.identifier` 就是 Apple 注册的那串字符串，如 `.plainText` → `public.plain-text`。

- **相等是身份，不是继承**：`.plainText.conforms(to: .text)` 为 `true`，但 `.plainText == .text` 为 `false`。equality 比的是 identifier，不是 conformance。

- **从扩展名/MIME 构造会解析回已声明类型**：`UTType(filenameExtension: "txt") == .plainText`、`UTType(mimeType: "text/html") == .html` 均为 `true`。

- **未声明的扩展名 → dynamic 类型**：`UTType(filenameExtension: "madeupext")` 得到 `dyn.*`，不 conform `.plainText`；但同一未知扩展名两次构造彼此 `==`（dynamic identifier 是确定性派生的）。

- **`.lrc` 用 exported UTType 声明**（见 `Info.plist` 的 `UTExportedTypeDeclarations` 与 `UTType+LRC.swift`）：
  - 声明 `conformsTo public.plain-text`，所以 `.lrc.conforms(to: .plainText)` 为 `true`。
  - 因此 **`.plainText only` 入口本来就能选中 `.lrc` 文件**（按 conformance 放行）——`[.plainText, .lrc]` 里的 `.lrc` 在此是表意/防御性的，并非必需。
  - 只有想 **精确限定**（`.lrc only`，挡掉 `.txt`）或 `.lrc` **未声明为 plainText 子类** 时，显式列 `.lrc` 才不可替代。
  - 用 `UTType(importedAs:)`（不是 `exportedAs:`）拿静态常量，它按 identifier 查找已声明类型，故 `.lrc == UTType("com.example.demouttypetext.lrc")`。

- **运行时陷阱**：exported 声明写在 app bundle 的 Info.plist，**只在真机/模拟器运行 app 时由系统注册后才生效**。SwiftUI Preview / 单元测试里不加载它，`.lrc` 会退化成 `dyn.*`，相关相等检查会变红。

- **多个 Button 同处一个 List row** 会合并点击区域 —— 两个 Write 按钮各加了 `.buttonStyle(.borderless)` 才能各点各的。

## Build

```sh
xcodegen generate --spec project.yml
xcodebuild -project DemoUTTypeText.xcodeproj -scheme DemoUTTypeText \
  -destination 'generic/platform=iOS Simulator' build
```
