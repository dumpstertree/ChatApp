//
//  RoundButtonView.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/11/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit
class RoundButtonView:UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = frame.height/2
        self.layer.masksToBounds = true
    }
}
