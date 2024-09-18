//
//  ContentView.swift
//  TestPreviewMacro
//
//  Created by beforeold on 6/13/24.
//

import SwiftUI

struct ContentView: View {
  @Binding var flag: Bool
  
  var body: some View {
     Toggle("ok", isOn: $flag)
//    Text("hello")
    
//    VStack {
//      Toggle("ok", isOn: $flag)
//      
//      Image(systemName: "globe")
//        .imageScale(.large)
//        .foregroundStyle(.tint)
//      Text("Hello, world!")
//    }
//    .padding()
  }
}

@available(iOS 17.0, *)
#Preview {
  ForEach([true, false], id: \.self) { value in
    ContentView(flag: .constant(value))
  }
//  ContentView(flag: .constant(false))
}

@available(iOS 17.0, *)
#Preview("fixedLayout", traits: .fixedLayout(width: 300, height: 300)) {
  ContentView(flag: .constant(true))
}

@available(iOS 17.0, *)
#Preview("sizeThatFitsLayout", traits: .sizeThatFitsLayout) {
  ContentView(flag: .constant(true))
    .preferredColorScheme(.dark)
}

/*
@available(iOS 18.0, *)
#Preview {
  @Previewable @State var flag = false
  ContentView(flag: $flag)
}
*/


// Xcode 15.4
/*
 @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
 struct $s16TestPreviewMacro33_8B7B46E860DDA53F70F6387F2AD63977Ll0B0fMf_15PreviewRegistryfMu_: DeveloperToolsSupport.PreviewRegistry {
     static var fileID: String {
         "TestPreviewMacro/ContentView.swift"
     }
     static var line: Int {
         29
     }
     static var column: Int {
         1
     }

     static func makePreview() throws -> DeveloperToolsSupport.Preview {
         DeveloperToolsSupport.Preview {
         //  ForEach([true, false], id: \.self) { value in
         //    ContentView(flag: .constant(value))
         //  }
           ContentView(flag: .constant(false))
         }
     }
 }
 */

// Xcode 16.0
/*
 @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
 struct $s16TestPreviewMacro33_8B7B46E860DDA53F70F6387F2AD63977Ll0B0fMf_15PreviewRegistryfMu_: DeveloperToolsSupport.PreviewRegistry {
     static var fileID: String {
         "TestPreviewMacro/ContentView.swift"
     }
     static var line: Int {
         26
     }
     static var column: Int {
         1
     }

     static func makePreview() throws -> DeveloperToolsSupport.Preview {
         DeveloperToolsSupport.Preview {
             func __b_buildView(@SwiftUI.ViewBuilder body: () -> any SwiftUI.View) -> any SwiftUI.View {
                 body()
             }
             return __b_buildView {
               ContentView(flag: .constant(true))
             }
         }
     }
 }
 */

/*
 @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
 struct $s16TestPreviewMacro33_8B7B46E860DDA53F70F6387F2AD63977Ll0B0fMf0_15PreviewRegistryfMu_: DeveloperToolsSupport.PreviewRegistry {
     static var fileID: String {
         "TestPreviewMacro/ContentView.swift"
     }
     static var line: Int {
         31
     }
     static var column: Int {
         1
     }

     static func makePreview() throws -> DeveloperToolsSupport.Preview {
         if #available(iOS 18.0, *) {
             DeveloperToolsSupport.Preview {
                 struct __P_Previewable_Transform_Wrapper: SwiftUI.View {
                     @State var flag = false

                     var body: some SwiftUI.View {
                       ContentView(flag: $flag)
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
