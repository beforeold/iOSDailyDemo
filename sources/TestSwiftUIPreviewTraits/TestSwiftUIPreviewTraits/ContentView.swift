//
//  ContentView.swift
//  TestSwiftUIPreviewTraits
//
//  Created by beforeold on 6/13/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
//      Toggle(isOn: .constant(true)) {
//        Text("toggle")
//      }
      
      Text("hello world")
    }
    .padding()
//    .frame(maxWidth: .infinity)
    .background(.blue)
  }
}

//struct Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//      .previewLayout(.fixed(width: 200, height: 200))
////      .previewLayout(.sizeThatFits)
////      .previewLayout(.sizeThatFits)
//  }
//}


#Preview {
  ContentView()
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
  ContentView()
}

@available(iOS 17.0, *)
#Preview("sizeThatFitsLayout", traits: .sizeThatFitsLayout) {
  ContentView()
}

struct Demo: View {
  class Model: ObservableObject { }
  
  @StateObject
  var viewModel: Model
  
  var body: some View {
    Text("hello demo")
  }
}

@available(iOS 18.0, *)
#Preview {
  @Previewable var age = 5
  @Previewable @StateObject var viewModel: Demo.Model = .init()
  // @State var age = 5
  // ContentView()
  Demo(viewModel: viewModel)
}

/*
 @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
 struct $s24TestSwiftUIPreviewTraits33_81A8B530F3AD072A3746CA0E8DBAB693Ll7PreviewfMf2_15PreviewRegistryfMu_: DeveloperToolsSupport.PreviewRegistry {
     static var fileID: String {
         "TestSwiftUIPreviewTraits/ContentView.swift"
     }
     static var line: Int {
         61
     }
     static var column: Int {
         1
     }

     static func makePreview() throws -> DeveloperToolsSupport.Preview {
         if #available(iOS 18.0, *) {
             DeveloperToolsSupport.Preview {
                 struct __P_Previewable_Transform_Wrapper: SwiftUI.View {
                     var age = 5

                     @StateObject var viewModel: Demo.Model = .init()

                     var body: some SwiftUI.View {
                       // @State var age = 5
                       // ContentView()
                       Demo(viewModel: viewModel)
                     }
                 }
                 return __P_Previewable_Transform_Wrapper()
             }
         } else {
             throw DeveloperToolsSupport.PreviewUnavailable()
         }
     }
 }
 */
