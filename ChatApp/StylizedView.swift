//
//  StylizedView.swift
//  ChatApp
//
//  Created by Zachary Collins on 2/5/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class StylizedView : UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Constants.Visual.CornerRadius
    }
}
