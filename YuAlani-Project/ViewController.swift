//
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
    }
    
    // creates the building data structure
    func loadMap(){
        var room1: [String] = ["Living Room", "Dining Room", "None", "None", "None",
                               "Upper Hall", "None"];
        var room2: [String] = ["Kitchen", "None", "Dining Room", "None", "None", "None", "None"];
        //var room3: [String] = [""];
        //var room4: [String] = [""];
        //var room5: [String] = [""];
        //var room6: [String] = [""];
        //var room7: [String] = [""];
        
        createRoom(roomInfo: room1)
        createRoom(roomInfo: room2)
    }
    
    // creates a room object and appends it to the floor plan
    func createRoom(roomInfo: [String]){
        floorPlan.append(Room(name: roomInfo[0], north: roomInfo[1], east: roomInfo[2], south: roomInfo[3], west: roomInfo[4], up: roomInfo[5], down: roomInfo[6]))
    }
    
    // prints the current room
    func look(){
        print("You are in the \(current!.name)")
    }
    
    // gets the corresponding room object when given its name
    func getRoom(roomName: String) -> Room{
        var selectRoom: Room?;
        
        for room in floorPlan{
            if room.name == roomName{
                selectRoom = room;
            }
        }
        return selectRoom!
    }
    
    // displays all rooms
    func displayAllRooms(){
        for room in floorPlan{
            print("\(room.name)\n\t\(room.north)\n\t\(room.east)\n\t\(room.south)\n\t\(room.west)\n\t\(room.up)\n\t\(room.down)")
            print()
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
        
        if(newRoomName == "none"){ // checks if there is no room in the direction
            print("You can't move in that direction!")
            return current!
        }
        else{
            current = getRoom(roomName: newRoomName)
            
            print("You are now in \(newRoomName).")
            return current!
        }
    }
}

