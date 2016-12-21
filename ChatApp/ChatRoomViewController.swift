//
//  ChatRoomViewController.swift
//  ChatApp
//
//  Created by Zachary Collins on 11/21/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit
import MultipeerConnectivity

// Base View Controller
class ChatRoomViewController: UIViewController {

    var textBoxDelegate: ChatRoomTextBoxDelegate!
    var peerList = [MCPeerID]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    
    // Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        appDelegate.chatRoom.delegate = self
        
        textBoxDelegate = ChatRoomTextBoxDelegate(viewController: self)
        textView.delegate = textBoxDelegate
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        appDelegate.serviceManager.stopBrowsing()
        appDelegate.serviceManager.connectWithPeers( withID: appDelegate.chatRoom.roomId )
        appDelegate.serviceManager.startAdvertising( roomId: appDelegate.chatRoom.roomId)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileView"{
            
            guard let destinationVC = segue.destination as? ProfileViewController else{
                return
            }
            guard let userId = sender as? String else{
                return
            }
            guard let participant = appDelegate.chatRoom.participantList2[userId] else{
                return
            }

            destinationVC.profile = participant
        }
    }
    
    // Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        // send message to others that you left room
        performSegue(withIdentifier: "unwindToMenu", sender: nil)
    }
}

// Table View Delegate
extension ChatRoomViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.chatRoom.messageLog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let row = indexPath.row
        if appDelegate.chatRoom.messageLog[row].userId == "SYSTEM"{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell", for: indexPath) as? SystemCell else{
                // Display Error
                return UITableViewCell()
            }
            cell.contentsLabel.text = appDelegate.chatRoom.messageLog[row].contents
            return cell
        }
        
        else if appDelegate.chatRoom.messageLog[row].userId == UIDevice.current.name {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell else{
                // Display Error
                return UITableViewCell()
            }
            cell.contentsLabel.text = appDelegate.chatRoom.messageLog[row].contents
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nonUserCell", for: indexPath) as? NonUserCell else{
                // Display Error
                return UITableViewCell()
            }
            
            // no user id found
            cell.userId = appDelegate.chatRoom.messageLog[row].userId
            cell.delegate = self
            cell.contentsLabel.text = appDelegate.chatRoom.messageLog[row].contents
            return cell
        }
    }
}

extension ChatRoomViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return appDelegate.chatRoom.participantList2.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let row = indexPath.row
        var data = Array(appDelegate.chatRoom.participantList2.keys).sorted()[row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "participantIcon", for: indexPath) as? UICollectionViewCell else{
            // Display Error
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}

// ChatRoom Delegate
extension ChatRoomViewController: chatRoomDelegate{
    func updateMessageList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func updateParticipantList(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// Non User Cell Protocol
extension ChatRoomViewController: NonUserCellProtocol{
    func profileImageClicked( userId: String ) {
        performSegue(withIdentifier: "profileView", sender: userId)
    }
}




