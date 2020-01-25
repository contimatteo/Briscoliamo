//
//  Utilities.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 21/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation


class UtilityHelper {
    
    //
    // MARK: Array
    
    public static func arrayToData(_ array: [Any]) -> Data? {
      return try? JSONSerialization.data(withJSONObject: array, options: [])
    }
    
    public static func dataToArray(_ data: Data) -> [Any]? {
      return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [Any]
    }
    
    //
    // MARK: Object

    public static func objectToData(_ object: [String: Any]) -> Data? {
      return try? JSONSerialization.data(withJSONObject: object, options: [])
    }

    public static func dataToObject(_ data: Data) -> [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
    }
}


