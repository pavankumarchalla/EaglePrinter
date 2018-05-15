//
//  PDFViewController.swift
//  Eagle
//
//  Created by Ramprasad A on 05/04/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController {
  
  @IBOutlet weak var pdfWebKit: WKWebView!
  var webPdfURL: String?
  var pdfURL: URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let fileURL = webPdfURL {
      if let url = URL(string: fileURL) {
        let urlRequest = URLRequest(url: url)
        self.pdfWebKit.load(urlRequest)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func printTapped(_ sender: Any) {
    if let fileURL = pdfURL {
      let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view
      self.present(activityViewController, animated: true, completion: {
      })
    }
  }
  
  @IBAction func cancelTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
