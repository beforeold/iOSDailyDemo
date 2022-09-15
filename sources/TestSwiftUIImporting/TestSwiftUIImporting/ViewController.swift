//
//  ViewController.swift
//  TestSwiftUIImporting
//
//  Created by 席萍萍Brook.dinglan on 2021/10/9.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


#if DEBUG
import SwiftUI
#endif

#if DEBUG
struct MyView: View {
    var body: some View {
        Text("Hello SwiftUI Debugging")
    }
}
#endif
