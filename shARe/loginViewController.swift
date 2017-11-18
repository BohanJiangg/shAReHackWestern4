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
import Pastel

class loginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 31))
        label.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/6)
        label.textAlignment = .center
        label.text = "Welcome to"
        label.font = UIFont (name: "Avenir-Medium", size: 30)
        self.view.addSubview(label)
        
        let appName = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 51))
        appName.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/4 - 12)
        appName.textAlignment = .center
        appName.text = "shARe"
        appName.font = UIFont (name: "Avenir-Heavy", size: 50)
        self.view.addSubview(appName)
    
      
        let description = UILabel(frame: CGRect(x: 0, y: 0, width:  self.view.bounds.width - 10, height: 31))
        description.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/3)
        description.textAlignment = .center
        description.text = "Share your real life adventures "
        description.font = UIFont (name: "Avenir-Light", size: 20)
        self.view.addSubview(description)
        
        let description2 = UILabel(frame: CGRect(x: 0, y: 0, width:  self.view.bounds.width - 10, height: 31))
        description2.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/3 + 30)
        description2.textAlignment = .center
        description2.text = "with everyone across the world."
        description2.font = UIFont (name: "Avenir-Light", size: 20)
        self.view.addSubview(description2)
       
        //creating button
       
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center

        self.view.backgroundColor = UIColor.white
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        //adding it to view
        view.addSubview(loginButton)
        
        if (FBSDKAccessToken.current() != nil){
            
            getFBUserData()
            let viewController:UIViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as UIViewController
            // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
            self.view.backgroundColor = nil
            self.present(viewController, animated: false, completion: nil)
        
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
