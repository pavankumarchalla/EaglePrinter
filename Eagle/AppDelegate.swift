//
//  AppDelegate.swift
//  Eagle
//
//  Created by Ramprasad A on 18/01/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		AppManager.initialSetup()
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        self.handleDeeplinkURL(with: url)
        return true
    }

    func handleDeeplinkURL(with url: URL) {
        var pdfURLDict = [String: AnyObject]()
        let urlComponents = url.path.split(separator: "/")
        if urlComponents.count > 0 {
            let recieptId = urlComponents[urlComponents.count - 2]
            let sessionId = url.deletingPathExtension().lastPathComponent
            
            let pdfURL = "http://eagle.sysitrex.com/webapi/api/printers/GetPrintouts?receiptId=\(recieptId)&sessionId=\(sessionId)"
            pdfURLDict["PDF_DOWNLOAD_URL"] = pdfURL as AnyObject
            NotificationCenter.default.post(name: Notification.Name("PDF_URL"), object: pdfURLDict)
        }
    }
}

