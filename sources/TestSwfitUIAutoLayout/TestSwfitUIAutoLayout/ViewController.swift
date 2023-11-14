//
//  ViewController.swift
//  TestSwfitUIAutoLayout
//
//  Created by Brook_Mobius on 11/14/23.
//

import UIKit
import SwiftUI

struct LabelView: View {
  var body: some View {
    VStack {
      Text("Hello world")
      Image(systemName: "clock")
    }
    .font(.title)
    .padding(24)
    .border(.blue)
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .lightGray

    let child = UIHostingController(
      rootView: LabelView()
    )
    addChild(child)
    view.addSubview(child.view)

    child.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      child.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      child.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }


}

