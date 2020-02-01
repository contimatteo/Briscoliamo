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
    
    @IBOutlet weak var localPlayerNameLabel: UILabel!
    @IBOutlet weak var remotePlayerNameLabel: UILabel!
    
    @IBOutlet weak var localPlayerPointsLabel: UILabel!
    @IBOutlet weak var remotePlayerPointsLabel: UILabel!
    
    @IBOutlet weak var FBShareActionButton: UIButton!
    
}


class SocialController: UITableViewController {
    
    // MARK: Variables
    
    var facebookManager: FacebookManager?;
    var databaseHandler: DatabaseHandler?;
    var dbMatchesRecords: [DB_Match] = [];
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Facebook
        facebookManager = FacebookManager(permissions: ["public_profile"]);
        
        // Database Handler
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        self.databaseHandler = DatabaseHandler(appDelegate.persistentContainer);
        
        // get all matches on database.
        dbMatchesRecords = databaseHandler!.getMatches();
    }
    
    //
    // MARK: @IBAction
    
    @objc private func performFBShare(_ sender: UIButton) {
        // use the tag of button as index
        let matchToShare: DB_Match = dbMatchesRecords[sender.tag];
        
        // show the facebook share dialog
        facebookManager?.shareTextOnFaceBook(controller: self, match: matchToShare);
        
        // {SharingDelegate} class handle the response
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
        cell.localPlayerNameLabel.text = String(describing: currentMatch.localPlayer.name);
        cell.remotePlayerNameLabel.text = String(describing: currentMatch.remotePlayer.name);
        cell.localPlayerPointsLabel.text = String(describing: currentMatch.localPlayerResult.points) + " punti";
        cell.remotePlayerPointsLabel.text = String(describing: currentMatch.remotePlayerResult.points) + " punti";
        
        // assign the index of the match to button tag
        cell.FBShareActionButton.tag = indexPath.row;
        // call the performFBShare(_:) method when tapped
        cell.FBShareActionButton.addTarget(self, action: #selector(performFBShare(_:)), for: .touchUpInside);
        
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
