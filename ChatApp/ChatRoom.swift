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
    
    var messageLog   = [Message]()
    var participants = [Participant]()
    var participantList2 = [ String: Participant]()
    
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
        sendMessage(contents: contents, userID: UIDevice.current.name)
    }
    func sendMessage( contents: String, userID: String ){
        let message = Message(contents: contents,userId: userID)
        messageLog.append(message)
        appDelegate.serviceManager.sendData(withMessage: message)
        delegate?.updateMessageList()
    }
    func recieveMessage(contents: String, userId: String){
        let message = Message(contents: contents,userId: userId)
        messageLog.append(message)
        delegate?.updateMessageList()
    }
    
    // Participant
    func sendParticipantInfo(){
        let participant = Participant(firstName: "Zach", lastName: "Collins", userId: UIDevice.current.name)
        appDelegate.serviceManager.sendData(withProfile: participant)
        delegate?.updateParticipantList()
    }
    func recieveParticipantInfo( participant: Participant ){
        participantList2[participant.userId] = participant
        delegate?.updateParticipantList()
    }
    func removeParticipantInfo(){
        delegate?.updateParticipantList()
    }
    func updateParticipantInfo(){
        delegate?.updateParticipantList()
    
    }
}


class Message: NSObject, NSCoding{
    
    let time: String
    let date: String
    let contents: String
    let userId: String
    
    init(contents: String, userId: String) {
        self.time = ""
        self.date = ""
        self.contents = contents
        self.userId = userId
    }
    
    required init(coder decoder: NSCoder) {
        self.time = decoder.decodeObject(forKey: "time") as? String ?? ""
        self.date = decoder.decodeObject(forKey: "date") as? String ?? ""
        self.contents = decoder.decodeObject(forKey: "contents") as? String ?? ""
        self.userId = decoder.decodeObject(forKey: "userId") as? String ?? ""
    }
    func encode(with coder: NSCoder) {
        coder.encode( time, forKey: "time" )
        coder.encode( date, forKey: "date" )
        coder.encode( contents, forKey: "contents" )
        coder.encode( userId, forKey: "userId" )
    }
}
class Participant: NSObject, NSCoding{
    
    let firstName: String
    let lastName: String
    let userId: String
    // profilepic
    
    init(firstName: String, lastName: String, userId: String){
        self.firstName = firstName
        self.lastName = lastName
        self.userId = userId
    }
    
    required init(coder decoder: NSCoder) {
        self.firstName = decoder.decodeObject(forKey: "firstName") as? String ?? ""
        self.lastName = decoder.decodeObject(forKey: "lastName") as? String ?? ""
        self.userId = decoder.decodeObject(forKey: "userId") as? String ?? ""
    }
    func encode(with coder: NSCoder) {
        coder.encode( firstName, forKey: "firstName" )
        coder.encode( lastName, forKey: "lastName" )
        coder.encode( userId, forKey: "userId" )
    }
}

protocol chatRoomDelegate {
    func updateMessageList()
    func updateParticipantList()
}
