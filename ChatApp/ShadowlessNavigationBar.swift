//
//  ShadowlessNavigationBar.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/11/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit
class ShadowlessNavigationBar: UINavigationBar{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
    }
}
