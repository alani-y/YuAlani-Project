// Project: YuAlani-Project
// EID: ay7892
// Course: CS329E

//  ViewController.swift
//  YuAlani-Project
//
//  Created by Alani Yu on 2/24/25.
//

import UIKit

class ViewController: UIViewController {
    
    var floorPlan = [Room]();
    var current: Room?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadMap()
        displayAllRooms()
        current = floorPlan[0]
        
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
        let room1: [String] = ["Living Room", "Dining Room", "None", "None", "None",
                               "Upper Hall", "None"];
        let room2: [String] = ["Dining Room", "None", "None", "Living Room", "Kitchen", "None", "None"];
        let room3: [String] = ["Kitchen", "None", "Dining Room", "None", "None", "None", "None"];
        let room4: [String] = ["Upper Hall", "Bathroom", "Small Bedroom", "Master Bedroom", "None", "None", "Living Room"];
        let room5: [String] = ["Bathroom", "None", "None", "Upper Hall", "None", "None", "None"];
        let room6: [String] = ["Small Bedroom", "None", "None", "None", "Upper Hall", "None", "None"];
        let room7: [String] = ["Master Bedroom", "Upper Hall", "None", "None", "None", "None", "None"];
        
        floorPlan.append(createRoom(roomInfo: room1))
        floorPlan.append(createRoom(roomInfo: room2))
        floorPlan.append(createRoom(roomInfo: room3))
        floorPlan.append(createRoom(roomInfo: room4))
        floorPlan.append(createRoom(roomInfo: room5))
        floorPlan.append(createRoom(roomInfo: room6))
        floorPlan.append(createRoom(roomInfo: room7))
    }
    
    // creates a room object
    func createRoom(roomInfo: [String]) -> Room{
        return Room(name: roomInfo[0], north: roomInfo[1], east: roomInfo[2], south: roomInfo[3], west: roomInfo[4], up: roomInfo[5], down: roomInfo[6])
    }
    
    // prints the current room
    func look(){
        print("You are in the \(current!.name)")
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
            newRoomName = current!.north
        case "east":
            newRoomName = current!.east
        case "south":
            newRoomName = current!.south
        case "west":
            newRoomName = current!.west
        case "up":
            newRoomName = current!.up
        default:
            newRoomName = current!.down
        }
        
        if(newRoomName.lowercased() == "none"){ // checks if there is no room in the direction
            print("You can't move in that direction!")
            return current!
        }
        else{
            current = getRoom(roomName: newRoomName)
            
            print("You are now in the \(newRoomName).")
            return current!
        }
    }
}

