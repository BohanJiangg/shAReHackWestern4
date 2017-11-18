//
//  loginViewController.swift
//  shARe
//
//  Created by Bohan Jiang on 2017-11-18.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import UIKit

class loginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //creating button
       
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center

        self.view.backgroundColor = UIColor.white
        //adding it to view
        view.addSubview(loginButton)
        
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        
        }
        loginButton.delegate = self
       // view.resig
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            print("Hello")
           // let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
            //let vc = storyboard.instantiateViewController(withIdentifier: "Main")
            let viewController:UIViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as UIViewController
            // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
            self.view.backgroundColor = nil
            self.present(viewController, animated: false, completion: nil)
            
        }
    }
    
    @IBAction func SwitchViews(_ sender: Any) {
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        self.show(vc as! UIViewController, sender: vc)
    }

    //when login button clicked
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
                
            })
        }
    }
    
    // Once the button is clicked, show the login dialog
  
}
