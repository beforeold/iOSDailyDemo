# Agent Instructions

This repository contains many independent demo projects under `sources/`.
When working in this repo, agents must treat the currently requested demo as
the primary working context and avoid drifting into unrelated demos.

## Default Scope

- Each new demo should have one explicit working directory, for example
  `sources/DemoNewFeature/`.
- Unless the user says otherwise, the allowed write scope is limited to the
  current demo directory.
- Do not edit, rename, format, clean up, or refactor other `sources/*` demos.
- Do not update root-level files unless the user explicitly asks for it.
- If a shared or root-level file seems necessary, explain why before editing it.

## Reading Other Demos

- Other demo directories are not part of the task by default.
- Only read another demo when the user explicitly names it as a reference.
- Treat named reference demos as read-only unless the user explicitly allows
  edits there.
- When using a reference demo, copy only the relevant pattern. Do not apply
  broad changes across multiple demos.

## Before Editing

For any non-trivial task, first identify:

- The current demo directory.
- The files or directories you expect to read.
- The files or directories you expect to modify.
- Any reference demo directories, if explicitly provided by the user.

If the task requires going outside the current demo directory, pause and state
the reason before making those edits.

## Search Discipline

Prefer scoped searches:

```sh
rg "keyword" sources/DemoNewFeature
rg --files sources/DemoNewFeature
```

Avoid broad repo-wide searches unless they are necessary to locate a named
reference, project configuration, or build setting.

## Build And Verification

- Run build or verification commands only for the current demo whenever
  possible.
- Do not run broad commands that build or modify unrelated demos.
- If a current demo has its own `Package.swift`, `.xcodeproj`, or README, use
  that local configuration first.

## UI Design

- When creating or restyling demo UI, first read the root `DESIGN.md` and apply
  its iOS 16+ UIKit design tokens, component rules, and visual guardrails.

## Code Style

- Swift code uses **2-space indentation** (no tabs). Match this in all new and
  edited Swift files.

## Git And Attribution

- Do not include agent or tool provider information in any git operation or
  generated output.
- This applies to branch names, commit messages, PR/MR titles and descriptions,
  and tags.
- Do not add provider attribution to file comments or headers, either.
- Specifically, do not add `Co-Authored-By:` agent lines, "Generated with …"
  footers, or provider name tags.

## Creating New Demos

Use the `$new-demo` skill when the user asks to create, scaffold, initialize,
or add a new iOS demo project under `sources/`.

New iOS demos should use iOS 16.0 as the minimum deployment target unless the
user explicitly requests a different version.

New demo names should follow the `Demo___` pattern: use `Demo` as the prefix
and replace `___` with a concise PascalCase feature name, for example
`DemoNewFeature` or `DemoHelloWorld`.

The skill creates an isolated XcodeGen-backed demo at:

```text
sources/<DemoName>/
```

It should be preferred over manually creating Xcode projects because it keeps
the generated files predictable and scoped to one demo directory.

Expected generated files include:

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

Default usage:

```text
Use $new-demo to create a new iOS demo named DemoNewFeature under sources.
```

The bundled script can also be run directly:

```sh
python3 ~/.codex/skills/new-demo/scripts/create_xcodegen_demo.py --repo-root . --name DemoNewFeature --deployment-target 16.0
```

When using `$new-demo`:

- Normalize requested demo names to the `Demo___` pattern before scaffolding.
- Keep the write scope limited to `sources/<DemoName>/`.
- Do not modify other demos while scaffolding the new one.
- Do not update root-level files unless explicitly requested.
- Do not add header comments to generated project files.
- Use 2-space indentation for Swift source files.
- Use iOS 16.0 as the minimum deployment target unless instructed otherwise.
- Prefer `xcodegen generate --spec sources/<DemoName>/project.yml` for project
  regeneration.
- Verify with the new demo's own Xcode project and scheme only.

## Suggested User Prompt Template

Users can start new demo work with a prompt like:

```text
Current demo: sources/DemoNewFeature/
Only edit files under this directory.
Other sources/* demos may be read only if I explicitly name them as references.
Before editing, list the paths you plan to read and modify.
After implementation, run only this demo's relevant build or checks.
```

## Optional Per-Demo Context

For larger demos, add a local context file such as
`sources/DemoNewFeature/CONTEXT.md` with:

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
