# 第 2 课：解析书签、维护 Stale，以及实战中的失败场景

## 1. 冷启动：从 Data 回到 URL

上一课把 **`bookmarkData` 写入存储**后，启动时用 **`URL(resolvingBookmarkData:…)`** 还原：

```swift
var stale = false
let url = try URL(
    resolvingBookmarkData: savedData,
    options: [.withoutUI],  // 常见：不要弹系统 UI；与平台允许的选项组合使用
    relativeTo: nil,
    bookmarkDataIsStale: &stale
)
```

然后（在需要时）：

```swift
guard url.startAccessingSecurityScopedResource() else {
    // 解析成功但当前无法获得访问权：见第 3 节
    return
}
// 在此 URL 上枚举文件、读内容等
```

**注意**：`resolvingBookmarkData` **抛错**与 **返回后 startAccessing 失败** 是两类问题，产品上要分开提示。

---

## 2. Stale 是什么？如何「维护」？

### 2.1 含义

**`bookmarkDataIsStale == true`** 表示：系统认为你保存的那段 bookmark **已过期**（例如目标移动、卷信息变化等）。  
**多数情况下，解析仍然会成功**，并给你一个**当前仍可用**的 `URL`——但以后应使用**新生成**的 bookmark，否则可能一次次被标 stale 或在未来某次失败。

### 2.2 标准维护动作（推荐固定写法）

在 **解析成功** 且你已经 **`startAccessingSecurityScopedResource()` 成功**（或业务流程允许访问该 URL）的前提下：

```swift
if stale {
    let newData = try url.bookmarkData(
        options: [],  // iOS 按允许的选项；macOS 按需使用安全作用域相关 option
        includingResourceValuesForKeys: nil,
        relativeTo: nil
    )
    // 用 newData 覆盖持久化存储（Keychain / 文件等）
}
```

这就是 **stale 维护**：**不抛错、不丢访问权**时，用**当前 URL** 刷新 bookmark 并保存。

### 2.3 维护时机

- **每次冷启动**从存储读出 bookmark 并解析后检查一次 `stale` 即可；无需每个文件 IO 都解析。  
- 若某次操作前你发现 bookmark **很久没刷新**，也可以在使用前再解析一次（按需）。

---

## 3. 失败场景：不要和 stale 混为一谈

| 现象 | 常见原因 | rough 处理方式 |
|------|----------|----------------|
| `resolvingBookmarkData` **抛错**（如无权打开） | 重装应用、用户撤权、书签对应资源已不可达 | **无法**靠刷新 stale 修复；清空无效存储，引导用户 **重新选择** |
| 解析成功但 **`startAccessingSecurityScopedResource()` 为 false** | 同上或系统策略 | 同上，**删除无效 bookmark**，避免下次启动反复报错 |
| 仅 **`stale == true`**，解析与访问均成功 | 路径/元数据变化 | **重新生成 bookmark 并保存**（第 2.2 节） |

**iOS 上特别提醒**：用户**卸载再装**后，文档选取器授予的访问通常 **不延续**；钥匙串里可能残留旧 `Data`，解析常失败或权限错误——这 **不是**「多调一次 bookmarkData 就能好」，而要 **重新授权（再选文件夹）**。

---

## 4. 与「永久」的关系（纠偏）

- Bookmark **不是永久通行证**：stale、移动、重装、撤权都会导致 **必须更新策略或重新选路径**。  
- **App 自己的 Documents** 在卸载后会被系统清理；把文件放沙盒 **不解决**「用户任意目录跨卸载」需求。  
- 跨设备/跨重装仍要可靠到达的数据，通常要考虑 **iCloud / 自有云端**，书签只解决 **当前安装周期内** 「少让用户点选」。

---

## 5. 日志与调试建议（练习向）

在开发阶段可以对齐你产品里的日志：

- 解析 **成功 / 失败**（含 error 描述）。  
- **`stale` 的真假**、是否执行了 **写回存储**。  
- **`startAccessing` 是否成功**。  

这样第一次遇到「重装后读不出」时，日志能快速区分：**解析失败** 还是 **访问权失败**。

---

## 6. 本课小结（自查清单）

- [ ] 能在解析后正确使用 **`bookmarkDataIsStale`**，并在 `true` 时 **覆盖保存**新 bookmark。  
- [ ] 能区分 **stale 维护** vs **权限/重装导致的彻底失败**。  
- [ ] 对失败路径有明确产品行为：**不无限重试坏数据**，**清除或标记无效 bookmark**，引导重新选择。  
- [ ] 清楚 **iOS 与 macOS** 在 bookmark **options** 上的差异，不混用示例代码。

---

## 7. 两课串联：最小 mental model

1. **选 URL →（可选长期 accessing）→ 生成 `bookmarkData` → 持久化。**  
2. **启动 → 读数据 → 解析 → accessing → 若 stale 则刷新并保存 → 业务读文件。**  
3. **任一步权失败 / 解析失败 → 清掉坏数据，请用户再选。**

到此，你已具备在 Demo 或小型功能里 **完整走通 bookmark 链路** 的思路；更复杂的同步、多书签、迁移策略可在该模型上扩展。

**返回目录**：[README.md](./README.md)
