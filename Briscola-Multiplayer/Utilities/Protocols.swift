//
//  Protocols.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 24/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation

//
// MARK: SessionControllerDelegate

protocol SessionControllerDelegate: class {
    
    //
    // MARK: Base
    
    // Multipeer Connectivity session changed state - connecting, connected and disconnected peers changed
    func sessionDidChangeState();
    
    //
    // MARK: Custom Receivers
    
    func didReceivedData(_ data: Data);
}
