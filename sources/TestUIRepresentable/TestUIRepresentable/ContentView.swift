//
//  ContentView.swift
//  TestUIRepresentable
//
//  Created by Brook_Mobius on 8/3/23.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      BugDemoView(modelObject: mo)
    }
    .padding()
  }
}

class ModelObject : ObservableObject{
  @Published var text = "Model Text"
  @Published var color: UIColor = .blue
  
//  init() {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//      self.text = "33333"
//    }
//  }
}

//struct MyTextView : UIViewRepresentable {
//  @ObservedObject var modelObject : ModelObject
//
//    func makeUIView(context: Context) -> UITextView {
//        let result = UITextView()
//        result.isEditable = true
//        return result
//    }
//    func updateUIView(_ view: UITextView, context: Context) {
//        view.text = modelObject.text
//    }
//}

//struct BugDemoView : View{
//    @ObservedObject var modelObject : ModelObject
//    var body : some View{
//        VStack{
//            MyTextView(modelObject: modelObject)
//            Button(action: {
//                self.modelObject.text = "ouch"
//            }){
//                Text("Button")
//            }
//        }
//    }
//}

struct MyTextView : UIViewRepresentable {
  @Binding var text: String
  @Binding var textColor: UIColor
  
  func makeUIView(context: Context) -> UITextView {
    let result = UITextView()
    result.isEditable = true
    
    return result
  }
  
  func updateUIView(_ view: UITextView, context: Context) {
    view.text = text
    view.textColor = textColor
  }
}



struct BugDemoView : View {
  @ObservedObject var modelObject = ModelObject()
  var body : some View{
    VStack{
      MyTextView(text: $modelObject.text, textColor: $modelObject.color)
      Button(action: {
        self.modelObject.text = "ouch22"
      }){
        Text("Button")
      }
    }
  }
}




#if DEBUG

var mo = ModelObject()

struct BugDemoView_Preview: PreviewProvider {
  static var previews: some View {
    BugDemoView(modelObject: mo)
  }
  
}
#endif
