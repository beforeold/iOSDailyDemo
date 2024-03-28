//
//  ContentView.swift
//  TestMainActorCallService
//
//  Created by xipingping on 3/28/24.
//

import SwiftUI

struct Service {
  static func heavyTask() async {
    print("begin", Thread.current)
    sleep(1000)
    print("end", Thread.current)
  }
}

@MainActor
class ViewModel: ObservableObject {
  func work() {
    print("work begin")

    Task {
      await self.asynWork()
    }
  }

  private func asynWork() async {
    sleep(1000)
    await Service.heavyTask()
  }
}

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()

  var body: some View {

    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .onAppear {
      viewModel.work()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
