//
//  SystemCell.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/8/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class SystemCell: UITableViewCell{
    @IBOutlet weak var contentsLabel: UILabel!
   
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}
