//
//  ViewController.swift
//  TestArch
//
//  Created by 席萍萍Brook.dinglan on 2021/12/29.
//

import UIKit

class ViewController: UIViewController {
    var model = Model()
    
    @IBOutlet var mvcTextField: UITextField!
    var mvcObserver: NSObjectProtocol?
    
    @IBOutlet var mvpTextField: UITextField!
    var presenter: ViewPresenter?
    
    @IBOutlet var minimalMVVMTextField: UITextField!
    var minimalViewModel: MinimalViewModel?
    var minimalObserver: NSKeyValueObservation?
    
    @IBOutlet var mvvmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mvcDidLoad()
        mvpDidLoad()
    }
}
