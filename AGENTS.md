# Agent 使用说明

本仓库在 `sources/` 目录下包含大量相互独立的 demo 项目。
在本仓库中工作时，agent 必须将当前请求所涉及的 demo 作为主要工作范围，
避免漂移到无关的 demo 中。

## 语言

- 与用户的会话交流优先使用简体中文。
- 代码注释同样优先使用简体中文，除非用户明确要求使用其他语言，
  或所在文件已统一使用英文注释（此时应与该文件保持一致）。

## 默认范围

- 每个新 demo 应有一个明确的工作目录，例如 `sources/DemoNewFeature/`。
- 除非用户另有说明，允许写入的范围仅限于当前 demo 目录。
- 不要编辑、重命名、格式化或重构其他 `sources/*` demo。
- 除非用户明确要求，不要更新仓库根级别的文件。
- 如果确有必要编辑共享文件或根级别文件，需先说明原因再进行编辑。

## 阅读其他 Demo

- 默认情况下，其他 demo 目录不属于当前任务范围。
- 只有当用户明确指定某个 demo 作为参考时，才可以阅读它。
- 除非用户明确允许编辑，否则应将指定的参考 demo 视为只读。
- 使用参考 demo 时，只借鉴相关的模式，不要跨多个 demo 做大范围改动。

## 编辑前的准备

对于任何非平凡的任务，先明确以下内容：

- 当前 demo 目录。
- 预计需要阅读的文件或目录。
- 预计需要修改的文件或目录。
- 用户明确提供的参考 demo 目录（如果有）。

如果任务需要超出当前 demo 目录的范围，先暂停并说明原因，再进行相应编辑。

## 搜索原则

优先使用范围受限的搜索：

```sh
rg "keyword" sources/DemoNewFeature
rg --files sources/DemoNewFeature
```

除非确有必要定位某个明确指定的参考对象、项目配置或构建设置，
否则应避免进行仓库级别的全局搜索。

## 构建与验证

- 尽量只针对当前 demo 运行构建或验证命令。
- 不要运行会构建或修改无关 demo 的大范围命令。
- 如果当前 demo 已有自己的 `Package.swift`、`.xcodeproj` 或 README，
  优先使用该本地配置。

## UI 设计

- 在创建或重新设计 demo UI 时，先阅读根目录下的 `DESIGN.md`，
  并应用其中 iOS 16+ UIKit 设计规范、组件规则与视觉约束。

## 代码风格

- Swift 代码使用 **2 空格缩进**（不使用制表符）。
  在所有新增和修改的 Swift 文件中保持一致。

## Git 与署名

- 不要在任何 git 操作或生成内容中包含 agent 或工具提供方的信息。
- 该规则适用于分支名称、commit 信息、PR/MR 标题与描述，以及 tag。
- 同样不要在文件注释或文件头中添加提供方署名。
- 具体而言：不要添加 `Co-Authored-By:` agent 相关行、
  "Generated with …" 之类的结尾说明，或提供方名称标签。

## 创建新 Demo

当用户要求创建、脚手架搭建、初始化或在 `sources/` 下新增 iOS demo 项目时，
使用 `$new-demo` skill。

新的 iOS demo 应使用 iOS 16.0 作为最低部署目标，
除非用户明确要求使用其他版本。

新 demo 名称应遵循 `Demo___` 模式：以 `Demo` 作为前缀，
并将 `___` 替换为简洁的 PascalCase 功能名称，
例如 `DemoNewFeature` 或 `DemoHelloWorld`。

该 skill 会创建一个基于 XcodeGen、彼此隔离的 demo，路径为：

```text
sources/<DemoName>/
```

应优先使用该 skill 而非手动创建 Xcode 项目，
因为它能保证生成文件的可预测性，并将改动范围限定在单个 demo 目录内。

预期生成的文件包括：

```text
sources/<DemoName>/
├── <DemoName>.xcodeproj/
├── project.yml
├── CONTEXT.md
└── <DemoName>/
    ├── <DemoName>App.swift
    ├── ContentView.swift
    └── Info.plist
```

默认用法：

```text
Use $new-demo to create a new iOS demo named DemoNewFeature under sources.
```

也可以直接运行内置脚本：

```sh
python3 ~/.codex/skills/new-demo/scripts/create_xcodegen_demo.py --repo-root . --name DemoNewFeature --deployment-target 16.0
```

使用 `$new-demo` 时：

- 在搭建脚手架之前，先将用户请求的 demo 名称规范化为 `Demo___` 模式。
- 将写入范围限定在 `sources/<DemoName>/` 内。
- 在为新 demo 搭建脚手架时，不要修改其他 demo。
- 除非用户明确要求，不要更新根级别文件。
- 不要在生成的项目文件中添加文件头注释。
- Swift 源文件使用 2 空格缩进。
- 使用 iOS 16.0 作为最低部署目标，除非另有指示。
- 优先使用 `xcodegen generate --spec sources/<DemoName>/project.yml`
  重新生成项目。
- 仅使用新 demo 自身的 Xcode 项目和 scheme 进行验证。

## 建议的用户提示词模板

用户可以使用类似下面的提示词开始新的 demo 工作：

```text
Current demo: sources/DemoNewFeature/
Only edit files under this directory.
Other sources/* demos may be read only if I explicitly name them as references.
Before editing, list the paths you plan to read and modify.
After implementation, run only this demo's relevant build or checks.
```

## 可选的单个 Demo 上下文文件

对于较大的 demo，可以添加本地上下文文件，
例如 `sources/DemoNewFeature/CONTEXT.md`，内容如下：

```md
# DemoNewFeature Context

This demo is isolated from other demos.

Agents may edit only files under this directory unless explicitly instructed.

Reference demos:
- ../DemoFilePicker: file picker flow only, read-only
- ../DemoAssets: asset catalog structure only, read-only

Build command:
xcodebuild -project DemoNewFeature.xcodeproj -scheme DemoNewFeature ...
```
