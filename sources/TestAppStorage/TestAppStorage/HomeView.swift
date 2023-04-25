//
//  HomeView.swift
//  TestAppStorage
//
//  Created by Brook_Mobius on 2023/4/6.
//

import SwiftUI

class ViewModel: ObservableObject {
  @AppStorage("settings.count")
  var count: Int = 0 {
    didSet {
      print("")
    }
  }
  
  static let shared: ViewModel = .init()
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


struct HomeView: View {

  @Binding var flag: Bool
  
  var body: some View {
    VStack(spacing: 20) {
      if flag {
        Text("true")
      } else {
        Text("false")
      }
      
      Text("count: \(countValue)")
        .onTapGesture {
          self.countValue += 10
        }
    }
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
//  @StateObject var viewModel = ViewModel.shared
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
