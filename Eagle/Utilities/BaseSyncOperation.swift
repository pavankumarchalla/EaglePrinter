//
//  BaseSyncOperation.swift
//  Alzahrani
//
//  Created by Hardwin on 05/05/17.
//  Copyright © 2017 Ramprasad A. All rights reserved.
//

import UIKit
import Alamofire

enum OperationType: String {
	case getPrintersList = "getPrintersList"
	case sendSelectedPrinter = "sendSelectedPrinter"
    case downloadPDF = "DownloadPDFFile"
}

typealias SyncCompletionHandler = (_ result: Any? , _ error: Error?) -> Void
typealias ImportCompletionHandler = ((_ success: Bool) -> Void)

public typealias DownloadSuccessHandler = (_ success : Bool, _ result: AnyObject?) -> ()

class BaseSyncOperation: Operation {
	
    var operationType = OperationType.getPrintersList
    //Stores any temproary info to be used while sending request
	var userInfo: [String: AnyObject]?
    //Closure called when operation is completed
    var completionHandler: SyncCompletionHandler?
    //Stores the Temporary JSON Objects
    //For ImageCompletion Handeling
    var imageCompletionHandler: ImportCompletionHandler?
    
    //MARK:- Initilization:
    
	init(info: [String: AnyObject]? = nil,
         operationType: OperationType,
         completionHandler: SyncCompletionHandler? = nil,
         importCompletion: ImportCompletionHandler? = nil) {
        
        super.init()
        userInfo = info
        self.operationType = operationType
        self.completionHandler = completionHandler
        name = operationType.rawValue
    }
    
    override func main() {
        
        if isCancelled {
            print("Cancel Operation: \(self.name ?? "")")
            DispatchQueue.main.async {
                
                self.completionHandler?(nil, NetworkManager.connectionError)
            }
            return
        }
        //Closure
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        startProcessing()
    }
    
    deinit {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        print("Ending Operation: \(String(describing: self.name))")
    }
}

extension BaseSyncOperation {
    func startProcessing() {
        //Look at child class
        assertionFailure("startProcessing must be overriden by subclass")
    }
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

