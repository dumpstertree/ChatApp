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
   
    var roomList = [String]()
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.serviceManager.delegate = self
        
        appDelegate.serviceManager.mcSession.disconnect()
        appDelegate.serviceManager.stopAdvertising()
        appDelegate.serviceManager.startBrowsing()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Actions
    @IBAction func createNewRoom( _ sender: AnyObject ) {
        performSegue(withIdentifier: "createChatRoom", sender: nil)
    }
    func joinExistingRoom( roomId: String ){
        appDelegate.chatRoom = ChatRoom(roomId: roomId)
        performSegue(withIdentifier: "joinChatRoom", sender: nil)
    }
    
    // Unwind Actions
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
}

// Service Manager Delegate Implementation
extension ViewController : ServiceManagerDelegate {
    
    func roomListChanged() {
        DispatchQueue.main.async {
            var tempRoomList = [String]()
            for (key,_) in self.appDelegate.serviceManager.nearbyPeers{
                tempRoomList.append(key)
            }
            self.roomList = tempRoomList
            self.tableView.reloadData()
        }
    }
}

// Table View Delegate
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as? ChatRoomCell else{
            // Display Error
            return UITableViewCell()
        }

        let row = indexPath.row
        cell.contentsLabel?.text = roomList[row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatRoomCell else{
            return
        }
        
        let roomId = cell.contentsLabel.text
        joinExistingRoom( roomId: roomId! )
    }
}

// ServiceManager Delegate
protocol ServiceManagerDelegate {
    func roomListChanged()
}
