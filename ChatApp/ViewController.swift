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
    var blurEffectView: UIVisualEffectView?
    
    // Outlets
    @IBOutlet weak var profilePicImageView: RoundImageView!
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Override
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.serviceManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        ForceRefresh.delegates.append(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.serviceManager.session.disconnect()
        appDelegate.serviceManager.stopAdvertising()
        appDelegate.serviceManager.startBrowsing()
        
        if Constants.UserInfo.ProfilePicture != nil{
            profilePicImageView.image = Constants.UserInfo.ProfilePicture
        }
        
        if let _ = blurEffectView{
            blurEffectView!.removeFromSuperview()
            blurEffectView = nil
        }
    }
    
    // Actions
    @IBAction func createNewRoom( _ sender: AnyObject ) {
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.regular))
        
        guard let blurEffectView = blurEffectView else{
            return
        }
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
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

extension ViewController : ForceRefreshProtocol {
    func forceRefresh(){
        if let _ = blurEffectView{
            blurEffectView!.removeFromSuperview()
            blurEffectView = nil
        }
    }
}

// ServiceManager Delegate
protocol ServiceManagerDelegate {
    func roomListChanged()
}

