import Foundation

// let format = "名称: %1$s, 数量：%2$d, 百分比: %3$.2f"
let format = "名称:  %1$@, 数量：%2$@, 百分比: %3$.2@"
let string = NSString(format: format as NSString, "ok" as NSString, "3000", "8")

print(string)

