//
//  UserCell.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/4/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//


import UIKit

class UserCell: UITableViewCell{
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var contentsLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}
