//
//  SessionManager.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 18/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class SessionManager: NSObject {
    
    //
    // MARK: Properties
    
    var connectedPeers: [MCPeerID] {
        get { return session.connectedPeers }
    }
    
    var connectingPeers: [MCPeerID] {
        get { return connectingPeersDictionary.allValues as! [MCPeerID] }
    }
    
    var disconnectedPeers: [MCPeerID] {
        get { return disconnectedPeersDictionary.allValues as! [MCPeerID] }
    }
    
    var displayName: String {
        get { return session.myPeerID.displayName }
    }
    
    // An object that implements the `SessionControllerDelegate` protocol
    weak var delegate: SessionControllerDelegate?
    
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.peerID)
        session.delegate = self
        return session
    }()
    
    // MCNearbyServiceAdvertiser: publishes an advertisement for a specific service that
    // your app provides through the Multipeer Connectivity framework and notifies its
    // delegate about invitations from nearby peers.
    var serviceAdvertiser: MCNearbyServiceAdvertiser;
    
    // Connected peers are stored in the MCSession
    // Manually track connecting and disconnected peers
    var connectingPeersDictionary = NSMutableDictionary()
    var disconnectedPeersDictionary = NSMutableDictionary()
    
    var controller: UIViewController;
    var myAdvertiserAssistant: MCAdvertiserAssistant!;
    var mcBrowser: MCBrowserViewController?;
    
    //
    // MARK: Initializer
    
    init(_ controller: UIViewController) {
        let kMCSessionServiceType = "mcsessionp2p";
        self.controller = controller;
        
        // Create the service advertiser
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: kMCSessionServiceType);
        
        super.init();
        
        myAdvertiserAssistant = MCAdvertiserAssistant(serviceType: kMCSessionServiceType, discoveryInfo: nil, session: session);
        mcBrowser = MCBrowserViewController(serviceType: kMCSessionServiceType, session: session);
    }
    
    //
    // MARK: Deinitialization
    
    deinit {
        // stopServices()
        
        // session.disconnect()
        
        // Nil out delegate
        // session.delegate = nil
    }
    
    //
    // MARK: Services start / stop
    
    func startServices() {
        serviceAdvertiser.delegate = self;
        serviceAdvertiser.startAdvertisingPeer();
        
        myAdvertiserAssistant.start();
        
        mcBrowser!.delegate = controller as? MCBrowserViewControllerDelegate;
        
        controller.present(mcBrowser!, animated: true)
    }
    
    func stopServices() {
        myAdvertiserAssistant.stop()
        
        mcBrowser = nil;
        
        serviceAdvertiser.stopAdvertisingPeer()
        serviceAdvertiser.delegate = nil
    }
    
    //
    // MARK: senders
    
    private func send(_ data: Data) -> Bool {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable);
            return true;
        } catch let error as NSError {
            print("[INFO] send data generate an error: \(error.localizedDescription)");
        }
        
        return false;
    }
    
    func sendData(data: [Any]) -> Bool {
        if (session.connectedPeers.count < 1) { return false; }
        guard let data = UtilityHelper.arrayToData(data) else { return false; }
        
        return send(data);
    }
    
    func sendData(data: Data) -> Bool {
        if (session.connectedPeers.count < 1) { return false; }
        
        return send(data);
    }
}



//
// MARK: MCSessionDelegate
// MCSessionDelegate: this protocol defines methods that a delegate of the MCSession class
// can implement to handle session-related events.

extension SessionManager: MCSessionDelegate {
    // Remote peer changed state.
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
    
    // Received data from remote peer.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if (_SESSION_DEBUG_) { NSLog("\(#function) from [\(peerID.displayName)]"); }
        
        delegate?.didReceivedDataFromPeer(data);
    }
    
    // UNUSED: Start receiving a resource from remote peer.
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        if (_SESSION_DEBUG_) { 
            NSLog("\(#function) \(resourceName) from [\(peerID.displayName)] with progress [\(progress)]");
        }
    }
    
    // UNUSED: Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // If error is not nil something went wrong
        if (error != nil) {
            if (_SESSION_DEBUG_) { NSLog("\(#function) Error \(String(describing: error)) from [\(peerID.displayName)]"); }
        } else {
            if (_SESSION_DEBUG_) { NSLog("\(#function) \(resourceName) from [\(peerID.displayName)]"); }
        }
    }
    
    // UNUSED: Received a byte stream from remote peer.
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        if (_SESSION_DEBUG_) { NSLog("\(#function) \(streamName) from [\(peerID.displayName)]"); }
    }
}


//
// MARK: MCNearbyServiceAdvertiserDelegate
// MCNearbyServiceAdvertiserDelegate: this protocol describes the methods that the delegate object
// for an MCNearbyServiceAdvertiser instance can implement for handling events from the
// MCNearbyServiceAdvertiser class.

extension SessionManager: MCNearbyServiceAdvertiserDelegate {
    // Incoming invitation request.  Call the invitationHandler block with YES
    // and a valid session to connect the inviting peer to the session.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if (_SESSION_DEBUG_) { NSLog("\(#function) Accepting invitation from [\(peerID.displayName)]"); }
        
        invitationHandler(true, session);
    }
    
    // Advertising did not start due to an error.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        if (_SESSION_DEBUG_) { NSLog("\(#function) \(error)"); }
    }
}
