//
//  ViewController.swift
//  TestNumberAnimation
//
//  Created by Brook_Mobius on 5/26/23.
//

import UIKit

class ViewController: UIViewController {
  
  var number = 0
  
  var numberView: SlidingNumberView!
  
  var animatedView: NumberScrollAnimatedView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .gray
    
    // setup()
    setup2()
  }
  
  var myLabel: UILabel = .init()
  
  
  private func setup() {
    numberView = SlidingNumberView(startNumber: "0000", endNumber: "0005", font: UIFont.systemFont(ofSize: 26))
    numberView.animationDuration = 3
            
    self.view.addSubview(numberView)
    numberView.translatesAutoresizingMaskIntoConstraints = false
    numberView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
    numberView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    self.view.layoutIfNeeded()
            
    numberView.startCounting(completion: {finish in
      self.numberView.startNumber = "0005"
      self.numberView.endNumber = "0009"
      self.numberView.startCounting(completion: { finish in
        print("Counting Finally done")
      })
    })
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(#function)
    
    startNumber()
  }
  
  private func startNumber() {
    number += 7
    animatedView.text = "\(number)"
    self.animatedView.startAnimation()
  }
  
  private func setup2() {
    print(#function)
    
    animatedView = NumberScrollAnimatedView()
     animatedView.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
    view.addSubview(animatedView)
    // Add to superview, configure view constraints etc...

    // Customize a view properties like background color, font size and color
    animatedView.backgroundColor = UIColor(red: 255/255, green: 47/255, blue: 146/255, alpha: 1)
    animatedView.font = UIFont.boldSystemFont(ofSize: 64)
    animatedView.textColor = .white

    // Set animation properties
    animatedView.animationDuration = 0.75
    animatedView.scrollingDirectionRule = { (_, columnIndex) in return (columnIndex % 2) == 0 ? .down : .up }
 
    // Set a value which will be displayed
    animatedView.text = "\(number)"


  }
}



/*
 func foo() {
   // Define the start and end values for the label
   let startNumber = 8
   let endNumber = 12
   
   // Create arrays of digit images for each number
   let digitImages: [[UIImage]] = (0...9).map {
     // The font size and style can be customized as needed
     let font = UIFont.systemFont(ofSize: 30.0, weight: .regular)
     
     // Draw the digit with the specified font, color, and alignment
     let digit = "\($0)"
     let attributes = [NSAttributedString.Key.font: font,
                       NSAttributedString.Key.foregroundColor: UIColor.black,
                       NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle]
     let size = digit.size(withAttributes: attributes)
     let rect = CGRect(origin: .zero, size: size)
     UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
     digit.draw(in: rect, withAttributes: attributes)
     guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return [] }
     UIGraphicsEndImageContext()
     
     // Break the digit image into slices for each digit component
     let slices: [UIImage] = (0..<Int(size.width)).compactMap {
       let sliceRect = CGRect(x: CGFloat($0), y: 0, width: 1, height: size.height)
       guard let sliceImage = image.cgImage?.cropping(to: sliceRect) else { return nil }
       return UIImage(cgImage: sliceImage)
     }
     return slices
   }
   
   // Create a timer to update the label's text every 0.1 seconds
   var timer: Timer?
   var currentNumber = startNumber
   
   // Start the timer
   timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
     guard let self = self else { return }
     
     // Calculate the next number and update the label with the rolling animation
     currentNumber += 1
     if currentNumber > endNumber {
       timer?.invalidate()
       timer = nil
       return
     }
     let nextNumberText = "\(currentNumber)"
     let labelText = self.myLabel.text ?? ""
     let paddingText = String(repeating: "0", count: max(nextNumberText.count - labelText.count, 0))
     let currentNumberComponents = String(labelText.reversed()).map { Int(String($0)) ?? 0 }
     let nextNumberComponents = Array((paddingText + nextNumberText).reversed()).map { Int(String($0)) ?? 0 }
     
     for (index, component) in labelText.components.enumerated() {
       let digitIndex = currentNumberComponents[index]
       let nextDigitIndex = nextNumberComponents[index]
       let scrollDistance = CGFloat(digitImages[0].count)
       let offset = -scrollDistance * (CGFloat(nextDigitIndex) - CGFloat(digitIndex))
       component.moveAndCycleImages(by: offset, in: digitImages[nextDigitIndex])
     }
   }
 }
 */
