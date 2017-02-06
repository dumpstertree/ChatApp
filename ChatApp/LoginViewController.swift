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

    @IBOutlet weak var loginButton: StylizedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in completion(data, response, error) }.resume()
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "login", sender: self)
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil{
                print(err!)
                return
            }
            
            self.decryptToken()
        }
    }
    
    func decryptToken(){
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start{
            (connection, result, err) in
            
            if err != nil{
                print(err!)
            }
            
            guard let result = result as? [String: AnyObject] else{
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
            print("Could not get userID")
            return
        }
        Constants.UserInfo.UserId = id
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
    func storeFirstName( result: [String:AnyObject] ){
        guard let name = result["name"] as? String else{
            print("Could not get name")
            return
        }
        Constants.UserInfo.FirstName = name
    }
}
