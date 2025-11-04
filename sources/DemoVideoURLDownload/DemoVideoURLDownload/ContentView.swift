import Foundation
import SwiftUI
import Photos

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .task {
      await demo()
    }
  }
}

class TaskDelegate: NSObject, URLSessionDataDelegate {

  // 记录一下我们在重定向时看到的“资源 URL”
  var redirectedURL: URL?

  /// 发生 302/301 等重定向时会调用
  func urlSession(
    _ session: URLSession,
    task: URLSessionTask,
    willPerformHTTPRedirection response: HTTPURLResponse,
    newRequest request: URLRequest,
    completionHandler: @escaping (URLRequest?) -> Void
  ) {
    print("🔁 将要重定向：\(response.statusCode)")
    if let url = request.url {
      print("🔗 重定向目标 URL：\(url.absoluteString)")
      redirectedURL = url
    }

    // 继续跟随重定向
    completionHandler(request)
  }

  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    print("data \(data.count)")
  }

  /// Task 完成（成功或失败）时调用
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    if let error = error {
      print("❌ 下载失败：\(error)")
    } else {
      print("✅ 下载完成")
    }

    // 这里的 currentRequest 一般是“最后一次请求”，也就是最终资源 URL 对应的 Request
    if let finalURL = task.currentRequest?.url {
      print("🎯 task.currentRequest 最终 URL：\(finalURL.absoluteString)")
    }

    if let redirectedURL = redirectedURL {
      print("🎯 delegate 中记录的重定向 URL：\(redirectedURL.absoluteString)")
    }
  }
}
let taskDelegate: URLSessionTaskDelegate = TaskDelegate()

@MainActor
func demo() async {
  let url = URL(
    string:
      "https://www.douyin.com/aweme/v1/play/?video_id=v1e00fgi0000d3vo4m7og65g9qab5kd0&line=0&file_id=d7d5084621f94b89900983220db72856&sign=89b53818a6bbe39593b9fbcc54051848&is_play_url=1&source=PackSourceEnum_AWEME_DETAIL"
  )!
  do {
    print("⬇️ 开始下载：\(url.absoluteString)")

    // 使用 URLSession 下载数据
    let (data, response) = try await URLSession.shared.data(from: url, delegate: taskDelegate)

    //    URLSession.shared.downloadTask(with: URLRequest(url: url)) { url, resp, error in
    //      print(url, error, error)
    //    }

    if let httpResponse = response as? HTTPURLResponse {
      print("📡 HTTP 状态码：\(httpResponse.statusCode)")
      guard (200..<300).contains(httpResponse.statusCode) else {
        print("❌ 下载失败，状态码异常（可能是链接过期）")
        return
      }
    }

    // 保存到“下载”目录
    let fileManager = FileManager.default
    let downloadsDir =
      fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

    let fileName = "douyin-\(Int(Date().timeIntervalSince1970)).mp4"
    let fileURL = downloadsDir.appendingPathComponent(fileName)

    try data.write(to: fileURL)

    print("✅ 下载完成，已保存到：\(fileURL.path)")
    saveVideoToPhotos(at: fileURL)
  } catch {
    print("❌ 下载出错：\(error)")
  }

}

func saveVideoToPhotos(at fileURL: URL) {
  PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
    guard status == .authorized || status == .limited else {
      print("❌ 没有照片库写入权限")
      return
    }

    PHPhotoLibrary.shared().performChanges({
      let options = PHAssetResourceCreationOptions()
      let creationRequest = PHAssetCreationRequest.forAsset()
      creationRequest.addResource(with: .video, fileURL: fileURL, options: options)
    }) { success, error in
      if success {
        print("✅ 已保存到系统相册")
      } else if let error = error {
        print("❌ 保存到相册失败：\(error)")
      }
    }
  }
}

#Preview {
  ContentView()
}
