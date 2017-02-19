//
//  StylizedButton.swift
//  ChatApp
//
//  Created by Zachary Collins on 2/5/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class StylizedButton : UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Constants.Visual.CornerRadius
        self.layer.borderWidth = Constants.Visual.BorderWidth
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    
}
