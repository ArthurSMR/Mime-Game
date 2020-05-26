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
    
    
    static func userEntered(room: Room){
        let database = DatabaseContainer.shared.publicCloudDatabase
        room.numberOfPlayers += 1
        
        var predicate = NSPredicate(format: "name == %@", room.name)
        var query = CKQuery(recordType: "Room", predicate: predicate)
        
        database.perform(query, inZoneWith: .default) { (results, error) -> Void in
            if error != nil {
                print("error performing query to find \(room.name) when entering...")
            }
            if let roomsFound = results{
                if roomsFound.count != 0 {
                    guard let roomFound = roomsFound.first else { return }
                    roomFound["numberOfPlayers"] = room.numberOfPlayers
                    
                    database.save(roomFound, completionHandler: { record, error in
                        
                        if error == nil {
                            print("user enter update on \(room.name). It now has \(room.numberOfPlayers) players")
                        }
                        
                    })
                }
            }
        }
    }
    
    
    static func userLeft(room: Room){
        let database = DatabaseContainer.shared.publicCloudDatabase
        room.numberOfPlayers -= 1
        
        var predicate = NSPredicate(format: "name == %@", room.name)
        var query = CKQuery(recordType: "Room", predicate: predicate)
        
        database.perform(query, inZoneWith: .default) { (results, error) -> Void in
            if error != nil {
                print("error performing query to find \(room.name) when entering...")
            }
            if let roomsFound = results{
                if roomsFound.count != 0 {
                    guard let roomFound = roomsFound.first else { return }
                    roomFound["numberOfPlayers"] = room.numberOfPlayers
                    
                    database.save(roomFound, completionHandler: { record, error in
                        
                        if error == nil {
                            print("user left update on \(room.name). It now has \(room.numberOfPlayers) players")
                        }
                        
                    })
                }
            }
        }
        
    }
    
    static func saveToCloud(room: Room){
        let database = DatabaseContainer.shared.publicCloudDatabase
        
        let newRoom = CKRecord(recordType: "Room")
        newRoom.setValue(room.name, forKey: "name")
        newRoom.setValue(room.appId, forKey: "appId")
        newRoom.setValue(room.numberOfPlayers, forKey: "numberOfPlayers")
        
        database.save(newRoom) { (record, error) in
            guard let _ = record else { return }
            
            if let error = error {
                print(error.localizedDescription)
            }
            }
    }
    
    
    static func loadRooms(completionHandler:@escaping ([Room]?,Error?) -> Void)  {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "name", ascending: true)
        let query = CKQuery(recordType: "Room", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = nil
        //because now we have 6 rooms
        operation.resultsLimit = 6

        var newRooms = [Room]()

        operation.recordFetchedBlock = { record in
            guard let appId = record["appId"] as? String else { print("appId is nil or not String"); return }
            guard let name = record["name"] as? String else { print("name is nil or not String"); return }
//            guard let themeName = record["themeName"] as? String else { print("themeName is nil or not String"); return }
            guard let numberOfPlayers = record["numberOfPlayers"] as? Int else { print("numberOfPlayers is nil or not Int"); return }
            
            let room = Room(appId: appId, name: name, numberOfPlayers: numberOfPlayers)
            room.recordID = record.recordID
//            room.themeName = themeName
            
            newRooms.append(room)
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            if error == nil {
                completionHandler(newRooms, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
        DatabaseContainer.shared.publicCloudDatabase.add(operation)
    }
    
    
}
