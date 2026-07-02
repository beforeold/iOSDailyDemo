# DemoServeSim 上下文

本 demo 与其他 demo 相互隔离。

除非用户明确指示，agent 只能编辑该目录下的文件。

## 用途

`DemoServeSim` 是一个小型 SwiftUI playground 应用，用来体验
[EvanBacon/serve-sim](https://github.com/EvanBacon/serve-sim)——
"Apple 模拟器版的 `npx serve`"。`serve-sim` 本身是运行在宿主机上的 Node.js
CLI 工具，没有任何 iOS app 组件：它通过 `simctl` 把已启动模拟器的画面
流式传输到浏览器，并把点击、手势、键盘输入以及注入的摄像头画面反向传回
模拟器。这个 app 存在的唯一目的，就是给这条流式/控制通道提供一个
值得操作的对象。

界面上的各个区块分别对应 `serve-sim` 能驱动或观察的能力：

- 点击计数器（浏览器转发的按钮点击）。
- 文本输入框（键盘输入 / `serve-sim type`）。
- 可拖动方块（触摸手势 / `serve-sim gesture`）。
- 主题色切换按钮（用于确认视频流本身是否实时刷新）。
- 实时摄像头预览（`AVCaptureVideoPreviewLayer`），用于观察
  `serve-sim camera <bundle-id>` 的画面注入效果。
- 每次交互都会调用 `os.Logger`，可通过 `serve-sim` 的日志转发查看。

## 针对本 demo 试用 serve-sim

先构建并在模拟器上启动这个 app（构建命令见下文），然后在宿主 Mac 上
任意目录执行：

```sh
npx serve-sim
# → 预览地址 http://localhost:3200
```

打开预览页面后：

- 在浏览器画面里点击 "Tap me"，观察计数器增加。
- 用 `serve-sim type "hello"` 向文本框输入文字。
- 在浏览器画面里拖动彩色方块，测试手势转发。
- 在 app 内打开 "Show camera preview"，然后运行
  `serve-sim camera com.example.demoservesim --webcam`（或 `--file <路径>`）
  热切换模拟器摄像头画面，并在预览层里查看效果。

`serve-sim` 需要安装了 Xcode 命令行工具的 macOS，且仅支持 Apple Silicon；
它不会运行在这个 app 内部，也不会运行在模拟器里。

### 已知坑：多个模拟器同时启动时，命令可能挂到错误的设备

如果本机同时启动了多个模拟器（例如同时有 iPhone 17 Pro 和 iPhone 17
处于 Booted 状态），`xcrun simctl ... booted` 和 `serve-sim`（不带 `-d`
参数时）默认选中的设备可能并不一致，导致：

- 你往「看起来是当前模拟器」的设备上重新安装/启动了新版本 app，
- 但 `serve-sim` 实际streaming/控制的是另一台设备上跑着的旧版本，
- 看起来像是画面卡住不刷新、界面改动没生效。

排查方法：

```sh
xcrun simctl list devices booted        # 确认到底有几台设备处于 Booted
npx serve-sim --list -q                 # 确认 serve-sim 实际挂载的 device udid
```

确认后续所有 `simctl install` / `simctl launch` / `serve-sim ... -d` 命令
都显式带上同一个 `<udid>`，而不是依赖默认的 `booted` 关键字。

## 构建命令

```sh
xcodegen generate --spec project.yml
xcodebuild -project DemoServeSim.xcodeproj -scheme DemoServeSim -destination 'generic/platform=iOS Simulator' build
```
