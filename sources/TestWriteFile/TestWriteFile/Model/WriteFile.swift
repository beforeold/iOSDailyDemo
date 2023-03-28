//
//  WriteFile.swift
//  TestWriteFile
//
//  Created by Brook_Mobius on 2023/3/28.
//

import Foundation

struct WriteFile {
  static func makeFileURL(fileName: String = "\(UUID().uuidString).bin") -> URL {
    let fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
      .appendingPathComponent(fileName)
    return fileURL
  }
  
  static func createLargeFile(
    fileSize: Int64,
    fileURL: URL,
    progressHandler: (Int64, URL) -> Void
  ) -> URL {
    let bufferSize = 1 * 1024 * 1024 // 1MB
    
    FileManager.default.createFile(atPath: fileURL.path, contents: nil)
    
    var current: Int64 = 0
    func progress(count: Int64) {
      current += Int64(count)
      progressHandler(current, fileURL)
    }
    
    do {
      let fileHandle = try FileHandle(forWritingTo: fileURL)
      for _ in 0..<(fileSize / Int64(bufferSize)) {
        let data = Data(count: bufferSize).map { _ in UInt8.random(in: 0...255) }
        try fileHandle.write(contentsOf: data)
        progress(count: Int64(data.count))
      }
      let remainingBytes = fileSize % Int64(bufferSize)
      if remainingBytes > 0 {
        let lastData = Data(count: Int(remainingBytes)).map { _ in UInt8.random(in: 0...255) }
        try fileHandle.write(contentsOf: lastData)
        progress(count: Int64(lastData.count))
      }
      fileHandle.closeFile()
      print("Large file created at: \(fileURL)")
    } catch {
      print("Error creating large file: \(error)")
      progress(count: fileSize)
    }
    
    return fileURL
  }
  
  static func duplicateFile(sourceURL: URL, destinationURL: URL) {
    // let fileManager = FileManager.default
    do {
      // try fileManager.copyItem(at: sourceURL, to: destinationURL)
      let fileData = try Data(contentsOf: sourceURL)
      try fileData.write(to: destinationURL)
      print("File duplicated successfully")
    } catch {
      print("Error duplicating file: \(error)")
    }
  }
  
  static func duplicateFile(fileData: Data, destinationURL: URL) {
    do {
      try fileData.write(to: destinationURL)
      print("File duplicated successfully")
    } catch {
      print("Error duplicating file: \(error)")
    }
  }
}
