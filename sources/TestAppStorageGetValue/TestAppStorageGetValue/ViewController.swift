//
//  ViewController.swift
//  TestAppStorageGetValue
//
//  Created by Brook_Mobius on 4/25/23.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .gray
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
    view.addGestureRecognizer(tap)
  }
  
  @objc func onTap() {
    
    
    print("onTap")
    ViewController.printString()
    
    
    ViewModel.shared.update()
    return
    
    let vc = UIHostingController(rootView: TextView())
    present(vc, animated: true)
  }
  
  static func printString() {
    let string = UserDefaults.standard.string(forKey: "stringKey")
    print("UserDefaults string", string ?? "none")
    print("ViewModel string", ViewModel.shared.string)
    
    let flag = UserDefaults.standard.bool(forKey: "flagKey")
    print("UserDefaults flag", flag)
    print("ViewModel flag", ViewModel.shared.flag)
    
//    let data = UserDefaults.standard.data(forKey: "BoolWrapper")
//    let boolWrapper = data.flatMap { try? JSONDecoder().decode(BoolWrapper.self, from: $0) }
//    print("UserDefaults boolWrapperAsBool", boolWrapper?.flag.description ?? "none")
//    print("ViewModel boolWrapperAsBool", ViewModel.shared.boolWrapperAsBool)
    
    print("")
  }
}



import SwiftUI

struct BoolWrapper: Codable {
  var flag: Bool
}

class ViewModel: ObservableObject {
  @AppStorage("stringKey") var string = "defaultString"
  
  @AppStorage("flagKey", store: .standard) var flag = false
  
  @AppStorage("BoolWrapper") var boolWrapper: Data = {
    let data = try! JSONEncoder().encode(BoolWrapper(flag: false))
    
    return data
  }()
  
  var boolWrapperAsBool: Bool {
    get {
      let ins = try! JSONDecoder().decode(BoolWrapper.self, from: boolWrapper)
      
      return ins.flag
    }
    
    set {
      let data = try! JSONEncoder().encode(BoolWrapper(flag: newValue))
      self.boolWrapper = data
    }
  }
  
  static let shared: ViewModel = .init()
  
  func update() {
//    boolWrapperAsBool = true
//
//    string += "_1"
    
    UserDefaults.standard.set(true, forKey: "flagKey")
    UserDefaults.standard.set("defaultString_1", forKey: "stringKey")
    
    
//    flag = true
    
        
    print("after update")
    ViewController.printString()
    UserDefaults.standard.synchronize()
  }
}

struct TextView: View {
  @StateObject var viewModel: ViewModel = .shared
  
  var body: some View {
    VStack(spacing: 20) {
      Button("Update") {
        print("Update")
        
        viewModel.update()
      }
      
      Text(viewModel.string)
        .foregroundColor(viewModel.flag ? .green : .red)
      
//      Text("BoolWrapper \(viewModel.boolWrapperAsBool.description)")
//        .foregroundColor(viewModel.boolWrapperAsBool ? .green : .red)
      
      Button("Sync") {
        print("Sync")
        UserDefaults.standard.synchronize()
      }
    }
  }
}
