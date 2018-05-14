//
//  EagleProtocols.swift
//  Eagle
//
//  Created by Ramprasad A on 24/01/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

struct PrinterData {
	var defaultPrinters: Int
	var printerId: Int
	var printerIp: String
	var printerName: String
	var typeId: Int
	var type: String
	var status: Int
	var isSelected: Bool = false
	
	init(withDefaults defaults: Int, andPrinterId pId: Int, itsIp ip: String,
	     printerName name: String, typeId tId: Int, pType type: String, printerStatus status: Int) {
		self.defaultPrinters = defaults
		self.printerId = pId
		self.printerIp = ip
		self.printerName = name
		self.typeId = tId
		self.type = type
		self.status = status
	}
}

import Foundation

protocol JSONConvertible {
	func parseJSON(withData data: [[String: AnyObject]]) -> [PrinterData]
}

extension JSONConvertible {
	
	func parseJSON(withData data: [[String: AnyObject]]) -> [PrinterData] {
		var printerObjects = [PrinterData]()
		for printer in data {
			if let defaultPrinters = printer["DefaulfPrinters"] as? Int,
				let printerId = printer["PrinterId"] as? Int,
				let printerIp = printer["PrinterIp"] as? String,
				let name = printer["PrinterName"] as? String,
				let typeId = printer["PrinterTypeId"] as? Int,
				let type = printer["printerType"] as? String,
				let status = printer["status"] as? Int {
				
				let printer = PrinterData(withDefaults: defaultPrinters, andPrinterId: printerId, itsIp: printerIp, printerName: name, typeId: typeId, pType: type, printerStatus: status)
				printerObjects.append(printer)
			}
		}
		return printerObjects
	}
}
