//
//  HomeViewModel.swift
//  TestWriteFile
//
//  Created by Brook_Mobius on 2023/3/28.
//

import SwiftUI

class HomeViewModel: ObservableObject {
  static let baseFileName = "TestWriteFile.bin"
  
  @Published var isLoading: Double? = nil

  func add(count: Int) {
    isLoading = 0.0
    
    let baseFileURL = WriteFile.makeFileURL(fileName: Self.baseFileName)
    let path = baseFileURL.path
    if FileManager.default.fileExists(atPath: path) {
      let group = DispatchGroup()
      
      let semaphore = DispatchSemaphore(value: 5)
      
      for i in 0..<count {
        group.enter()
        DispatchQueue.global().async {
          semaphore.wait()
          WriteFile.duplicateFile(
            sourceURL: baseFileURL,
            destinationURL: WriteFile.makeFileURL()
          )
          
          DispatchQueue.main.async {
            self.isLoading = Double(i + 1) / Double(count)
          }
          
          semaphore.signal()
          
          group.leave()
        }
      }
      group.notify(queue: DispatchQueue.main) {
        _ = semaphore.description
        self.isLoading = nil
      }
    } else {
      // create a 100MB file and call again to copy files
      let fileSize: Int64 = 100 * 1024 * 1024
      _ = WriteFile.createLargeFile(fileSize: fileSize, fileURL: baseFileURL) { current, fileURL in
        let progress = Double(current) / Double(fileSize)
        print(progress)
        if current == fileSize {
          self.add(count: count)
        }
      }
    }
  }
}
