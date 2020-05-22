//
//  RoomServices.swift
//  Mime Game
//
//  Created by João Vitor Lopes Capi on 21/05/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit
import CloudKit

class RoomServices {
    
    let database = CKContainer.default().publicCloudDatabase
    
    static func userEntered(room: Room){
        
    }
    
    static func saveToCloud(room: Room){
        let newRoom = CKRecord(recordType: "Room")
        newRoom.setValue(room.name, forKey: "name")
        newRoom.setValue(room.appId, forKey: "appId")
        newRoom.setValue(room.numberOfPlayers, forKey: "numberOfPlayers")
        
        database.save(newRoom) { (record, error) in
            guard let record = record else { return }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            }
    }
    
    
}
