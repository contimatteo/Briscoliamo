//
//  SocialsController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 06/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit


class SocialsController: UIViewController {
    
    
    @IBOutlet weak var FBCustomLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func performFBLogin(_ sender: Any) {
        let loginManager = LoginManager();
        let permissions: Array<String> = ["public_profile", "user_friends"];
        let from = self;
        
        loginManager.logIn(permissions: permissions, from: from) { (result, error) in
            self.loginManagerDidComplete(result, errors: error);
        }
    }
    
    @IBAction private func performFBLogout() {
        let loginManager = LoginManager()
        loginManager.logOut()
        print("//// FB logout done!");
    }
    
    // func loginManagerDidComplete(_ result: LoginManagerLoginResultBlock) {
    func loginManagerDidComplete(_ result: LoginManagerLoginResult?, errors: Error?) {
        if errors != nil {
            // Process error
            print("//// FB Login failed with error \(errors!)");
            
            return;
        }
        
        guard let loginResult = result else {
            print("//// FB Login: something went wrong.");
            return;
        }
        
        // LOGIN EXECUTED
            
        print("//// FB login result \(result!)");
        
        // IS CANCELED ?
        if (loginResult.isCancelled) {
            print("//// FB User cancelled login.");
            return
        }
        
        // LOGIN COMPLETED SUCCESSFULLY
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if loginResult.grantedPermissions.contains("email")
        {
            // Do work
        }
    }
    
    
    
    //    func fbLoginInitiate() {
    //        let loginManager = LoginManager()
    //        loginManager.logInWithReadPermissions(["public_profile", "email"], handler: {(result:LoginManagerLoginResult!, error:NSError!) -> Void in
    //            if (error != nil) {
    //                // Process error
    //                self.removeFbData()
    //            } else if result.isCancelled {
    //                // User Cancellation
    //                self.removeFbData()
    //            } else {
    //                //Success
    //                if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile") {
    //                    //Do work
    //                    self.fetchFacebookProfile()
    //                } else {
    //                    //Handle error
    //                }
    //            }
    //        })
    //    }
    //
    //    func removeFbData() {
    //        //Remove FB Data
    //        let fbManager = LoginManager()
    //        fbManager.logOut()
    //        // AccessToken.setCurrentAccessToken(nil)
    //        AccessToken.current = nil
    //    }
    //
    //    func fetchFacebookProfile()
    //    {
    //        if AccessToken.current != nil {
    //            let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: [:])
    //            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
    //
    //                if ((error) != nil) {
    //                    //Handle error
    //                } else {
    //                    //Handle Profile Photo URL String
    //                    guard let user = result as? [String: Any] else { return }
    //
    //                    let userId =  user["id"] as! String
    //                    let profilePictureUrl = "https://graph.facebook.com/\(userId)/picture?type=large"
    //
    //                    let accessToken = AccessToken.current!.tokenString
    //                    let fbUser = ["accessToken": accessToken, "user": result]
    //                }
    //            })
    //        }
    //    }
    
}
