import PlaygroundSupport
import SwiftUI
import UIKit

struct MyView: View, PlaygroundLiveViewable {
  var playgroundLiveViewRepresentation: PlaygroundSupport.PlaygroundLiveViewRepresentation {
    .viewController(UIHostingController(rootView: self))
  }

  @State
  private var count: Int = 1

  var body: some View {
    NavigationStack {
      List(0..<100) { item in
        Button(action: { count += 1}) {
          Text("count is: \(count)")
            .foregroundColor(Color.white)
            .frame(width: 500, height: 50)
            .background(Color.blue)
        }
      }
      .frame(width: 500, height: 500)
      .navigationTitle("ok")
    }
  }
}

let label: UILabel = {
  let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
  label.text = "hello"
  return label
}()

label

MyView()

Text("ook")

// PlaygroundPage.current.liveView = MyView()
//PlaygroundPage.current.setLiveView(
//  Text("this is a text")
//)
//PlaygroundPage.current.liveView = MyView()
//PlaygroundPage.current.liveView
