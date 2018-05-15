//
//  PrintersViewController.swift
//  Eagle
//
//  Created by Ramprasad A on 18/01/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PrintersViewController: UIViewController, NVActivityIndicatorViewable {
  
  @IBOutlet weak var noPrintersDisplayLabel: UILabel!
  @IBOutlet weak var printersListTableView: UITableView!

  var activityIndicator: NVActivityIndicatorView?
  var printerList: [PrinterData] = []
  var selectedIndexPath: IndexPath?
  var filteredArray: [[PrinterData]] {
    return self.printerList.group(by: { $0.type })
  }
  
  var netServicesBrowser: NetServiceBrowser?
  var printersArray:[NetService] = []
  var pdfData: Data?
  var inputStream: InputStream?
  var outputStream: OutputStream?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(PrintersViewController.downloadPDF(notification:)), name: Notification.Name("PDF_URL"), object: nil)
    
    self.netServicesBrowser = NetServiceBrowser()
    self.netServicesBrowser?.delegate = self
    self.netServicesBrowser?.includesPeerToPeer = true
    self.netServicesBrowser?.searchForServices(ofType: "_printer._tcp.", inDomain: "local.")
    self.netServicesBrowser?.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
    
    self.navigationController?.navigationBar.prefersLargeTitles = true
    //        self.showNoPrinters()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  ///Handles downloading of PDF file when the app open throught deep linking.
  @objc func downloadPDF(notification: Notification) {
    
    let size = CGSize(width: 100.0, height: 100.0)
    startAnimating(size, message: "Please Wait..!")
    var userInfo = [String: AnyObject]()
    
    if let object = notification.object as? [String: AnyObject] {
      
      if let pdfUrl = object["PDF_DOWNLOAD_URL"] as? String {
    
        userInfo["PDF_DOWNLOAD_URL"] = pdfUrl as AnyObject
      
        SyncManager.syncOperation(operationType: .downloadPDF, info: userInfo) { (response, error) in
        
          if error == nil {
          
            guard let fileURL = response as? URL else { return }
            
            DispatchQueue.main.async {
            
              self.stopAnimating()
              if let pdfVC = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as? PDFViewController {
                pdfVC.webPdfURL = pdfUrl
                pdfVC.pdfURL = fileURL
                self.present(pdfVC, animated: true, completion: nil)
              }
            }
          } else {
            DispatchQueue.main.async {
              self.stopAnimating()
            }
          }
        }
      }
    }
  }
  
  @IBAction func refreshButtonTapped(_ sender: Any) {
    //        self.getPrinters()
  }
  
  func showAlert(withMessage msg: String) {
    let alertController = UIAlertController(title: "Eagle", message: msg, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
}

extension PrintersViewController {
  
  func openPDF(withURL url: URL) {
    
  }
  
  func showNoPrinters() {
    if self.printersArray.count == 0 {
      self.noPrintersDisplayLabel.isHidden = false
      self.printersListTableView.isHidden = true
    } else {
      self.noPrintersDisplayLabel.isHidden = true
      self.printersListTableView.isHidden = false
    }
  }
  
  func connect(with ip: String, and port: Int) {
    
    Stream.getStreamsToHost(withName: ip, port: port, inputStream: &inputStream, outputStream: &outputStream)
    
    if inputStream != nil && outputStream != nil {
      
      // Set delegate
      inputStream!.delegate = self
      outputStream!.delegate = self
      
      // Schedule
      inputStream!.schedule(in: .main, forMode: RunLoopMode.defaultRunLoopMode)
      outputStream!.schedule(in: .main, forMode: RunLoopMode.defaultRunLoopMode)
      
      print("Start open()")
      
      // Open!
      inputStream!.open()
      outputStream!.open()
    }
  }
}

extension PrintersViewController : StreamDelegate {
  
  func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
    if aStream === inputStream {
      switch eventCode {
      case Stream.Event.errorOccurred:
        print("input: ErrorOccurred: \(String(describing: aStream.streamError))")
      case Stream.Event.openCompleted:
        print("input: OpenCompleted")
      case Stream.Event.hasBytesAvailable:
        print("input: HasBytesAvailable")
        
        // Here you can `read()` from `inputStream`
        let inputStreamData = Data(reading: inputStream!)
        print(inputStreamData)
        
      default:
        break
      }
    
    } else if aStream === outputStream {
      
      switch eventCode {
      case Stream.Event.errorOccurred:
        print("output: ErrorOccurred: \(String(describing: aStream.streamError) )")
      case Stream.Event.openCompleted:
        print("output: OpenCompleted")
      case Stream.Event.hasSpaceAvailable:
        print("output: HasSpaceAvailable")
        
        //                 Here you can write() to `outputStream`
        //                let message = "I am sending data to printer"
        guard let printingData = self.pdfData else { return }
        let data: Data = printingData
        let bytesWritten = data.withUnsafeBytes { outputStream?.write($0, maxLength: data.count) }
        
        print(bytesWritten ?? "")
        
        outputStream?.close()
        
      default:
        break
      }
    }
  }
}

extension PrintersViewController: NetServiceBrowserDelegate {
  
  func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
    print("Started Searching")
  }
  
  func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
    print("Stopped Searching for Services")
  }
  
  func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
    print("Service removed")
    print("Removed Service: \(service.name)")
  }
  
  func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
    print("Did Find: \(service.name)")
    self.printersArray.append(service)
    service.delegate = self
    self.printersListTableView.reloadData()
    //        self.showNoPrinters()
  }
  
  func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
    print("Did Find Domain: \(domainString)")
  }
  
  func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
    print("Error Searching for Services: \(errorDict)")
  }
}

//MARK:- NetServiceDelegate Methods
extension PrintersViewController: NetServiceDelegate {
  
  func netServiceDidResolveAddress(_ sender: NetService) {
    if let addresses = sender.addresses, addresses.count > 0 {
      for address in addresses {
        let data = address as NSData
        let inetAddress: sockaddr_in = data.castToCPointer()
        if inetAddress.sin_family == __uint8_t(AF_INET) {
          if let ip = String(cString: inet_ntoa(inetAddress.sin_addr), encoding: .ascii) {
            // IPv4
            print(ip)
            let port = String(UInt16(inetAddress.sin_port).byteSwapped)
            print(port)
            
            //With reference to this answer in Stackoverflow, we have set the default port to 9100
            //https://stackoverflow.com/questions/7974027/how-can-i-send-data-to-ethernet-printer-from-iphone-ipad-programmatically
            
            self.connect(with: ip, and: 9100)
          }
          
          
        } else if inetAddress.sin_family == __uint8_t(AF_INET6) {
          let inetAddress6: sockaddr_in6 = data.castToCPointer()
          let ipStringBuffer = UnsafeMutablePointer<Int8>.allocate(capacity: Int(INET6_ADDRSTRLEN))
          var addr = inetAddress6.sin6_addr
          
          if let ipString = inet_ntop(Int32(inetAddress6.sin6_family), &addr, ipStringBuffer, __uint32_t(INET6_ADDRSTRLEN)) {
            if let ip = String(cString: ipString, encoding: .ascii) {
              // IPv6
              print(ip)
            }
          }
          
          ipStringBuffer.deallocate(capacity: Int(INET6_ADDRSTRLEN))
        }
      }
    }
  }
  
  func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
    
  }
}

extension PrintersViewController: JSONConvertible { }

//Helper Methods:
extension PrintersViewController {
  
  func getPrinters() {
    self.selectedIndexPath = nil
    let size = CGSize(width: 100.0, height: 100.0)
    startAnimating(size, message: "Please Wait..!")
    SyncManager.syncOperation(operationType: .getPrintersList, info: [:]) { (response, error) in
      if error == nil {
        self.stopAnimating()
        guard let responseData = response as? [[String: AnyObject]] else { return }
        self.printerList = self.parseJSON(withData: responseData)
        DispatchQueue.main.async {
          self.printersListTableView.reloadData()
        }
      } else {
        self.stopAnimating()
        print("Error: ")
      }
    }
  }
}

//MARK:- UITableViewDataSource
extension PrintersViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.printersArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "printerCell", for: indexPath)
    cell.textLabel?.text = self.printersArray[indexPath.row].name
    return cell
  }
}

//MARK:- UITableViewDelegate
extension PrintersViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.printersArray[indexPath.row].resolve(withTimeout: 0.0)
  }
}

//MARK:- CellHadlerDelegate
extension PrintersViewController: CellHadlerDelegate {
  
  func printerSelected(atCell cell: PrinterListTableViewCell) {
    if let indexPath = self.printersListTableView.indexPath(for: cell) {
      self.selectedIndexPath = indexPath
      self.printersListTableView.reloadData()
    }
  }
}
