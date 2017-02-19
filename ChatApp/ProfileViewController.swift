//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Zachary Collins on 12/10/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: RoundImageView!
    
    var profile: Participant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let firstName = profile?.firstName, let profileImage = profile?.profileImage else{
            return
        }
        
        nameLabel.text = firstName
        profilePictureImage.image = profileImage
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
       
        // Play Audio
        AudioPlayer.play(source: AudioSource.ButtonClick)
        
        // Segue
        ForceRefresh.forceRefresh()
        dismiss(animated: true, completion: nil)
    }
}
