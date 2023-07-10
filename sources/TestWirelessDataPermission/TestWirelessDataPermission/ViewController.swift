//
//  ViewController.swift
//  TestWirelessDataPermission
//
//  Created by Brook_Mobius on 7/10/23.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    getCurrentWiFiInfo()
  }
  

//  1. Use the CNCopyCurrentNetworkInfo() function to fetch the current Wi-Fi network information:

  func getCurrentWiFiInfo() {
      guard let cfArray = CNCopySupportedInterfaces() else {
          print("No Wi-Fi interfaces found")
          return
      }
      
      let interfaceArray = (cfArray as NSArray) as! [String]
      
      if let currentInterface = interfaceArray.first {
          if let currentNetworkInfo = CNCopyCurrentNetworkInfo(currentInterface as CFString) as NSDictionary? {
              if let ssid = currentNetworkInfo[kCNNetworkInfoKeySSID as String] as? String {
                  // Wi-Fi access is allowed
                  print("Wi-Fi access is allowed. Connected to Wi-Fi network: \(ssid)")
              } else {
                  // Wi-Fi access permission unknown or not allowed
                  print("Wi-Fi access permission unknown or not allowed")
              }
          } else {
              // Wi-Fi access permission unknown or not allowed
              print("Wi-Fi access permission unknown or not allowed")
          }
      } else {
          // No Wi-Fi interface found
          print("No Wi-Fi interface found")
      }
  }



}

