//
//  SocketHandler.swift
//  PrintingApp
//
//  Created by Ramprasad A on 26/03/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import Foundation

class PrinterSocket {
  var address: String
  var port: Int
  var task: URLSessionStreamTask!
  
  init(with host: String, and port: Int) {
    self.address = host
    self.port = port
  }
  
  func setupConnection() {
    let session = URLSession(configuration: .default)
    task = session.streamTask(withHostName: self.address, port: self.port)
    self.task.resume()
  }
  
  func send(_ data: Data) {
    self.task.write(data, timeout: 10) { (error) in
      if error == nil {
        print("data sent to printer")
      } else {
        print("Cannot communicate with printer")
      }
    }
  }
}
