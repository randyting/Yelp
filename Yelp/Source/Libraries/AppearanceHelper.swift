//
//  AppearanceHelper.swift
//  TipMe
//
//  Created by Randy Ting on 8/25/15.
//  Copyright (c) 2015 Randy Ting. All rights reserved.
//

import UIKit

class AppearanceHelper: NSObject {
  

  
  class func setColors() {
    
    let darkBackgroundColor = colorFromHexString("#c41200") //red
    let darkTintColor = UIColor.whiteColor() //White
    let darkSecondaryColor = colorFromHexString("#737373") // Grey
    
    UINavigationBar.appearance().tintColor = darkTintColor
    UINavigationBar.appearance().barTintColor = darkBackgroundColor
    UINavigationBar.appearance().backgroundColor = darkBackgroundColor
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:darkTintColor]
//    UILabel.my_appearanceWhenContainedIn(SwitchTableViewCell.self).textColor = UIColor.greenColor()
    
    UISwitch.appearance().onTintColor = darkSecondaryColor
  }
  
  class func resetViews() {
    let windows = UIApplication.sharedApplication().windows
    for window in windows {
      let subviews = window.subviews 
      for v in subviews {
        v.removeFromSuperview()
        window.addSubview(v)
      }
    }
  }
  
  class func colorFromHexString(hexString: String) -> UIColor {
    var rgbValue: UInt32 = 0
    let scanner = NSScanner(string: hexString)
    scanner.scanLocation = 1
    scanner.scanHexInt(&rgbValue)
    return UIColor(
      red: CGFloat((rgbValue >> 16) & 0xff) / 255,
      green: CGFloat((rgbValue >> 08) & 0xff) / 255,
      blue: CGFloat((rgbValue >> 00) & 0xff) / 255,
      alpha: 1.0)
  }
  
}
