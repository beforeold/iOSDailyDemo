//
//  ViewController.swift
//  TestUIImagePicker
//
//  Created by dinglan on 2021/5/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = UIImagePickerController()
        
        present(vc, animated: true, completion: nil)
    }
    
}

