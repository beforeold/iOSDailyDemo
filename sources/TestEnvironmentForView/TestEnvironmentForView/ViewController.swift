//
//  ViewController.swift
//  TestEnvironmentForView
//
//  Created by xipingping on 7/3/24.
//

import SwiftUI
import UIKit

struct Demo: View {
  var body: some View {
    Text("hello")
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()



    let rootView = Demo()
    let controller = UIHostingController(rootView: rootView)
    rootView.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {

    })
  }


}

