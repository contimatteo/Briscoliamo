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
    
    /// An object that implements the `SessionControllerDelegate` protocol
    weak var delegate: SessionControllerDelegate?
    
    //
    // MARK: Private properties
    
    public let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    public lazy var session: MCSession = {
        let session = MCSession(peer: self.peerID)
        session.delegate = self
        return session
    }()
    
    public var serviceAdvertiser: MCNearbyServiceAdvertiser
    public var serviceBrowser: MCNearbyServiceBrowser
    
    /// Connected peers are stored in the MCSession
    /// Manually track connecting and disconnected peers
    public var connectingPeersDictionary = NSMutableDictionary()
    public var disconnectedPeersDictionary = NSMutableDictionary()
    
    //
    // MARK: Initializer
    
    override init() {
        let kMCSessionServiceType = "mcsessionp2p"
        
        // Create the service advertiser
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: kMCSessionServiceType)
        
        // Create the service browser
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: kMCSessionServiceType)
        
        super.init()
        
        // startServices()
    }
    
    //
    // MARK: Deinitialization
    
    deinit {
        stopServices()
        
        session.disconnect()
        
        // Nil out delegate
        session.delegate = nil
    }
    
    //
    // MARK: Services start / stop
    
    public func startServices() {
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    public func stopServices() {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceAdvertiser.delegate = nil
        
        serviceBrowser.stopBrowsingForPeers()
        serviceBrowser.delegate = nil
    }
    
    //
    // MARK: senders
    
    public func send(image: UIImage) -> Bool {
        //        if (session.connectedPeers.count < 1) { return; }
        //
        //        if let imageData = img.pngData() {
        //            do {
        //                try session.send(imageData, toPeers: session.connectedPeers, with: .reliable)
        //            } catch let error as NSError {
        //                print("/// send data generate an error: \(error.localizedDescription)")
        //            }
        //        }
        return false;
    }
    
    public func send(array: [Any]) -> Bool {
        if (session.connectedPeers.count < 1) { return false; }
        
        guard let data = UtilityHelper.arrayToData(array) else { return false; }
        
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable);
            return true;
        } catch let error as NSError {
            print("/// send data generate an error: \(error.localizedDescription)");
        }
        
        return false;
    }
}


//
// MARK: Protocol

protocol SessionControllerDelegate: class {
    // Multipeer Connectivity session changed state - connecting, connected and disconnected peers changed
    func sessionDidChangeState()
}


//
// MARK: Extension

extension MCSession {
    /// Gets the string for a peer connection state
    ///
    /// - parameter state: Peer connection state, an MCSessionState enum value
    /// - returns: String for peer connection state
    ///
    class func stringForPeerConnectionState(_ state: MCSessionState) -> String {
        switch state {
        case .connecting:
            return "Connecting"
            
        case .connected:
            return "Connected"
            
        case .notConnected:
            return "Not Connected"
            
        @unknown default:
            return "Uknown state"
        }
        
    }
}
