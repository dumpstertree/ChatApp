//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Zachary Collins on 2/5/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {

    // Outlets
    @IBOutlet weak var loginButton: StylizedButton!
    
    // Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    // Actions
    @IBAction func skipButtonPressed(_ sender: Any) {
       
        // Play Audio
        AudioPlayer.play(source: AudioSource.ButtonClick)
        
        // Create ANON Login Info
        Constants.UserInfo.FirstName = "Anon"
        Constants.UserInfo.UserId = UIDevice.current.name
        
        // Segue
        self.performSegue(withIdentifier: "login", sender: self)
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        // Play Audio
        AudioPlayer.play(source: AudioSource.ButtonClick)
        
        // Attempt to Login with FB Class
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil{
                AlertDisplay.display(alert: AlertMessages.UnknownFBLoginError, controller: self)
                return
            }
            self.decryptToken()
        }
    }
    
    // Private Functions
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in completion(data, response, error) }.resume()
    }
    func decryptToken(){
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start{
            (connection, result, err) in
            
            if err != nil{
                AlertDisplay.display(alert: AlertMessages.UnknownFBLoginError, controller: self)
            }
            
            guard let result = result as? [String: AnyObject] else{
                AlertDisplay.display(alert: AlertMessages.UnknownFBLoginError, controller: self)
                return
            }
            
            self.storeID( result: result )
            self.storeFirstName( result: result )
            self.storeProfilePicture( result: result ){
                 self.performSegue(withIdentifier: "login", sender: self)
            }
        }
    }
    func storeID( result: [String:AnyObject]  ){
        guard let id = result["id"] as? String else{
            AlertDisplay.display(alert: AlertMessages.UnknownFBLoginError, controller: self)
            return
        }
        Constants.UserInfo.UserId = id
    }
    func storeFirstName( result: [String:AnyObject] ){
        guard let name = result["name"] as? String else{
            AlertDisplay.display(alert: AlertMessages.UnknownFBLoginError, controller: self)
            return
        }
        Constants.UserInfo.FirstName = name
    }
    func storeProfilePicture( result: [String:AnyObject], completion: @escaping () -> Void){
        
        guard let url = URL(string: "https://graph.facebook.com/\(Constants.UserInfo.ProfilePicture)/picture?type=large") else{
            return
        }

        getDataFromUrl(url: url) { (data, response, error) in
            if error != nil{
                completion()
                return
            }
            
            guard let data = data else{
                completion()
                return
            }
            guard let image = UIImage(data: data) else{
                completion()
                return
            }
            
            Constants.UserInfo.ProfilePicture = image
            completion()
        }
    }
}
