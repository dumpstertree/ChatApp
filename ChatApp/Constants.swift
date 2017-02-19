//
//  Constants.swift
//  ChatApp
//
//  Created by Zachary Collins on 11/22/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

struct Constants{
    
    struct Visual{
        static let Red = (1,0,0,0)
        static let BorderWidth: CGFloat = 3
        static let CornerRadius: CGFloat = 10
    }
    
    struct UserInfo{
        static var UserId: String!
        static var FirstName: String!
        static var ProfilePicture: UIImage! = UIImage(named: "logo")
        static func logout(){
            UserId = nil
            FirstName = nil
            ProfilePicture = nil
        }
    }    
}
