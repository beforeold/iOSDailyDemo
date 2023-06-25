//
//  ViewController.swift
//  TestDateFormaterMonthOnly
//
//  Created by Brook_Mobius on 6/25/23.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let date = Date()
    
    // let locale = Locale(identifier: "en_US")
    let locale = Locale.current
    let enDate = formattedDateString(date: date, format: "MMM, yyyy", locale: locale)
    print("ouput", enDate) // output: "Jun 1991"
  }

  func formattedDateString(date: Date, format: String, locale: Locale) -> String {
      let dateFormatter = DateFormatter()
//      dateFormatter.locale = locale
//      dateFormatter.setLocalizedDateFormatFromTemplate(format)
    let usFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: locale)
    dateFormatter.dateFormat = usFormat
      return dateFormatter.string(from: date)
  }

}

