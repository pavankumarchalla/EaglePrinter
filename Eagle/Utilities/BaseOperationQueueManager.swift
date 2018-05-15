//
//  BaseOperationQueueManager.swift
//  Alzahrani
//
//  Created by Ramprasad on 05/05/17.
//  Copyright © 2017 Ramprasad A. All rights reserved.
//
//eaglePrinters://prints.hardwin.com/work/1002/2000
import UIKit

class BaseOperationQueueManager: NSObject {
  
  fileprivate var downloadSyncQueue: OperationQueue?
  
  //MARK:- Super Methods:
  override init() {
    super.init()
    downloadSyncQueue = OperationQueue()
    downloadSyncQueue?.name = "BaseDownloadOperationQueue"
  }
}

//MARK:- Helper Methods:
extension BaseOperationQueueManager {
  
  func addDownloadOperation(operation: Operation) {
    downloadSyncQueue?.addOperation(operation)
  }
  
  func cancelAllQueues() {
    downloadSyncQueue?.cancelAllOperations()
  }
  
  func getCurrentOperation() -> Operation? {
    print("sync count is \(String(describing: OperationQueue.current?.operations))")
    return OperationQueue.current?.operations.first
  }
  
  func canceldownloadOperation() {
    self.downloadSyncQueue?.cancelAllOperations()
  }
  
}

