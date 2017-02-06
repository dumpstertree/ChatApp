//
//  ServiceManager.swift
//  ChatApp
//
//  Created by Zachary Collins on 11/21/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//


import Foundation
import MultipeerConnectivity

class ServiceManager : NSObject {
    
    private let serviceType = "chat-app"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    var nearbyPeers = [ String:[MCPeerID] ]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    var delegate : ServiceManagerDelegate?
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.required)
        session.delegate = self
        return session
    }()
    
    override init() {
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
    }
    
    func startAdvertising( roomId: String ){
        mcAdvertiserAssistant = MCAdvertiserAssistant.init(serviceType: serviceType, discoveryInfo: ["id": roomId ], session: session)
        mcAdvertiserAssistant.start()
        serviceAdvertiser.startAdvertisingPeer()
    }
    func stopAdvertising(){
        if mcAdvertiserAssistant != nil{
            mcAdvertiserAssistant.stop()
        }
        serviceAdvertiser.stopAdvertisingPeer()
    }
    func startBrowsing(){
        serviceBrowser.startBrowsingForPeers()
    }
    func stopBrowsing(){
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func sendData( withProfile: Participant ){
        let data = NSKeyedArchiver.archivedData(withRootObject: withProfile)
        do {
            try session.send( data, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
        }
        catch{
        }
    }
    func sendData( withMessage: Message ){
        let data = NSKeyedArchiver.archivedData(withRootObject: withMessage)
        do {
            try session.send( data, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
        }
        catch{
        }
    }
    func connectWithPeers( withID: String ){
        
        guard let peersWithID = nearbyPeers[withID] else{
            return
        }
        
        for peer in peersWithID{
            serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: 10)
        }
    }
}


// Advertiser Delegate
extension ServiceManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping ((Bool, MCSession?) -> Void)) {
        invitationHandler(true, self.session)
    }
}

// Service Browser Delegate
extension ServiceManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error){
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?){
        
        guard let roomId = info?["id"]  else {
            return
        }
        
        if nearbyPeers[roomId] == nil{
            // create new list
            nearbyPeers[roomId] = [peerID]
        }
        else{
            // add to exsiting list
            nearbyPeers[roomId]?.append(peerID)
        }
    
        // Alert View Controller
        self.delegate?.roomListChanged()
        
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID){
    
        var i = 0
        for (key,value) in nearbyPeers {
            if value.contains(peerID){
                guard var peerList = nearbyPeers[key] else{
                    continue
                }
                peerList.remove(at: i)
                if peerList == [MCPeerID](){
                    nearbyPeers.removeValue(forKey: key)
                }
            }
            i += 1
        }
        
        print(nearbyPeers)
        
        // Alert View Controller
        self.delegate?.roomListChanged()
    }
}

// Session Delegate
extension ServiceManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.notConnected:
            print("not connected")
            break
        case MCSessionState.connecting:
            print("connecting")
            break
        case MCSessionState.connected:
            print("connected")
            appDelegate.chatRoom.sendParticipantInfo()
            appDelegate.chatRoom.sendMessage( contents: "\(Constants.UserInfo.FirstName) joined the room", userID: "SYSTEM"  )
            break
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        
        if let message = NSKeyedUnarchiver.unarchiveObject(with: data) as? Message {
            appDelegate.chatRoom.recieveMessage(contents: message.contents, userId: message.userId)
            return
        }
        
        if let participant = NSKeyedUnarchiver.unarchiveObject(with: data) as? Participant {
            appDelegate.chatRoom.recieveParticipantInfo(participant: participant)
            return
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?){
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
}

// Session States
extension MCSessionState {
    
    func stringValue() -> String {
        switch(self) {
        case .notConnected: return "NotConnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        }
    }
}


