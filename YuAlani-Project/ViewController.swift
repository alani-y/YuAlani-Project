// Project: YuAlani-Project
// EID: ay7892
// Course: CS329E

//  ViewController.swift
//  YuAlani-Project
//
//  Created by Alani Yu on 2/24/25.
//

import UIKit

var floorPlan = [Room]()
var current: Room = floorPlan[0]

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadMap()
        displayAllRooms()
        
        current = move(direction:"south") // can’t move this direction
        current = move(direction:"west") // can’t move this direction
        current = move(direction:"north") // Dining Room
        current = move(direction:"south") // Living Room
        current = move(direction:"up") // Upper Hall
        look() // Upper Hall
        current = move(direction:"east") // Small Bedroom
        current = move(direction:"east") // can’t move this direction
        current = move(direction:"west") // Upper Hall
        current = move(direction:"south") // Master Bedroom
        current = move(direction:"north") // Upper Hall
        current = move(direction:"north") // Bathroom
        current = move(direction:"south") // Upper Hall
        look() // Upper Hall
        current = move(direction:"west") // can’t move this direction
        look() // still in the Upper Hall
        current = move(direction:"down") // Living Room
        current = move(direction:"north") // Dining Room
        current = move(direction:"west") // Kitchen
        current = move(direction:"north") // can’t move this direction
    }
    
    // creates the building data structure
    func loadMap(){
        let hangar: [String] = ["Hangar", "None", "None", "Spaceship", "Port marketplace", "None", "None"];
        let marketplace: [String] = ["Port marketplace", "Supply depot", "Hangar", "Noodles restaurant", "Mechanic shop", "None", "None"];
        let supplyDepot: [String] = ["Supply depot", "Break room", "Janitor's closet", "Port marketplace", "None", "None", "None"];
        
        let closet = ["Janitor's closet", "None", "None", "None", "Supply depot", "None", "None"]
        
        let breakRoom = ["Break room", "None", "None", "Supply depot", "None", "None", "None"]
        
        let mechanicShop: [String] = ["Mechanic shop", "None", "Port marketplace", "None", "None", "None", "None"];
        
        let restaurant: [String] = ["Noodles restaurant", "Port marketplace", "None", "None", "None", "Attic", "None"];
        
        let attic: [String] = ["Attic", "None", "None", "None", "None", "None", "Noodles restaurant"]
        
        let spaceship: [String] = ["Spaceship", "Hangar", "None", "None", "Spaceship living room", "None", "None"];
        
        let livingRoom: [String] = ["Spaceship living room", "None", "Spaceship", "None", "None", "None", "None"];
        
        floorPlan.append(createRoom(roomInfo: hangar))
        floorPlan.append(createRoom(roomInfo: marketplace))
        floorPlan.append(createRoom(roomInfo: supplyDepot))
        floorPlan.append(createRoom(roomInfo: mechanicShop))
        floorPlan.append(createRoom(roomInfo: restaurant))
        floorPlan.append(createRoom(roomInfo: spaceship))
        floorPlan.append(createRoom(roomInfo: livingRoom))
    }
    
    // creates a room object
    func createRoom(roomInfo: [String]) -> Room{
        return Room(name: roomInfo[0], north: roomInfo[1], east: roomInfo[2], south: roomInfo[3], west: roomInfo[4], up: roomInfo[5], down: roomInfo[6])
    }
    
    // prints the current room
    func look(){
        print("You are currently in the \(current.name)")
    }
    
    // gets the corresponding room object when given its name
    func getRoom(roomName: String) -> Room{
        var selectRoom: Room?;
        
        for room in floorPlan{
            //print(room.name, roomName)
            if room.name.lowercased() == roomName.lowercased(){
                selectRoom = room;
            }
        }
        return selectRoom!
    }
    
    // displays all rooms
    func displayAllRooms(){
        for room in floorPlan{
            room.displayRoom()
        }
    }
    
    func move(direction: String) -> Room{
        var newRoomName: String
        
        switch direction.lowercased(){
        case "north":
            newRoomName = current.north
        case "east":
            newRoomName = current.east
        case "south":
            newRoomName = current.south
        case "west":
            newRoomName = current.west
        case "up":
            newRoomName = current.up
        default:
            newRoomName = current.down
        }
        
        if(newRoomName.lowercased() == "none"){ // checks if there is no room in the direction
            print("You can't move in that direction!")
            return current
        }
        else{
            current = getRoom(roomName: newRoomName)
            
            print("You are now in the \(newRoomName).")
            return current
        }
    }
}

