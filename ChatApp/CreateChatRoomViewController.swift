//
//  CreateChatRoomViewController.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/4/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class CreateChatRoomViewController: UIViewController {

    // Instance Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var textBoxDelegate: TextFieldDelegate!
    
    // Outlets
    @IBOutlet weak var chatRoomNameLabel: UITextField!
    
    // Overide
    override func viewDidLoad() {
        super.viewDidLoad()
        textBoxDelegate = TextFieldDelegate()
        chatRoomNameLabel.delegate = textBoxDelegate
    }
    
    // Actions
    @IBAction func createButtonPressed(_ sender: Any) {
        
        // Play Audio
        AudioPlayer.play(source: AudioSource.ButtonClick)
        
        // Name is not left blank
        guard chatRoomNameLabel.text! != "" else{
            AlertDisplay.display(alert: AlertMessages.InvalidRoomName, controller: self)
            return
        }
       
        // No other room with the same name exists
        guard appDelegate.serviceManager.nearbyPeers[chatRoomNameLabel.text!] == nil else{
            AlertDisplay.display(alert: AlertMessages.AlreadyExistingRoom, controller: self)
            return
        }
        
        appDelegate.chatRoom = ChatRoom(roomId: chatRoomNameLabel.text! )
        performSegue(withIdentifier: "showChatRoom", sender: nil)
    }
    @IBAction func dismissButtonPressed(_ sender: Any) {
       
        // Play Audio
        AudioPlayer.play(source: AudioSource.ButtonClick)
        
        
        // Segue
        ForceRefresh.forceRefresh()
        dismiss(animated: true, completion: nil)
    }
}
