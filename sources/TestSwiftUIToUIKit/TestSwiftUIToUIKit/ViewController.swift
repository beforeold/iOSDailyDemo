//
//  ViewController.swift
//  TestSwiftUIToUIKit
//
//  Created by Brook_Mobius on 11/10/23.
//

import UIKit
import SwiftUI

struct LoadingView: View {
  var body: some View {
    Text("Hello")
      .foregroundColor(.white)
      .frame(width: 40, height: 40)
      .background(.gray)
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    showLoadingView()
  }

  func showLoadingView() {
    let child = UIHostingController(
      rootView: LoadingView()
    )
    view.addSubview(child.view)
    addChild(child)

    child.view.frame = CGRectMake(100, 100, 100, 100)
    child.view.backgroundColor = .yellow
  }

}

