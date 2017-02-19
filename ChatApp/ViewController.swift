//
//  ViewController.swift
//  ChatApp
//
//  Created by Zachary Collins on 11/21/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit
import MultipeerConnectivity

// Main View Controller
class ViewController: UIViewController {
   
    var roomList = [String:Int]()
    var blurEffectView: UIVisualEffectView?
    
    // Outlets
    @IBOutlet weak var profilePicImageView: RoundImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noOneAroundLabel: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Override
    override func viewDidLoad() {
        
        // init super
        super.viewDidLoad()
        
        // set delegates
        appDelegate.serviceManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        ForceRefresh.delegates.append(self)
        
        // start browsing [this is the only time this is called]
        appDelegate.serviceManager.startBrowsing()
    }
    override func viewWillAppear(_ animated: Bool) {
        forceRefresh()
    }
    
    // Actions
    func joinExistingRoom( roomId: String ){
        // join an existing room with room id as name
        appDelegate.chatRoom = ChatRoom(roomId: roomId)
        performSegue(withIdentifier: "joinChatRoom", sender: nil)
    }
    @IBAction func createNewRoom( _ sender: AnyObject ) {
       
        // Play Audio
        AudioPlayer.play(source: AudioSource.ButtonClick)
        
        // Create Blur Effect
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.regular))
        
        guard let blurEffectView = blurEffectView else{
            return
        }
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        // Segue
        performSegue(withIdentifier: "createChatRoom", sender: nil)
    }
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        // Play Audio
        AudioPlayer.play(source: AudioSource.ButtonClick)
        
        // Logout
        Constants.UserInfo.logout()
        dismiss(animated: true, completion: nil)
    }
}


// Service Manager Delegate Implementation
extension ViewController : ServiceManagerDelegate {
    func roomListChanged() {
        DispatchQueue.main.async {
            var tempRoomList = [String:Int]()
            for (key,value) in self.appDelegate.serviceManager.nearbyPeers{
                tempRoomList[key] = value.count
            }
            self.roomList = tempRoomList
            self.tableView.reloadData()
        }
    }
}

// Table View Delegate
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if roomList.count == 0{
            noOneAroundLabel.isHidden = false
        }
        else{
            noOneAroundLabel.isHidden = true
        }
        
        return roomList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        // Populate Cell
        let row = indexPath.row
        let key = Array(roomList.keys).sorted()[row]
        guard let value = roomList[key] else{
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as? ChatRoomCell else{
            return UITableViewCell()
        }
        
        cell.contentsLabel?.text = key
        cell.participantsLabel?.text = "\(value)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Play Audio
        AudioPlayer.play(source: AudioSource.ButtonClick)
        
        // Get Cell Info
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatRoomCell else{
            return
        }
        
        let roomId = cell.contentsLabel.text
        joinExistingRoom( roomId: roomId! )
    }
}

// Force Refresh Delegate
extension ViewController : ForceRefreshProtocol {
    func forceRefresh(){
       
       // Disconnect
        appDelegate.serviceManager.disconnect()
        
        // Refresh the room List
        roomListChanged()
        
        // Remove Blur
        if let _ = blurEffectView{
            blurEffectView!.removeFromSuperview()
            blurEffectView = nil
        }
    }
}

