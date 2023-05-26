//
//  ViewController.swift
//  TestUIViewSnapshot
//
//  Created by Brook_Mobius on 5/26/23.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var testView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    makeSnapshot()
  }
  
  private func makeSnapshot() {
    let myView = testView!

    print("myView", myView.frame)

    // Render the view as an image
    let snapshotView = myView.snapshotView(afterScreenUpdates: true)
    print("snapshotView", snapshotView!.frame)
    
    snapshotView?.frame.origin.y = 300
    
    view.addSubview(snapshotView!)
  }


}

