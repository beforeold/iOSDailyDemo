//
//  Tester.swift
//  TestDateCrash
//
//  Created by BrookXy on 2022/4/1.
//

import Foundation

class Tester: NSObject {
    @objc static func test() {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dfmatter.date(from: "2020/02/02 17:22:38")
        let dateStamp: TimeInterval = date!.timeIntervalSince1970
        print(dateStamp)
    }
}

/*
 
 作者：Zaki丶
 链接：https://juejin.cn/post/7077493937383948295
 来源：稀土掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
