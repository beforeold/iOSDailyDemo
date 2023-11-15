//
//  main.swift
//  TestDefineRules
//
//  Created by Brook_Mobius on 11/15/23.
//

import Foundation

/*
 i would like to abstract the logic of condition of firebase remote config in the default value, and put the conditions into the value, i defined the config struct as the following struct, would like to support regex some user property, may support as many operators as possible, like regex match, or greater, less, etc. please design the struct better and implement the logic to get a configValue for a specific user with a couple of user properties

 struct Config {
   struct Condition {
     var abGroup: String
     var userProperty: String
     var needsFirstLaunch: Bool
     var configValue: String

     var regex: String?
     var someOtherOperator: String?
   }

   var conditions: [Condition]
 }


 */

print("Hello, World!")

/// 用于 AB 实验的配置
struct ABConfig<Value: Codable>: Codable {
  /// 直接下发 value
  var configInfo: Value?

  /// 下发规则本地匹配
  var conditions: [Condition]?

  struct ConfigInfo: Codable {
    var configValue: Value

    /// 对应的 abGroup 信息
    var abGroup: String
    
    /// 是否要求首次启动
    var needsFirstLaunch: Bool?
  }

  struct Rule: Codable {
    /// 校验的用户属性
    var userProperty: String

    /// 校验的操作符，包含 regex/contains/greater/less/equals
    var conditionOperator: String

    /// 校验需要对比的参数
    var conditionArg: String
  }

  struct Condition: Codable {
    var configInfo: ConfigInfo
    var rules: [Rule]
  }
}

