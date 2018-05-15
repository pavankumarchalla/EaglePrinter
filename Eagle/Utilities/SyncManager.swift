//
//  SyncManager.swift
//  Alzahrani
//
//  Created by Hardwin on 05/05/17.
//  Copyright © 2017 Ramprasad A. All rights reserved.
//

import UIKit

class SyncManager: NSObject {
  
  fileprivate static var syncQueueManager = BaseOperationQueueManager()
  
  class var sharedSyncQueueManager: BaseOperationQueueManager {
    return syncQueueManager
  }
  
}

//MARK:- Helper Methods

extension SyncManager {
  
  class func syncOperation(operationType type: OperationType,
                           info: [String: AnyObject]?,
                           completionHandler: SyncCompletionHandler? = nil) {
   
    var operation: BaseSyncOperation!
    
    if NetworkManager.sharedReachability.isReachable() {
      switch type {
      case .getPrintersList:
        operation = PrinterSyncOperation(info: info, operationType: type, completionHandler: completionHandler)
        syncQueueManager.addDownloadOperation(operation: operation)
      case .sendSelectedPrinter, .downloadPDF:
        operation = PrinterSyncOperation(info: info, operationType: type, completionHandler: completionHandler)
        syncQueueManager.addDownloadOperation(operation: operation)
      }
    } else {
      completionHandler?(nil, NetworkManager.connectionError)
    }
  }
  
  /**
   Starts reachability observing
   */
  class func startObservingReachability() {
    let reachability = NetworkManager.sharedReachability
    
    reachability.whenReachable = { reachability in
    }
    
    reachability.whenUnreachable = { reachability in
    }
    
    let _ = reachability.startNotifier()
    
    // Initial reachability check
    if reachability.isReachable() {
      
    }
  }
}
