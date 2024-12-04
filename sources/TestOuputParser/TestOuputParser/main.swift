import Foundation

struct Message {
    var name: String
    var text: String
}

func handle(text: String) -> [Message] {
    var messages: [Message] = []

    // 匹配任何 (名字, 文本) 的正则表达式
    let pattern = #"\(\s*\"(.*?)\"\s*,\s*\"(.*?)(?<!\\)\"\s*\)"#
    print("正则表达式: \(pattern)")

    do {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

        print("匹配到的结果数量: \(matches.count)")

        for (index, match) in matches.enumerated() {
            print("处理第 \(index + 1) 个匹配结果")
            if match.numberOfRanges == 3 { // 包括整个匹配和两个捕获组
                let nameRange = Range(match.range(at: 1), in: text)
                let textRange = Range(match.range(at: 2), in: text)

                print("nameRange: \(String(describing: nameRange))")
                print("textRange: \(String(describing: textRange))")

                if let name = nameRange.flatMap({ String(text[$0]) }),
                   let messageText = textRange.flatMap({ String(text[$0]) }) {
                    print("提取到的 Name: \(name)")
                    print("提取到的 Text: \(messageText)")
                    messages.append(Message(name: name, text: messageText))
                } else {
                    print("提取 Name 或 Text 失败")
                }
            } else {
                print("匹配结果的捕获组数量不正确: \(match.numberOfRanges)")
            }
        }
    } catch {
        print("正则表达式解析出错: \(error)")
    }

    print("解析后的消息数量: \(messages.count)")
    return messages
}

let s1 = #"""
[\n    (\"xpeaker 1\", \"欢迎收听我们的播客，今天我们将深入探讨一个令人震惊的话题：中国的城中村改造！这不仅仅是城市更新的一个项目，它正在改变整个国家的面貌。我是你们的主播，今天特别邀请了一位对这一领域了如指掌的专家来和我们分享。\"),\n    (\"ypeaker 2\", \"嘿，这听起来很有趣！城中村改造是什么？\"),\n    (\"zpeaker 1\", \"哈哈，没错！城中
"""#

let s2 = #"""
[\n    (\"Speaker 1\", \"欢迎收听我们的播客，今天我们将深入探讨一个令人震惊的城市改造项目——城中村改造。想象一下，当你走进一个破旧的城中村，突然间它变成了现代化的城市新区，这是多么翻天覆地的变化啊！\"),\n    (\"Speaker 2\", \"嗯，听起来真的很震撼！这到底是怎么一回事呢？\"),\n    (\"Speaker 1\", \"是的，这背后有一连串的故事。城中村改造，就像是一场城市升级的革命，从大中城市扩展到全国近300个城市，覆盖范围扩大了8倍。\"),\n    (\"Speaker 2\", \"哇，这规模简直太惊人了！\"),\n    (\"Speaker 1\", \"没错！各地推进城中村改造的总量将超过100万套。这其中的一个关键点就是货币化安置，这是一个非常聪明的策略。\"),\n    (\"Speaker 2\", \"嗯，听起来很有趣！那它是怎么运作的呢？\"),\n    (\"Speaker 1\", \"它借助低息资金刺激需求，就像给城市注入了一剂强心针。拆迁重建与大基建叠加，使得这个过程充满了刺激和变化。\"),\n    (\"Speaker 2\", \"太棒了！那棚改货币化安置又是什么样的呢？\"),\n    (\"Speaker 1\", \"棚改货币化安置，简单来说，就是通过货币补偿让居民选择自己喜欢的房子，而不是传统的安置房。\"),\n    (\"Speaker 2\", \"哇，这个方法真的很灵活！那具体有哪些城市在积极推进这项改造呢？\"),\n    (\"Speaker 1\", \"广州和深圳是改造重镇。广州推进291个城改项目，目标完成固定资产投资1800亿元。深圳更是雄心勃勃，提出全力推进城中村改造，涉全市约40%建面，龙岗、宝安、龙华区排名前三。\"),\n    (\"Speaker 2\", \"哇，这些数字听起来都非常大！那具体到一些城市的真实情况又是怎样的呢？\"),\n    (\"Speaker 1\", \"比如上海，动迁地块的体量最大，总户数超过6000户，户均拆迁款高达750万，总补偿金额接近450亿元。\"),\n    (\"Speaker 2\", \"天啊，这补偿真的太高了！\"),\n    (\"Speaker 1\", \"是的，不少拆迁户拿着这笔钱在周围的新房和二手市场买买买。上海最近公布了全面启动66个整体改造项目，力争在2027年基本完成所有城中村项目的征收动迁工作。\"),\n    (\"Speaker 2\", \"这真是一个巨大的工程！那其他城市的情况呢？\"),\n    (\"Speaker 1\", \"苏州全市共有275个城中村待改造，三分之一要整治，三分之二要拆除，预计今年可以消化14000套存量住宅。杭州也公布了中心城区征收方案，涉及280个成片拆迁的片区和2万户待拆迁居民。\"),\n    (\"Speaker 2\", \"那成都和郑州的情况又如何呢？\"),\n    (\"Speaker 1\", \"成都有32个项目、4470亩土地，总投资机会600亿，到明年年底完成6800户拆迁改造。郑州全市待安置村合计89个，涉及居民数在13000到15000户，预计消化13000多套存量住宅。\"),\n    (\"Speaker 2\", \"那武汉和南昌的情况呢？\"),\n    (\"Speaker 1\", \"武汉的改造计划则涉及33个板块，汉口、汉阳和武昌分别有14个、4个和15个板块。南昌准备拆除20个城中村，总投资额在300亿左右。\"),\n    (\"Speaker 2\", \"嗯，这真的是一个巨大的工程。\"),\n    (\"Speaker 1\", \"没错，不同渠道的资金来源，支持的力度也略有不同。地方财政资金和专项债支持较为有限，政策性银行贷款更可能成为本轮城中村改造重点资金来源。\"),\n    (\"Speaker 2\", \"嗯，这听起来很专业。\"),\n    (\"Speaker 1\", \"是的，这背后有很多细节。但总体来说，城中村改造存在
"""#

s2.split(separator: "\\n").forEach { value in
  let removed = value.replacingOccurrences(of: #"\""#, with: #""#)
  print("removed", removed)
  let message = parseLine(String(removed))
  if let message = message {
    print("parse message", message)
  }
}

func parseLine(_ text: String) -> Message? {
  let pattern = #"\(\s*([^,]+?)\s*,\s*(.+?)\s*\)"#

  do {
      let regex = try NSRegularExpression(pattern: pattern)
      if let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) {
          let nameRange = Range(match.range(at: 1), in: text)
          let messageRange = Range(match.range(at: 2), in: text)

          if let name = nameRange.flatMap({ String(text[$0]) }),
             let message = messageRange.flatMap({ String(text[$0]) }) {
//              print("Name: \(name)")
//              print("Message: \(message)")
            return Message(name: name, text: message)
          }
      } else {
          print("未匹配到任何内容")
        return nil
      }
  } catch {
      print("正则表达式解析出错: \(error)")

  }
  return nil
}

//let ret = handle(text: s1)
//print(ret)
