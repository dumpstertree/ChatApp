//
//  ChatRoomTextBoxDelegate.swift
//  ChatApp
//
//  Created by Zachary Collins on 11/22/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class ChatRoomTextBoxDelegate: NSObject, UITextViewDelegate {
    
    let viewController: UIViewController?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        if text == "\n" {
            
            guard textView.text != "" else{
                return true
            }
            
            textView.resignFirstResponder()
            appDelegate.chatRoom.sendMessage(contents: textView.text!)
            textView.text = ""
            return false
        }

        return true
    }
    
    init( viewController: UIViewController ){
        self.viewController = viewController
    }
}
