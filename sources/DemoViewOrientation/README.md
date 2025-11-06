# DemoViewOrientation

一个 iOS SwiftUI 应用示例，演示如何实现基于视图的方向控制：在全屏视图显示时允许所有方向旋转，其他情况下锁定为竖屏。

## 功能特性

- 主界面锁定为竖屏方向
- 全屏视图支持所有方向旋转（竖屏、横屏）
- 使用 AppDelegate 方法动态控制应用支持的方向

## 实现原理

### 核心组件

1. **OrientationManager** - 单例管理器，跟踪全屏视图的显示状态
2. **AppDelegate** - 实现 `supportedInterfaceOrientationsFor` 方法，根据全屏视图状态返回支持的方向
3. **FullScreenView** - 全屏视图，在 `onAppear` 和 `onDisappear` 时更新方向状态

### 工作流程

1. 当全屏视图出现时，`OrientationManager.shared.isFullScreenPresented` 设置为 `true`
2. AppDelegate 的 `supportedInterfaceOrientationsFor` 方法被系统调用
3. 根据状态返回 `.all`（全屏视图）或 `.portrait`（其他情况）
4. iOS 系统根据返回值自动管理界面方向

## 使用方法

1. 运行应用
2. 点击"展示全屏视图"按钮
3. 在全屏视图中可以旋转设备查看不同方向
4. 关闭全屏视图后，应用锁定为竖屏

## 技术要点

- SwiftUI + UIKit 混合使用
- AppDelegate 集成到 SwiftUI App
- 使用 `@UIApplicationDelegateAdaptor` 接入 AppDelegate
- 通过状态管理实现动态方向控制

## 系统要求

- iOS 26.0+
- Xcode 26.0+
- Swift 5.0+

