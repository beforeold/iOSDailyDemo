//
//  ViewController.swift
//  TestSwiftUIViewInUIKit
//
//  Created by Brook_Mobius on 4/20/23.
//

import UIKit
import SwiftUI

struct BlueView: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("Line 1")
      Text("Line 2")
    }
    .background(Color.blue)
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let customVC = UIHostingController(rootView: BlueView())
    let customView = customVC.view!
    customView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(customView)
    
    customView.backgroundColor = .gray
    
    self.addChild(customVC)
    
    NSLayoutConstraint.activate([
      customView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
      customView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
    ])
  }


}


