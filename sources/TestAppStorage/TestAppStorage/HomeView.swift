//
//  HomeView.swift
//  TestAppStorage
//
//  Created by Brook_Mobius on 2023/4/6.
//

import SwiftUI

class ViewModel: ObservableObject {
  
  init() {
    print("view model init")
  }
  
  @AppStorage("settings.count")
  var count: Int = 0 {
    didSet {
      print("")
    }
  }
  
  static let shared: ViewModel = .init()
  
  @Published var flag = false
}

var sharedFlag = false {
  didSet {
    print("did set", sharedFlag)
  }
}

let sharedBinding: Binding<Bool> = .init {
  print("get value", sharedFlag)
  return sharedFlag
} set: { newValue in
  print("binding set newValue", newValue)
  sharedFlag = newValue
}


struct CustomView: View {
  @Binding var flag: Bool
  
  var body: some View {
    Text(flag ? "TTTTT" : "FFFF")
  }
}

struct HomeView: View {

  @Binding var flag: Bool
  
  @State var flag2: Bool = false {
    didSet {
      print("did set", Thread.current)
    }
  }
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Flag Value")
        if flag {
          Text("true")
        } else {
          Text("false")
        }
      }
      
      Text("count: \(countValue)")
        .onTapGesture {
          self.countValue += 10
        }
      
      
      // 在 view 上直接使用 @State 或者 @AppStorage 的处理，系统会处理线程问题
      CustomView(flag: $flag2)
        .onTapGesture {
//          self.flag2 = true
//          return
          DispatchQueue.global().async {
            self.flag2 = true
          }
        }
      
      // 通过 viewModel 进行 published 处理，刷新 UI 会有警告
      // Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
      CustomView(flag: $viewModel.flag)
        .onTapGesture {
//          self.flag2 = true
//          return
          DispatchQueue.global().async {
            viewModel.flag.toggle()
          }
        }
    }
    .background(Color(UIColor.lightGray.withAlphaComponent(0.2)))
  }
  
  // MARK: - using property
  @AppStorage("settings.count") var count: Int = 0
  
  var countValue: Int {
    get {
      count
    }

    nonmutating set {
      count = newValue
    }
  }
  
  // MARK: - using ViewModel
  @StateObject var viewModel = ViewModel.shared
//
//  var countValue: Int {
//    get {
//      viewModel.count
//    }
//
//    nonmutating set {
//      viewModel.count = newValue
//    }
//  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(flag: .constant(false))
  }
}
