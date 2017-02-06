//
//  RoundImageView.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/9/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class RoundImageView:UIImageView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = frame.height/2
        self.layer.masksToBounds = true
        self.layer.borderWidth = Constants.Visual.BorderWidth
        self.layer.borderColor = UIColor.white.cgColor
    }
}
