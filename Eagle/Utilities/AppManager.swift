//
//  AppManager.swift
//  Eagle
//
//  Created by Ramprasad A on 18/01/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

import Foundation
import UIKit

class AppManager {
  
  class func initialSetup() {
    self.setAppTheme()
    NetworkManager.configureManagers(token: "")
  }
  
  class func appBarTintColor() -> UIColor {
    return UIColor(rgba: "#3F51B5")
  }
  
  class func appTintColor() -> UIColor {
    return UIColor.black
  }
  
  class func setAppTheme() {
    
    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.barTintColor = appBarTintColor()
    navigationBarAppearance.tintColor = appTintColor()
    navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    UIApplication.shared.statusBarStyle = .lightContent
    
  }
}
