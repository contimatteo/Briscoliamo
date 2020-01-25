//
//  FacebookManager.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 17/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKShareKit


class FacebookManager {
    
    //
    // MARK:
    
    private var permissions: [String];
    private var loginManager: LoginManager;
    private var currentUserProfile : [String: Any]?;
    
    //
    // MARK:
    
    init(permissions: [String]) {
        self.permissions = permissions;
        self.loginManager = LoginManager();
        self.currentUserProfile = nil;
        
        /// TODO: auto login user if token is already setted.
        fetchUserProfile { userFetched in
            if userFetched != nil {
                self.currentUserProfile = userFetched!;
            }
        };
    }
    
    //
    // MARK
    
    public func login(from: UIViewController, didCompleteHandler: LoginManagerLoginResultBlock!) {
        // self.loginManager.logIn(permissions: self.permissions, from: from, handler: handler);
        if (AccessToken.current != nil) { return; }
        
        self.loginManager.logIn(permissions: self.permissions, from: from) { (result, error) in
            self.loginDidComplete(result, error: error, didComplete: didCompleteHandler);
        }
    }
    
    public func logout() {
        self.loginManager.logOut()
        self.removeCurrentUserData()
    }
    
    func fetchUserProfile(callback: @escaping (_ user: [String: Any]?) -> ()) {
        if AccessToken.current == nil { return; }
        
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: [:])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if error != nil {
                // TODO: handle error
                // ....
                
                return callback(nil);
            }
            
            // Handle Profile Photo URL String
            guard let user = result as? [String: Any] else { return }
            self.currentUserProfile = user;
            
            callback(user);
        });
    }
    
    public func getUserProfileUrl() -> String? {
        guard let userProfile = self.currentUserProfile else { return nil; }
        let userId = userProfile["id"] as! String;
        
        return "https://graph.facebook.com/\(userId)/picture?type=large";
    }
    
    public func shareTextOnFaceBook(controller: SocialsController) {
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: "https://developers.facebook.com")! //your link
        shareContent.quote = "Text to be shared"
        ShareDialog(fromViewController: controller, content: shareContent, delegate: controller).show()
    }
    
    //
    // MARK
    
    private func loginDidComplete(_ result: LoginManagerLoginResult?, error: Error?, didComplete: LoginManagerLoginResultBlock!) {
        // error
        if error != nil {
            self.removeCurrentUserData()
        }
        
        // login canceled
        if error == nil && result != nil {
            if result!.isCancelled {
                self.removeCurrentUserData()
            }
        }
        
        // call parent callback
        didComplete(result, error);
    }
    
    private func removeCurrentUserData() {
        // TODO: check this...
        // AccessToken.setCurrentAccessToken(nil)
        AccessToken.current = nil
        
        // empty current user var
        currentUserProfile = nil;
        
        // assing to FB method the priority.
        self.loginManager.logOut()
    }
    
}
