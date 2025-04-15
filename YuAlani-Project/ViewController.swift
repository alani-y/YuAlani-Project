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

// stores the user active inventory
var inventory: [String] = []

// stores all objects in the game
var allObjects: [Item] = []

// the amount of credits the user has
var credits: Int = 500

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
        let hangar: [Any] = ["Hangar", "None", "None", "Spaceship", "Port marketplace", "None", "None", ["None"]];
        let marketplace: [Any] = ["Port marketplace", "Supply depot", "Hangar", "Noodles restaurant", "Mechanic shop", "None", "None", ["None"]];
        let supplyDepot: [Any] = ["Supply depot", "Break room", "Janitor's closet", "Port marketplace", "None", "None", "None", ["Supply crate", "Fuel canister"]];
        
        let closet: [Any] = ["Janitor's closet", "None", "None", "None", "Supply depot", "None", "None", ["Break room key"]]
        
        let breakRoom: [Any] = ["Break room", "None", "None", "Supply depot", "None", "None", "None", ["Suspicious blender"]]
        
        let mechanicShop: [Any] = ["Mechanic shop", "None", "Port marketplace", "None", "None", "None", "None", ["Toolbox", "Maitenance robot"]];
        
        let restaurant: [Any] = ["Noodles restaurant", "Port marketplace", "None", "None", "None", "Attic", "None", ["Hot meal"]];
        
        let attic: [Any] = ["Attic", "None", "None", "None", "None", "None", "Noodles restaurant", ["Blankets"]]
        
        let spaceship: [Any] = ["Spaceship", "Hangar", "None", "None", "Spaceship living room", "None", "None", ["None"]];
        
        let livingRoom: [Any] = ["Spaceship living room", "None", "Spaceship", "None", "None", "None", "None", ["Brand new rifle"]];
        
        floorPlan.append(createRoom(roomInfo: hangar))
        floorPlan.append(createRoom(roomInfo: marketplace))
        floorPlan.append(createRoom(roomInfo: supplyDepot))
        floorPlan.append(createRoom(roomInfo: closet))
        floorPlan.append(createRoom(roomInfo: breakRoom))
        floorPlan.append(createRoom(roomInfo: mechanicShop))
        floorPlan.append(createRoom(roomInfo: restaurant))
        floorPlan.append(createRoom(roomInfo: attic))
        floorPlan.append(createRoom(roomInfo: spaceship))
        floorPlan.append(createRoom(roomInfo: livingRoom))
    }
    
    // creates a room object
    func createRoom(roomInfo: [Any]) -> Room{
        return Room(name: roomInfo[0] as! String, north: roomInfo[1] as! String, east: roomInfo[2] as! String, south: roomInfo[3] as! String, west: roomInfo[4] as! String, up: roomInfo[5] as! String, down: roomInfo[6] as! String, contents: roomInfo[7] as! [String])
    }
    
    // prints the current room
    func look(){
        print("You are currently in the \(current.name)")
        print(getContentsOfRoom(roomName: current.name))
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
    
    // shows the items in the room
    func getContentsOfRoom(roomName: String) -> String{
        let room = getRoom(roomName: roomName)
        
        var outputString = "Contents of the room: "
        if room.contents.count > 0  {
            for item in room.contents{
                outputString += "\n\t\(item)"
            }
        }
        else {
            outputString += "\n\t Nothing"
        }
        
        return outputString
    }
    
    // displays all rooms
    func displayAllRooms(){
        for room in floorPlan{
            room.displayRoom()
        }
    }
    
    func pickup(item: String){
        if current.contents.contains(item){
            inventory.append(item)
            print("You now have the \(item). ")
        }
        else{
            print("That item is not in this room.")
        }
    }
    
    func drop(item: String){
        if let index = inventory.firstIndex(of: item) {
            inventory.remove(at: index)
            print("You have dropped the \(item).")
        }
        else{
            print("You don’t have that item.")
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
        else if !checkPurchase(){ // checks for if the user bought all their inventory
            print("Hey! You need to pay for that!")
            return current
        }
        else{
            current = getRoom(roomName: newRoomName)
            
            print("You are now in the \(newRoomName).")
            return current
        }
    }
    
    // buys an item that the user has in inventory
    func buy(itemName: String){
        var willBuy = true
        print("Are you sure you want to buy the \(itemName)")
        
        // reduces the user's credit amount by the item's price
        if willBuy && inventory.contains(itemName) {
            credits -= retrieveItem(itemName: itemName).price
        }
        else{
            print("There was an error buying the item.")
        }
    }
    
    // sells an item the user has in inventory
    func sell(itemName: String){
        var willSell = true
        print("Are you sure you want to sell the \(itemName)")
        
        if willSell && inventory.contains(itemName) {
            credits += retrieveItem(itemName: itemName).price
        }
        else{
            print("There was an error selling the item.")
        }
    }
    
    // checks if all purchasable items in the user's inventory have been paid for
    func checkPurchase() -> Bool{
        for item in inventory{
            if !retrieveItem(itemName: item).hasPaid{
                return false
            }
        }
        return true
    }
    
    // gets the corresponding Item object when given an item's name
    func retrieveItem(itemName: String) -> Item{
        // checks that an object with the itemName exists
        guard let found = allObjects.first(where: { $0.name == itemName }) else {
        fatalError("Item with name \(itemName) not found")
        }
        return found
    }
}

