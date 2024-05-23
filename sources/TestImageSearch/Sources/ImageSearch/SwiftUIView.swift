//
//  SwiftUIView.swift
//  
//
//  Created by Brook_Mobius on 5/16/24.
//

import SwiftUI
import APIService
import Dependencies

struct API: PicaAPIGetable {

  struct ResponseType: Codable {
    var value: String
  }

  static var path: String { "" }


}

class ViewModel: ObservableObject {
  @Dependency(GenerateAPIClient<API>.self) var generateClient

  @Published var count = 0

  @Published var text = "hello"

  init() {

  }

  func request() {
    Task {
      do {
        let resp = try await self.generateClient.request(with: .init(), retryCount: 0)
        self.text = "\(resp)"
      } catch {
        self.text = "error"
      }
    }
  }


}

struct SwiftUIView: View {
  @StateObject var viewModel = ViewModel()

    var body: some View {
      Text(self.viewModel.text)
      Button("plus") {
        // self.viewModel.count += 1
        self.viewModel.request()
      }
    }
}

#Preview {
  Group {
    let viewModel: ViewModel = withDependencies { values in
      values[GenerateAPIClient<API>.self].request = { _, _ in
        API.ResponseType(value: "pica ios")
      }
    } operation: {
      ViewModel()
    }

    SwiftUIView(viewModel: viewModel)
  }

}
