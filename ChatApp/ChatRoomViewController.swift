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
    var blurEffectView: UIVisualEffectView?
    
    // Outlets
   // @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    
    // Override
    override func viewDidLoad() {
        // init super
        super.viewDidLoad()
        
        // set delegates
        collectionView.delegate   = self
        collectionView.dataSource = self
        tableView.delegate        = self
        tableView.dataSource      = self
        appDelegate.chatRoom.delegate = self
        ForceRefresh.delegates.append(self)
        textBoxDelegate = ChatRoomTextBoxDelegate(viewController: self)
        textView.delegate = textBoxDelegate
        
        // set table view dimensions
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // set room name
       // roomNameLabel.text = appDelegate.chatRoom.roomId
    }
    override func viewWillAppear(_ animated: Bool) {
        // connect to anyone with the same room id
        appDelegate.serviceManager.connectWithPeers( withID: appDelegate.chatRoom.roomId )
        // start advertising as someone in the room
        appDelegate.serviceManager.startAdvertising( roomId: appDelegate.chatRoom.roomId)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileView"{
            
            // Play Audio
            AudioPlayer.play(source: AudioSource.ButtonClick)
            
            // guard aga
            guard let destinationVC = segue.destination as? ProfileViewController else{
                AlertDisplay.display(alert: AlertMessages.UnkownError, controller: self)
                return
            }
            guard let userId = sender as? String else{
                 AlertDisplay.display(alert: AlertMessages.UnkownError, controller: self)
                return
            }
            guard let participant = appDelegate.chatRoom.participantList2[userId] else{
                 AlertDisplay.display(alert: AlertMessages.UnkownError, controller: self)
                return
            }
            
            // Create Blur Effect
            blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.regular))
            
            guard let blurEffectView = blurEffectView else{
                 AlertDisplay.display(alert: AlertMessages.UnkownError, controller: self)
                return
            }
            
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)

            // set profile to view
            destinationVC.profile = participant
        }
    }
    
    // Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        ForceRefresh.forceRefresh()
        performSegue(withIdentifier: "unwindToMenu", sender: nil)
    }
}

// Table View Delegate
extension ChatRoomViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.chatRoom.messageLog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        // Create SYSTEM cells
        let row = indexPath.row
        if appDelegate.chatRoom.messageLog[row].userId == "SYSTEM"{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell", for: indexPath) as? SystemCell else{
                return UITableViewCell()
            }
            cell.contentsLabel.text = appDelegate.chatRoom.messageLog[row].contents
            return cell
        }
        
        // Create USER cells
        else if appDelegate.chatRoom.messageLog[row].userId == UIDevice.current.name {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell else{
                return UITableViewCell()
            }
            
            let message = appDelegate.chatRoom.messageLog[row]
            cell.contentsLabel.text  = message.contents
            cell.profilePictureImage.image = Constants.UserInfo.ProfilePicture
            return cell
        }
            
        // Create NONUSER cells
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nonUserCell", for: indexPath) as? NonUserCell else{
                return UITableViewCell()
            }
            cell.userId = appDelegate.chatRoom.messageLog[row].userId
            cell.delegate = self
            cell.contentsLabel.text = appDelegate.chatRoom.messageLog[row].contents
            let participant = appDelegate.chatRoom.participantList2[appDelegate.chatRoom.messageLog[row].userId]
            cell.profilePictureImageView.image = participant?.profileImage
            return cell
        }
    }
}

// Collection View Delegate
extension ChatRoomViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return appDelegate.chatRoom.participantList2.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
       
        let row = indexPath.row
        let participantKey = Array(appDelegate.chatRoom.participantList2.keys).sorted()[row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "participantIcon", for: indexPath) as? CustomCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let participant = appDelegate.chatRoom.participantList2[participantKey] else{
            return cell
        }
        
        cell.imageView.image = participant.profileImage
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

// Force Refresh Protocol
extension ChatRoomViewController: ForceRefreshProtocol{
    func forceRefresh() {
        if let _ = blurEffectView{
            blurEffectView!.removeFromSuperview()
            blurEffectView = nil
        }
    }
}




