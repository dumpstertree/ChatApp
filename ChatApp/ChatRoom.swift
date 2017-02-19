//
//  ChatRoom.swift
//  ChatApp
//
//  Created by Zachary Collins on 11/21/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ChatRoom{
    
    var roomId: String
    var participantList: [MCPeerID]
    
    var messageLog       = [Message]()
    var participantList2 = [String:Participant]()
    
    var appDelegate: AppDelegate
    var delegate: chatRoomDelegate?
    
    // Create new Room
    init( roomId: String ){
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.roomId = roomId
        
        if appDelegate.serviceManager.nearbyPeers[roomId] == nil{
            self.participantList = []
        }
        else{
            self.participantList = appDelegate.serviceManager.nearbyPeers[roomId]!
        }
    }
    
    // Messaging
    func sendMessage( contents: String ){
        sendMessage(contents: contents, userID: Constants.UserInfo.UserId)
    }
    func sendMessage( contents: String, userID: String ){
        let message = Message(contents: contents,userId: userID)
        messageLog.append(message)
        appDelegate.serviceManager.sendData(withMessage: message)
        delegate?.updateMessageList()
        
        AudioPlayer.play(source: AudioSource.MessageSent)
    }
    func recieveMessage(contents: String, userId: String){
        let message = Message(contents: contents,userId: userId)
        messageLog.append(message)
        delegate?.updateMessageList()
        
        AudioPlayer.play(source: AudioSource.MessageRecieved)
    }
    
    // Participant
    func sendParticipantInfo(){
       
        guard let name = Constants.UserInfo.FirstName else{
            return
        }
        guard let userId = Constants.UserInfo.UserId else{
            return
        }
        guard let profileImage = Constants.UserInfo.ProfilePicture else{
            return
        }
        
        let participant = Participant(firstName: name, userId: userId, profileImage: profileImage)
        
        appDelegate.serviceManager.sendData(withProfile: participant)
        delegate?.updateParticipantList()
    }
    func recieveParticipantInfo( participant: Participant ){
        participantList2[participant.userId] = participant
        delegate?.updateParticipantList()
    }
    func removeParticipantInfo( peerID: MCPeerID ){
       
        for(userID,participant) in participantList2{
            if ( participant.userId == peerID.displayName ){
                recieveMessage(contents: "\(participant.firstName) left the room", userId: "SYSTEM")
                participantList2.removeValue(forKey: userID )
                break;
            }
        }
        
        delegate?.updateParticipantList()
    }
}

protocol chatRoomDelegate {
    func updateMessageList()
    func updateParticipantList()
}
