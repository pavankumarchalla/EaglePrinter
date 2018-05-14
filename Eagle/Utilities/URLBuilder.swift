//
//  URLBuilder.swift
//  Alzahrani
//
//  Created by Hardwin on 05/05/17.
//  Copyright © 2017 Ramprasad A. All rights reserved.
//

import UIKit

class URLBuilder: NSObject {

	static func baseURL() -> String {
		return "http://eagle.sysitrex.com/webapi/api/printers/"
        //http://eagle.sysitrex.com/webapi/api/printers/GetPrintouts?receiptId=Receipt636564612484060000.pdf&sessionId=123
	}
}

//MARK:- Service API Url:
extension URLBuilder {
	
	class func getAllPrintersURL() -> String {
		return baseURL() + "GetPrinterByID"
	}
	
	class func sendSelectedPrinter() -> String {
		return baseURL() + "DefaulfPrinter"
	}
}
