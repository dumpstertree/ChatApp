//
//  AudioPlayer.swift
//  ChatApp
//
//  Created by Zachary Collins on 2/11/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    static func play( source: AudioSource ){
        let systemSoundID: SystemSoundID = source.rawValue
        AudioServicesPlaySystemSound (systemSoundID)
    }
}

public enum AudioSource: UInt32 {
    case Tweet = 1016
    case RoomCreated = 1000
    case MessageRecieved = 1003
    case MessageSent = 1004
    case Error = 1006
    case ButtonClick = 1306
}
