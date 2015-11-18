//
//  TableViewCell.swift
//  mnazari_APD1_FinalProject
//
//  Created by Mirabutaleb Nazari on 3/23/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var tipAmount: UILabel!
	@IBOutlet weak var serviceAmount: UILabel!
	@IBOutlet weak var totalAmount: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
