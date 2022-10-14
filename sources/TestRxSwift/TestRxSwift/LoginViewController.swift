//
//  LoginViewController.swift
//  TestRxSwift
//
//  Created by beforeold on 2022/10/14.
//

import UIKit
import RxSwift
import RxCocoa

class Validator {
  class func isValidEmail(email: String) -> Bool {
//      let re = try? NSRegularExpression(
//          pattern: "^\\S+@\\S+\\.\\S+$",
//          options: .caseInsensitive)
//
//      if let re = re {
//          let range = NSMakeRange(0,
//              email.lengthOfBytesUsingEncoding(
//              NSUTF8StringEncoding))
//
//          let result = re.matchesInString(email,
//              options: .ReportProgress,
//              range: range)
//
//          return result.count > 0
//      }
//    return false
    
    return email.contains("@")
  }
  
  class func isValidPassword(
      password: String) -> Bool {
      return password.count >= 8
  }
}

class LoginViewController: UIViewController {
  
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  
  @IBOutlet weak var signButton: UIButton!
  var bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    email.layer.borderWidth = 1
    password.layer.borderWidth = 1
    
    let emailPub = email.rx.text.map {
      $0.flatMap(Validator.isValidEmail(email:)) ?? false
    }
    
    let passwordPub = password.rx.text.map {
      $0.flatMap(Validator.isValidPassword(password:)) ?? false
    }
    
    emailPub.map { value -> UIColor in
      return value ? .green : .clear
    }.observe {
      self.email.layer.borderColor = $0.cgColor
    }.disposed(by: bag)
    
    passwordPub.map { value -> UIColor in
      return value ? .green : .clear
    }.observe {
      self.password.layer.borderColor = $0.cgColor
    }.disposed(by: bag)
    
    
    Observable.combineLatest(emailPub, passwordPub)
      .map { value in
      return value.0 && value.1
      }
      .observe { value in
        self.signButton.isEnabled = value
      }.disposed(by: bag)
  }
  
  @IBAction func onSign(_ sender: Any) {
    print("on sign")
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
