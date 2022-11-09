//
//  ContentView.swift
//  TestImageListLoading
//
//  Created by Brook_Mobius on 2022/11/9.
//

import SwiftUI

struct Photo: Codable {
  var id: String
  var author: String
  var width: CGFloat
  var height: CGFloat
  var url: String
  var download_url: String
}

struct LoadingError: Error {}

class Remote<T>: ObservableObject {
  @Published var result: Result<T, Error>?
  
  var value: T? {
    try? result?.get()
  }
  
  private let url: URL
  private let transform: (Data) -> T?
  
  init(_ url: URL, transform: @escaping (Data) -> T?) {
    self.url = url
    self.transform = transform
  }
  
  
  func load() {
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) {data, _, error in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else {
          return
        }
        
        if let data = data,
           let value = self.transform(data) {
          self.result = .success(value)
        } else {
          self.result = .failure(LoadingError())
        }
      }
    }
    task.resume()
  }
}

struct ContentView: View {
  @ObservedObject var model = Remote<[Photo]>.init(URL(string: "https://picsum.photos/v2/list")!) { data in
    try? JSONDecoder().decode([Photo].self, from: data)
  }
  
  var body: some View {
    if let value = model.value {
      List(value, id: \.id) { photo in
        NavigationLink(photo.author) {
          PhotoView(
            URL(string: photo.download_url)!,
            aspectRatio: photo.width / photo.height
          )
        }
      }
    } else {
      ProgressView()
        .onAppear {
          model.load()
        }
    }
  }
}

struct PhotoView: View {
  @ObservedObject var image: Remote<UIImage>
  let aspectRatio: CGFloat
  
  init(_ download_url: URL, aspectRatio: CGFloat) {
    image = .init(download_url, transform: UIImage.init)
    self.aspectRatio = aspectRatio
  }
  
  var body: some View {
    imageOrPlaceholder
      .resizable()
      .foregroundColor(.secondary)
      .aspectRatio(aspectRatio, contentMode: .fit)
      .padding()
      .onAppear { image.load() }
  }
  
  var imageOrPlaceholder: Image {
    image.value.map(Image.init) ?? Image(systemName: "photo")
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ContentView()
    }
  }
}
