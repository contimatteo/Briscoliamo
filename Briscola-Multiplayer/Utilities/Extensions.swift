//
//  Extensions.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 24/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import MultipeerConnectivity


//
// MARK: MCSession (extension)

extension MCSession {
    
    // Gets the string for a peer connection state
    // - parameter state: Peer connection state, an MCSessionState enum value
    // - returns: String for peer connection state
    class func stringForPeerConnectionState(_ state: MCSessionState) -> String {
        switch state {
        case .connecting:
            return "Connecting";
            
        case .connected:
            return "Connected";
            
        case .notConnected:
            return "Not Connected";
            
        @unknown default:
            return "Uknown state";
        }
    }
    
}
