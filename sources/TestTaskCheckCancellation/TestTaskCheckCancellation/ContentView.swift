//
//  ContentView.swift
//  TestTaskCheckCancellation
//
//  Created by Brook_Mobius on 8/22/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
          let task = Task {
            do {
              print(#line, "task begin")
//              try Task.checkCancellation()
//              print(#line, "checkCancellation 1")
              
              let (data, resp) = try await URLSession.shared.data(from: URL(string: "https://apple.com")!)
              print(#line, "task finished")
              
              try Task.checkCancellation()
              print(#line, "checkCancellation 2")
              
              print(#line, "task end", data.count, resp)
            } catch {
              print(#line, "task end", error)
            }
          }
          print(#line, "sleep begin")
          DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
//            Thread.sleep(forTimeInterval: 3)
            print(#line, "sleep end")
            task.cancel()
          }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
