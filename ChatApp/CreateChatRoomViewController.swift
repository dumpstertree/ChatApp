//
//  CreateChatRoomViewController.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/4/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class CreateChatRoomViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var chatRoomNameLabel: UITextField!
    @IBAction func createButtonPressed(_ sender: Any) {
        
        // Name is not left blank
        guard chatRoomNameLabel.text! != "" else{
            print("Room Name Not Valid")
            // Display Error
            return
        }
        // No other room with the same name exists
        guard appDelegate.serviceManager.nearbyPeers[chatRoomNameLabel.text!] == nil else{
            print("Room Name Already Exists")
            // Dislay Error
            return
        }
        
        appDelegate.chatRoom = ChatRoom(roomId: chatRoomNameLabel.text! )
        performSegue(withIdentifier: "showChatRoom", sender: nil)
    }
}
