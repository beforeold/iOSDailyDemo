//
//  ProfileViewController.swift
//  TestRxSwift
//
//  Created by beforeold on 2022/10/14.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class ProfileViewController: UIViewController {
  
  enum Gender {
    case unknown
    case male
    case female
  }
  
  @IBOutlet weak var female: UIButton!
  @IBOutlet weak var swiftLevel: UISlider!
  @IBOutlet weak var knowSwift: UISwitch!
  @IBOutlet weak var male: UIButton!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var passionToLearn: UIStepper!
  
  @IBOutlet weak var update: UIButton!
  
  var bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    datePicker.layer.borderWidth = 1
    
    let datePub = datePicker.rx.date.map(Validator.isValidDate(date:))
    
    datePub.map { $0 ? UIColor.green : .clear }
      .observe {[unowned self] value in
        self.datePicker.layer.borderColor = value.cgColor
      }
      .disposed(by: bag)
    
    let genderSelection = BehaviorSubject<Gender>(value: .unknown)
    
    male.rx.tap
      .map { return Gender.male }
      .bind(to: genderSelection).disposed(by: bag)
    
    female.rx.tap
      .map { return Gender.female }
      .bind(to: genderSelection)
      .disposed(by: bag)
    
    genderSelection.observe {[unowned self]  gender in
      switch gender {
      case .male:
        self.male.setTitleColor(.green, for: .normal)
        self.female.setTitleColor(.blue, for: .normal)
        
      case .female:
        self.male.setTitleColor(.blue, for: .normal)
        self.female.setTitleColor(.green, for: .normal)
        
      case .unknown:
        break
      }
    }.disposed(by: bag)
    
    let genderSelected = genderSelection.map { $0 != .unknown }
    
    Observable.combineLatest(genderSelected, datePub)
      .map { $0.0 && $0.1 }
      .bind(to: self.update.rx.isEnabled)
      .disposed(by: bag)
    
    knowSwift.rx.value
      .map { $0 ? 50 : 0 }
      .bind(to: self.swiftLevel.rx.value)
      .disposed(by: bag)
    
    swiftLevel.rx.value
      .map { $0 > 0 }
      .bind(to: self.knowSwift.rx.value)
      .disposed(by: bag)
    
    passionToLearn.rx.value
      .map { "\($0)" }
      .observe { text in
        print("stepper: \(text)")
      }.disposed(by: bag)
  }
  
  
  deinit {
    print("profile deinit")
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
