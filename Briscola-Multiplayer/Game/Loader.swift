//
//  Loader.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


class GameLoader {

    init() {}
    
    func loadCards() -> Array<CardModel> {
//        guard let _resourcePath = Bundle.main.resourcePath else{
//            return [];
//        }
        
        do{
//            if let url = NSURL(string: _resourcePath)?.appendingPathComponent("Assets.xcassets/Cards"){
//                let resourcesContent = try FileManager().contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//
//                for imageUrl in resourcesContent {
//                    let imageName = imageUrl.lastPathComponent
//                    print(imageName)
//                    //CHECK IMAGE NAME STRING
//                }
//            }
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: "\(path)/Assets.xcassets")
            
            print(path);
            print(items);

            for item in items {
//                if item.hasPrefix("nssl") {
//                    // this is a picture to load!
//                }
                print(item)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return [];
    }
}



