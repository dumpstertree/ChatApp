//
//  OtherUserCell.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/4/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class NonUserCell: UITableViewCell{
    @IBOutlet weak var profilePictureButton: RoundButtonView!
    @IBOutlet weak var contentsLabel: UILabel!
    var delegate: NonUserCellProtocol?
    var userId: String?
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let userId = self.userId else{
            return
        }
        delegate?.profileImageClicked( userId: userId )
    }
}

protocol NonUserCellProtocol {
    func profileImageClicked( userId: String )
}
