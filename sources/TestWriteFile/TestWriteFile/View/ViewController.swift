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
}

