//
//  MultiPlayerControllerDelegate.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 18/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import MultipeerConnectivity


//
// MARK: MCSessionDelegate

extension SessionManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let displayName = peerID.displayName
        
        NSLog("\(#function) \(displayName) \(MCSession.stringForPeerConnectionState(state))")
        
        switch state {
        case .connecting:
            connectingPeersDictionary.setObject(peerID, forKey: displayName as NSCopying)
            disconnectedPeersDictionary.removeObject(forKey: displayName)
            
        case .connected:
            connectingPeersDictionary.removeObject(forKey: displayName)
            disconnectedPeersDictionary.removeObject(forKey: displayName)
            
        case .notConnected:
            connectingPeersDictionary.removeObject(forKey: displayName)
            disconnectedPeersDictionary.setObject(peerID, forKey: displayName as NSCopying)
            
        @unknown default:
            fatalError("Uknown connection status.");
        }
        
        delegate?.sessionDidChangeState()
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("\(#function) from [\(peerID.displayName)]");
        
        let image: UIImage? = UIImage(data: data);
        let array: [Any]? = UtilityHelper.dataToArray(data);
        let object: [String: Any]? = UtilityHelper.dataToObject(data);
        
        if image != nil {
            DispatchQueue.main.async { print("[INFO] image receveid: \(image!)"); }
        }
        
        if array != nil {
            DispatchQueue.main.async { print("[INFO] array receveid: \(array!)"); }
        }
        
        if object != nil {
            DispatchQueue.main.async { print("[INFO] object receveid: \(object!)"); }
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("\(#function) \(resourceName) from [\(peerID.displayName)] with progress [\(progress)]")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // If error is not nil something went wrong
        if (error != nil) {
            NSLog("\(#function) Error \(String(describing: error)) from [\(peerID.displayName)]")
        } else {
            NSLog("\(#function) \(resourceName) from [\(peerID.displayName)]")
        }
    }
    
    // Streaming API not utilized in this sample code
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("\(#function) \(streamName) from [\(peerID.displayName)]")
    }
}


//
// MARK: MCNearbyServiceBrowserDelegate

extension SessionManager: MCNearbyServiceBrowserDelegate {
    
    // Found a nearby advertising peer
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let remotePeerName = peerID.displayName
        
        let myPeerID = session.myPeerID
        
        let shouldInvite = (myPeerID.displayName.compare(remotePeerName) == .orderedDescending)
        
        if shouldInvite {
            NSLog("\(#function) Inviting [\(remotePeerName)]")
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30.0)
        } else {
            NSLog("\(#function) Not inviting [\(remotePeerName)]")
        }
        
        delegate?.sessionDidChangeState()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("\(#function) [\(peerID.displayName)]")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("\(#function) \(error)")
    }
}


//
// MARK: MCNearbyServiceAdvertiserDelegate

extension SessionManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("\(#function) Accepting invitation from [\(peerID.displayName)]")
        
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("\(#function) \(error)")
    }
}
