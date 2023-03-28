//
//  ViewController.swift
//  TestWriteFile
//
//  Created by Brook_Mobius on 2023/3/28.
//

import UIKit
import SwiftUI

class ViewController: UIHostingController<HomeView> {
  
  override init?(coder aDecoder: NSCoder, rootView: HomeView) {
    super.init(coder: aDecoder, rootView: rootView)
  }
  
  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder, rootView: HomeView())
  }
  
  /*
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let fileSize: Int64 = 100 * 1024 * 1024
    let start = CFAbsoluteTimeGetCurrent()
    _ = WriteFile.createLargeFile(fileSize: fileSize) { current, fileURL in
      let progress = Double(current) / Double(fileSize)
      print(current, CFAbsoluteTimeGetCurrent() - start)
      if progress >= 1 {
        for _ in 0..<100 {
          DispatchQueue.global().async {
            let destURL = WriteFile.makeFileURL()
            WriteFile.duplicateFile(sourceURL: fileURL, destinationURL: destURL)
          }
        }
      }
    }
  }
  */
}

