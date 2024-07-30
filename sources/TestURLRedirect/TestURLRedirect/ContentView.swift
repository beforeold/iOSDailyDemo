import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .onAppear {
      foo()
    }
  }
}

import Foundation

func checkRedirect(for url: URL, completion: @escaping (URL?) -> Void) {
  var request = URLRequest(url: url)
  request.httpMethod = "HEAD" // 使用 HEAD 方法只获取头信息而不下载整个资源

  let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let httpResponse = response as? HTTPURLResponse else {
      completion(nil)
      return
    }

    // 检查响应代码是否为重定向状态码
    if (300...399).contains(httpResponse.statusCode),
       let location = httpResponse.allHeaderFields["Location"] as? String,
       let redirectURL = URL(string: location) {
      completion(redirectURL)
    } else {
      completion(nil)
    }
  }

  task.resume()
}

func foo() {

  // 使用示例
  if let url = URL(string: "https://img.pica-ai.com//image//aigc//alg%26faceswap%26p%262c946c94b177358ca2930c8868e8e36f_400_400.webp") {
    checkRedirect(for: url) { redirectURL in
      if let redirectURL = redirectURL {
        print("Redirected to: \(redirectURL)")
      } else {
        print("No redirect or failed to fetch redirect URL.")
      }
    }
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
