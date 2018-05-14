//
//  NetworkManager.swift
//  Alzahrani
//
//  Created by Hardwin on 05/05/17.
//  Copyright © 2017 Ramprasad A. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    
    //Static Members to do Network Operation
    static var defaultManger: SessionManager!
    static var token: String?
    static var securedManger: SessionManager!
	
    private static let reachability = Reachability.reachabilityForInternetConnection()
    class var sharedReachability: Reachability {
        return reachability
    }
	
	class var connectionError: ResponseError {
		
		let error = ResponseError(error: "com.hss.Eagle", localizedDescription: NSLocalizedString("ERROR_NO_INTERNET_CONNECTION",comment: ""), errorType: .noConnection)
		return error
		
	}
	
    class var authToken: String? {
        get {
            return token
        } set {
            if let newValue = newValue {
                var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
                defaultHeaders["Auth-Token"] = newValue
                let configuration = URLSessionConfiguration.default
                configuration.httpAdditionalHeaders = defaultHeaders
                configuration.timeoutIntervalForRequest = 10800
                configuration.requestCachePolicy = .reloadIgnoringCacheData
                
                self.securedManger = Alamofire.SessionManager(configuration: configuration)
            }
        }
    }
    
    class func configureManagers(token: String?) {
        
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["Accept"] = "application/json"
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        self.defaultManger = Alamofire.SessionManager(configuration: configuration)
		
        
        self.authToken = token
    }
}
