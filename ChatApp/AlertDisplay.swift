//
//  ErrorDisplay.swift
//  ChatApp
//
//  Created by Zachary Collins on 2/11/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class AlertDisplay{
    
    static func display( alert: AlertMessages, controller: UIViewController ){
        display(alert: alert.rawValue, controller: controller)
    }
    
    static func display( alert: String, controller: UIViewController){
        OperationQueue.main.addOperation {
            
            // Set alert Text
            let alertController = UIAlertController(title: "", message: alert, preferredStyle: UIAlertControllerStyle.alert)
            
            // Add Dismiss
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            // Display
            controller.present(alertController, animated: true, completion: nil)
        
            // Play Sound Effect
            AudioPlayer.play(source: AudioSource.Error)
        }
    }
}

public enum AlertMessages : String {
    case UnknownFBLoginError = "Something went wrong with your login. Try again later."
    case AlreadyExistingRoom = "Room name already exists, try another."
    case InvalidRoomName     = "Room name not valid, try another."
    case UnkownError         = "Sorry! Something seems to have gone wrong"
}
