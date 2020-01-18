//
//  NetworkManager.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 18/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import MultipeerConnectivity




class NetworkManager {
    //
    // MARK:
    
    private var peerID: MCPeerID!
    private var mcSession: MCSession!
    private var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    //
    // MARK:
    
    init (delegate: MCSessionDelegate) {
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        self.mcSession.delegate = delegate
    }
    
    //
    // MARK:
}
