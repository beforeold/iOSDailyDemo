//
//  ContentView.swift
//  TestArticleSplit
//
//  Created by xipingping on 7/9/24.
//

import SwiftUI
import SwiftUI

struct ContentView: View {


  @State private var currentPage = 0

  var body: some View {
    let slides = splitArticle(article, chunkSize: 100)

    VStack {
      Text(slides[currentPage])
        .padding()
        .animation(.easeInOut, value: currentPage)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

      HStack {
        Button(action: {
          if currentPage > 0 {
            currentPage -= 1
          }
        }) {
          Text("Previous")
        }
        .padding()
        .disabled(currentPage == 0)

        Spacer()

        Button(action: {
          if currentPage < slides.count - 1 {
            currentPage += 1
          }
        }) {
          Text("Next")
        }
        .padding()
        .disabled(currentPage == slides.count - 1)
      }
    }
    //    .padding()
    .frame(idealHeight: 240)
    .background(Color.black)
    .preferredColorScheme(.dark)
  }

  func splitArticle(_ text: String, chunkSize: Int) -> [String] {
    var chunks: [String] = []
    var currentIndex = text.startIndex

    while currentIndex < text.endIndex {
      let endIndex = text.index(currentIndex, offsetBy: chunkSize, limitedBy: text.endIndex) ?? text.endIndex
      let chunk = text[currentIndex..<endIndex]
      chunks.append(String(chunk))
      currentIndex = endIndex
    }

    return chunks
  }
}


struct ContentView2: View {

  @State private var currentPage = 0

  var body: some View {
    let slides = splitArticle(article, chunkSize: 100)

    VStack(alignment: .leading) {
      Text(slides[currentPage])
        .font(.title3)
        .padding()
        .animation(.easeInOut, value: currentPage)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

      HStack {
        Button(action: {
          if currentPage > 0 {
            currentPage -= 1
          }
        }) {
          Text("Previous")
        }
        .padding()
        .disabled(currentPage == 0)

        Spacer()

        Button(action: {
          if currentPage < slides.count - 1 {
            currentPage += 1
          }
        }) {
          Text("Next")
        }
        .padding()
        .disabled(currentPage == slides.count - 1)
      }
    }
    .padding()
    .frame(idealHeight: 240)
    .background(Color.black)
    .preferredColorScheme(.dark)
  }

  func splitArticle(_ text: String, chunkSize: Int) -> [String] {
    let paragraphs = text.components(separatedBy: "\n\n")
    var chunks: [String] = []
    var currentChunk = ""

    for paragraph in paragraphs {
      if currentChunk.count + paragraph.count + 2 <= chunkSize {
        if !currentChunk.isEmpty {
          currentChunk += "\n\n"
        }
        currentChunk += paragraph
      } else {
        if !currentChunk.isEmpty {
          chunks.append(currentChunk)
        }
        currentChunk = paragraph
      }
    }

    if !currentChunk.isEmpty {
      chunks.append(currentChunk)
    }

    return chunks
  }
}


let article: String = """
  「2024 H1 绩效评估」于今天正式启动。本次参与评估对象为 2024 年 03 月 31 日（含）前入职，且 H1 在岗满 3 个月以上的所有正式员工。



  老师们今天将收到 2 封邮件，一封是个人绩效自评的邮件，另外一封是对同事或者直接上级进行 Peer feedback 的评估邮件。请收到邮件提醒后真诚开放的填写，并务必在 2024/07/09 日 18:30 前 完成。



  绩效得分 = 业绩得分  * 0.7 + 价值观平均分 * 0.3



  结合职责与管理要求，本次绩效评估方案进行了如下升级：

  1、针对 Peer feedback 管理层的评估引入了 360 度的评估方式，将从下属 、上级、合作方多维度的收集更全维度的反馈，以辅助绩效的持续提升。其中首次开放下属针对上级在团队管理维度的评估反馈，合作方提供协作过程中的反馈，所有反馈信息将与其他 Peer feedback 的信息处理方式一致，统一由 HR 汇总处理后匿名反馈给被评估人本人及他的上级。

  2、管理者的业绩得分由团队业绩及个人业绩 2 部分组成。




  本次绩效评估各环节时间安排如下，请在截止日前完成相应环节：

  企业微信截图_1010de3c-aaf5-45d1-b87a-3f6375624d92.png
  （*自评请在 07.09 号 6:30pm 前提交，若未能按时提交，则绩效结果将在你无任何信息输入的情况下由 Manager 和 Owner 凭空想象，并无申诉权利）



  在过程中若有任何疑问，请联系支持你团队的 HRBP 老师 或 Cicely Wan 万丽君/Rio Jiu 酒瑞

  Basecamp + Monitazation：Hoth Wang 王浩

  Blazers + Growth：Nancy Guo 郭楠

  Admin+Corporate Ops+Marketing+Platform+People Ops：Rio Jiu 酒瑞
"""

#Preview {
  ContentView2()
}
