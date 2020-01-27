//
//  SocialsController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 27/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FBSDKShareKit

//
//  MARK: UITableViewCell

class DatabseResultViewCell: UITableViewCell {
    
    @IBOutlet weak var localPlayerLabel: UILabel!
    @IBOutlet weak var shareResultButton: UIButton!
    
}


class SocialController: UITableViewController {
    
    // MARK: Variables
    
    var facebookManager: FacebookManager?;
    var databaseHandler: DatabaseHandler?;
    var dbMatchesRecords: [DB_Match] = [];
    
    //
    // MARK: @IBOutlet
    
    @IBOutlet weak var FBCustomSharingButton: UIButton!
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Facebook
        facebookManager = FacebookManager(permissions: ["public_profile"]);
        
        // Database Handler
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        self.databaseHandler = DatabaseHandler(appDelegate.persistentContainer);
        
        //        let localP = DB_Player(index: 0, name: "matteo", type: .local);
        //        let remoteP = DB_Player(index: 1, name: "remoto", type: .remote);
        //        let localPResult = DB_Result(cards: "1-coppe;2-bastoni", handsWon: 2, points: 30);
        //        let remotePResult = DB_Result(cards: "2-coppe;3-bastoni", handsWon: 5, points: 60);
        //        let match = DB_Match(localPlayer: localP, localPlayerResult: localPResult, remotePlayer: remoteP, remotePlayerResult: remotePResult);
        //        databaseHandler!.saveMatch(match);
        
        // get all matches on database.
        dbMatchesRecords = databaseHandler!.getMatches();
    }
    
    //
    // MARK: @IBAction
    
    @objc private func performFBShare(_ sender: UIButton) {
        // use the tag of button as index
        let matchToShare = dbMatchesRecords[sender.tag];
        
        facebookManager?.shareTextOnFaceBook(controller: self);
        
        // response is in the { self } extension.
    }
    
}

//
// MARK: UITableViewController

extension SocialController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbMatchesRecords.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatabaseMatchRecord") as! DatabseResultViewCell;

        let currentMatch = dbMatchesRecords[indexPath.row];
        cell.localPlayerLabel.text = String(describing: currentMatch.localPlayer.name);
        
        // assign the index of the match to button tag
        cell.shareResultButton.tag = indexPath.row;
        // call the performFBShare(_:) method when tapped
        cell.shareResultButton.addTarget(self, action: #selector(performFBShare(_:)), for: .touchUpInside);
        
        return cell;
    }
    
}

//
// MARK: Facebook

extension SocialController: SharingDelegate {
    
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
