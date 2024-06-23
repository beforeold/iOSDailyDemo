//
//  ContentView.swift
//  TestSheet
//
//  Created by beforeold on 6/23/24.
//

import SwiftUI

//  swiftui - @State variable is not updated the first time I set it - Stack Overflow - https://stackoverflow.com/questions/74738276/state-variable-is-not-updated-the-first-time-i-set-it


// ios - SwiftUI: Opening a modal sheet with dynamic content fails only on first attempt - Stack Overflow - https://stackoverflow.com/questions/63570189/swiftui-opening-a-modal-sheet-with-dynamic-content-fails-only-on-first-attempt

struct ContentView: View {
  var body: some View {
    ShowLicenseAgreement()
  }
}

struct NameView: View {
  var name: String
  
  var body: some View {
    Text("name: \(self.name)")
  }
}

struct NameObject {
  var name: String = "nil" {
    willSet {
      print("will setname", self.name, "newValue: ", newValue)
    }
    
    didSet {
      print("didset name", self.name, "oldValue:", oldValue)
    }
  }
}

struct SheetView: View {
  @Binding
  var isShowingSheet: Bool
  
  @Binding
  var name: String
  
  init(isShowingSheet: Binding<Bool>, name: Binding<String>) {
    self._isShowingSheet = isShowingSheet
    self._name = name
    
    print("init sheet", self.isShowingSheet, name.wrappedValue)
  }
  
  var body: some View {
    VStack {
      Text("name: \(self.name)")
      
      Button(
        "Dismiss",
        action: { isShowingSheet.toggle() }
      )
    }
  }
}

struct ShowLicenseAgreement: View {
  static var index = 0
  
  @State
  private var nameObject: NameObject = .init()
  
  private static func getId() -> Int {
    index += 1
    return index
  }
  
  @State var flag = true
  
  @State
  private var isShowingSheet = false
  
  @State
  private var name = "nil"
  
  private let id: Int
  
  init() {
    self.id = Self.getId()
  }
  
  var body: some View {
    let _ = self.nameObject.name
    
//    let _ = print("body", self.nameObject.name)
    
//    let localName = nameObject.name
    
    VStack {
//      Text("name \(self.nameObject.name)")
      
      Button(action: {
//          self.name = "brook"
//          print("id: \(self.id), did set name: ", self.name)
        
        self.nameObject.name = "brook"
        print(self.nameObject.name)
        print("id: \(self.id), did set name: ", self.nameObject.name)
        
        self.isShowingSheet.toggle()
      }) {
        Text("Show License Agreement")
      }
      .overlay {
        Text(self.nameObject.name).opacity(0)
      }
    }
    .popover(
      isPresented: $isShowingSheet
    ) {
//      let nameBinding = $name
//      let _ = print("id: \(self.id), before init state name:", self.name)
//      let _ = print("id: \(self.id), before init binding name:", nameBinding.wrappedValue)
      
      let nameBinding = self.$nameObject.name
      let _ = print("id: \(self.id), before init state name:", self.nameObject.name)
      let _ = print("id: \(self.id), before init binding name:", nameBinding.wrappedValue)
      
//      SheetView(isShowingSheet: $isShowingSheet, name: nameBinding)
      NameView(name: self.nameObject.name)
      
//      let localName = self.name
//      NameView(name: localName)
    }
  }
  
  func didDismiss() {
    // Handle the dismissing action.
  }
}

#Preview {
  ContentView()
}
