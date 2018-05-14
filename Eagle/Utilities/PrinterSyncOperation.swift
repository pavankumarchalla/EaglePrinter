//
//  PrinterSyncOperation.swift
//  Eagle
//
//  Created by Ramprasad A on 22/01/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

import Foundation
import Alamofire

class PrinterSyncOperation: BaseSyncOperation {
    
}

extension PrinterSyncOperation {
    
    override func startProcessing() {
        switch self.operationType {
        case .getPrintersList:
            self.getAllPrintersList()
        case .sendSelectedPrinter:
            self.sendSelectedPrinter()
        case .downloadPDF:
            self.downloadPDFFile()
        }
    }
}

extension PrinterSyncOperation {
    
    func getAllPrintersList() {
        let url = URLBuilder.getAllPrintersURL()
        
        NetworkManager.defaultManger.request(url, method: .get, parameters: [:], encoding: URLEncoding.methodDependent).validate().responseJSON { (response) in
            if response.error == nil {
                print("Response: \(String(describing: response.result.value))")
                self.completionHandler?(response.result.value, nil)
            } else {
                print("Error: \(String(describing: response.error))")
                self.completionHandler?(nil, response.error)
            }
        }
    }
    
    func sendSelectedPrinter() {
        let url = URLBuilder.sendSelectedPrinter()
        if let userInfo = self.userInfo {
            NetworkManager.defaultManger.request(url, method: .put, parameters: userInfo, encoding: URLEncoding.methodDependent).validate().responseJSON(completionHandler: { (response) in
                if response.error == nil {
                    print("Printer sent successfully")
                    print("\(String(describing: response.result.value))")
                    self.completionHandler?(response.result.value, nil)
                } else {
                    print("Error")
                    self.completionHandler?(nil, response.error)
                }
            })
        }
    }
    
    func downloadPDFFile() {
        self.deleteBeforeSave()
        if let userInfo = self.userInfo {
            if let url = userInfo["PDF_DOWNLOAD_URL"] as? String {
                if let pdfURL = URL(string: url) {
                    let urlRequest = URLRequest(url: pdfURL)
                    let session = URLSession(configuration: .default)
                    
                    let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                        if error == nil {
                            var docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                            docURL = docURL?.appendingPathComponent("tempFile.pdf")
                            do {
                                try data?.write(to: docURL!)
                                self.completionHandler?(docURL, nil)
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    dataTask.resume()
                }
                /* let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
                 Alamofire.download(url, to: destination).response { (resposne) in
                 if resposne.error != nil {
                 print("Failed with error: \(String(describing: resposne.error))")
                 self.completionHandler?(nil, resposne.error)
                 } else {
                 print("Downloaded file successfully")
                 self.completionHandler?(resposne.destinationURL, nil)
                 }
                 } */
            }
        }
        
    }
    
    func deleteBeforeSave() {
        let fileNameToDelete = "tempFile.pdf"
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
}
