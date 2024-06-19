//
//  ContentView.swift
//  TestStoreKitReceipts
//
//  Created by xipingping on 6/14/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    DebugReceiptsView()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}


func heavy() async {

}

func foo() async {
  await MainActor.run {
    //
//    heavy()
  }
}
