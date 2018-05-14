//
//  BaseAPIManager.swift
//  Eagle
//
//  Created by Ramprasad A on 22/01/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

import Foundation
import UIKit

class BaseAPIManager {
	
	var taskType: APITask
	var httpBody: [String: AnyObject]?
	var completionHandler:  CompletionHandler?
	
	init(withType taskType: APITask,
	     andHttpBody body: [String: AnyObject]? = nil,
	     withCompletionHandler handler: CompletionHandler?) {
		self.taskType = taskType
		self.httpBody = body
		self.completionHandler = handler
	}
	
	///Sub-Class Must Override This function
	func startProcessing() {
		if NetworkManager.default.isNetworkReachable() {
			DispatchQueue.global().async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = true
			}
		} else {
			print("Network seems Offline..!")
		}
		//assertionFailure("startProcessing must be overriden by subclass")
	}
	
	deinit {
		DispatchQueue.main.async {
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		}
	}
}

