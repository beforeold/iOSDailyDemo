//
//  ContentView.swift
//  TestOCTryCatch
//
//  Created by xipingping on 5/23/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Button("tryCatch") {
        // NSObject().tryCatch()

        tryCatch {
          // raise a nsexception here
          let excep = NSException(name: NSExceptionName("test"), reason: "test", userInfo: nil)
          excep.raise()
        }
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
