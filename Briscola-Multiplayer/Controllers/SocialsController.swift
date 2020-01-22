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
import FBSDKShareKit


class SocialsController: UIViewController {
    
    //
    // MARK: Variables
    
    var facebookManager: FacebookManager?;
    
    //
    // MARK: @IBOutlet
    
    @IBOutlet weak var FBCustomSharingButton: UIButton!
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookManager = FacebookManager(permissions: ["public_profile"]);
    }
    
    //
    // MARK: @IBAction
    
    @IBAction private func performFBShare(_ sender: Any) {
        facebookManager?.shareTextOnFaceBook(controller: self);
        
        // response is in the { self } extension.
    }
    
    //
    // MARK: Callbacks
    
}

//
// MARK: Facebook

extension SocialsController: SharingDelegate {
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent.pageID != nil {
            print("Share: Success")
        }
    }

    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
    }
    
}
