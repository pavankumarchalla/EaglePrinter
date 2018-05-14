//
//  PrinterListTableViewCell.swift
//  Eagle
//
//  Created by Ramprasad A on 18/01/18.
//  Copyright © 2018 Hardwin Software Solutions. All rights reserved.
//

import UIKit
import DLRadioButton

protocol CellHadlerDelegate: NSObjectProtocol {
	func printerSelected(atCell cell: PrinterListTableViewCell)
}

class PrinterListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var printerRadioSelected: DLRadioButton!
	@IBOutlet weak var printerNameLabel: UILabel!
	
	weak var delegate: CellHadlerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	@IBAction func selectPrinterTapped(_ sender: Any) {
		self.delegate?.printerSelected(atCell: self)
	}
}
