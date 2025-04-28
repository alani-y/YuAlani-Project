// Project: YuAlani-Project
// EID: ay7892
// Course: CS329E

//  ViewController.swift
//  YuAlani-Project
//
//  Created by Alani Yu on 2/24/25.
//

import UIKit
let defaults = UserDefaults.standard

var floorPlan = [Room]()
var current: Room = floorPlan[0]

// stores the user active inventory
var inventory: [String] = []

// stores all objects in the game
var allObjects: [Item] = [
    Item(name: "supply crate", price: 0, hasPaid: false),
    Item(name: "fuel canister", price: 100, hasPaid: false),
    Item(name: "break room key", price: 0, hasPaid: false),
    Item(name: "suspicious blender", price: 99, hasPaid: false),
    Item(name: "toolbox", price: 50, hasPaid: false),
    Item(name: "hot meal", price: 20, hasPaid: false),
    Item(name: "blankets", price: 0, hasPaid: false),
    Item(name: "brand new rifle", price: 600, hasPaid: true),
    Item(name: "maintenance robot", price: 500, hasPaid: false),
    Item(name: "none", price: 0, hasPaid: true)
]

// the amount of credits the user has
var credits: Int = 500

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var commandField: UITextField!
    @IBOutlet weak var commandOutput: UILabel!
    @IBOutlet weak var creditAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commandField.delegate = self
        commandField.placeholder = "Command?"
        
        // Do any additional setup after loading the view.
        loadMap()
        displayAllRooms()
        
        creditAmount.text = "Credits: \(credits)"
        startText()
        
        if defaults.bool(forKey: "hasSaveData"){
            loadGame()
        }
    }
    
    // Called when the user clicks on the view outside of the UITextField
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // creates the building data structure
    func loadMap(){
        let hangar: [Any] = ["Hangar", "None", "None", "Spaceship", "Port marketplace", "None", "None", ["none"]];
        let marketplace: [Any] = ["Port marketplace", "Supply depot", "Hangar", "Noodles restaurant", "Mechanic shop", "None", "None", ["none"]];
        let supplyDepot: [Any] = ["Supply depot", "Break room", "Janitor's closet", "Port marketplace", "None", "None", "None", ["supply crate", "fuel canister"]];
        
        let closet: [Any] = ["Janitor's closet", "None", "None", "None", "Supply depot", "None", "None", ["break room key"]]
        
        let breakRoom: [Any] = ["Break room", "None", "None", "Supply depot", "None", "None", "None", ["suspicious blender"]]
        
        let mechanicShop: [Any] = ["Mechanic shop", "None", "Port marketplace", "None", "None", "None", "None", ["toolbox", "maintenance robot"]];
        
        let restaurant: [Any] = ["Noodles restaurant", "Port marketplace", "None", "None", "None", "Attic", "None", ["hot meal"]];
        
        let attic: [Any] = ["Attic", "None", "None", "None", "None", "None", "Noodles restaurant", ["blankets"]]
        
        let spaceship: [Any] = ["Spaceship", "Hangar", "None", "None", "Spaceship living room", "None", "None", ["none"]];
        
        let livingRoom: [Any] = ["Spaceship living room", "None", "Spaceship", "None", "None", "None", "None", ["brand new rifle"]];
        
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
    
    // loads pre-existing save data
    func loadGame(){
        // loads the saved inventory
        if let retrievedInventory = defaults.array(forKey: "inventory") as? [String]{
            inventory = retrievedInventory
        }
        else{
            print("There was an error loading the inventory")
        }
        // loads the user's credits amount
        credits = defaults.integer(forKey: "credits")
        // loads the saved current room
        if let retrievedCurrent = defaults.string(forKey: "currentRoom"){
            current = getRoom(roomName: retrievedCurrent)
        }
        else{
            print("There was an error loading the current room")
        }
        // loads the saved room contents
        if let retrievedRooms = defaults.dictionary(forKey: "rooms") as? [String : [String]]{
            
            // loads the state of all room's inventory
            for (room, roomContents) in retrievedRooms{
                getRoom(roomName: room).contents = roomContents
            }
        }
        else{
            print("There was an error loading the room contents")
        }
    }
    
    // saves the game data
    func saveGame() {
        // saves inventory
        defaults.set(inventory, forKey: "inventory")
        // save credits
        defaults.set(credits, forKey: "credits")
        // save current room name
        defaults.set(current.name, forKey: "currentRoom")
        // saves the contents for each room
        var roomContentsDict = [String: [String]]()
        for room in floorPlan {
            roomContentsDict[room.name] = room.contents
        }
        defaults.set(roomContentsDict, forKey: "rooms")
        defaults.set(true, forKey: "hasSaveData")
        print("saved game")
    }
    
    // creates a room object
    func createRoom(roomInfo: [Any]) -> Room{
        return Room(name: roomInfo[0] as! String, north: roomInfo[1] as! String, east: roomInfo[2] as! String, south: roomInfo[3] as! String, west: roomInfo[4] as! String, up: roomInfo[5] as! String, down: roomInfo[6] as! String, contents: roomInfo[7] as! [String])
    }
    
    // prints the current room
    func look(){
        commandOutput.text = "You are currently in the \(current.name)"
        commandOutput.text! += "\n" + getContentsOfRoom(roomName: current.name)
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
        
        // loops once for each item in a room
        if room.contents.count > 0  {
            for item in room.contents{
                
                if retrieveItem(itemName: item) != nil{
                    let selectedItemPrice = retrieveItem(itemName: item)!.price
                    
                    outputString += "\n\t\(item), price: "
                    if selectedItemPrice == 0{
                        outputString += "free"
                    }
                    else{
                        outputString += String(selectedItemPrice)
                    }
                }
                else{
                    outputString += "\n\t\(item)"
                }
            }
        }
        else {
            outputString += "\n\t none"
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
        let roomHasItem = current.contents.contains(item.lowercased())
        
        if inventory.contains(item) {
            commandOutput.text = "You can't pick up an item you already have."
        }
        // checks to make sure that the item is in the room
        else if roomHasItem && item.lowercased() != "none"{
            inventory.append(item)
            commandOutput.text = "You now have the \(item). "
            current.contents.remove(at: current.contents.firstIndex(of: item)!)
            
            let selectedItem = retrieveItem(itemName: item)
            if selectedItem != nil && selectedItem!.price == 0 && item != "blankets"{
                selectedItem!.hasPaid = true
            }
        }
        else{
            commandOutput.text = "That item is not in this room."
        }
    }
    
    func drop(item: String){
        if let index = inventory.firstIndex(of: item) {
            //
            current.contents.append(item)
            
            inventory.remove(at: index)
            commandOutput.text = "You have dropped the \(item)."
        }
        else{
            commandOutput.text = "You don’t have that item."
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
            commandOutput.text = "You can't move in that direction!"
            return current
        }
        else if newRoomName.lowercased() == "break room"{
            if !inventory.contains("break room key"){
                commandOutput.text = "You need the break room key."
                return current
            }
            else{
                commandOutput.text = "You are now in the \(newRoomName)."
                return getRoom(roomName: newRoomName)
            }
        }
        else if !checkPurchase(){ // checks for if the user bought all their inventory
            print(inventory)
            if inventory.contains("blankets"){
                commandOutput.text = "You hear the owner yell: \"Hey! Put the blankets back!\""
            }
            else{
                commandOutput.text = "Hey! You need to pay for that!"
            }
            return current
        }
        else{
            current = getRoom(roomName: newRoomName)
            
            commandOutput.text = "You are now in the \(newRoomName)."
            return current
        }
    }
    
    // buys an item that the user has in inventory
    func buy(itemName: String){
        guard let itemToBuy = retrieveItem(itemName: itemName)
        else {
            return
        }
        
        if !current.contents.contains(itemName) && !inventory.contains(itemName){
            commandOutput.text = "That item is not in the room."
            return
        }
        else if itemToBuy.hasPaid {
            commandOutput.text = "You can't buy an item you already own."
        }
        else if itemToBuy.name == "blankets"{
            commandOutput.text = "Those blankets belong to the owner."
        }
        else if credits - itemToBuy.price >= 0{
            credits -= itemToBuy.price
            itemToBuy.hasPaid = true
            creditAmount.text = "Credits: \(credits)"
            commandOutput.text = "You bought the \(itemName)."
            
            if current.contents.contains(itemName){
                current.contents.remove(at: current.contents.firstIndex(of: itemName)!)
            }
            if !inventory.contains(itemName){
                inventory.append(itemName)
            }
        }
        else{
            commandOutput.text = "You don't have enough credits!"
        }
    }
    
    // sells an item the user has in inventory
    func sell(itemName: String){
        
        guard let itemToBuy = retrieveItem(itemName: itemName)else {
            return
        }
        // checks if the object can be sold
        if itemToBuy.hasPaid && inventory.contains(itemName){
            
            credits += itemToBuy.price
            itemToBuy.hasPaid = false
            creditAmount.text = "Credits: \(credits)"
            commandOutput.text = "You sold the \(itemName)."
            inventory.remove(at: inventory.firstIndex(of: itemName)!)
            
            if itemName != "brand new rifle"{
                current.contents.append(itemName)
            }
        }
        else{
            commandOutput.text = "You can't sell an item you don't own or have in your inventory!"
        }
    }
    
    // checks if all items in the user's inventory have been paid for
    func checkPurchase() -> Bool{
        for item in inventory{
            print(retrieveItem(itemName: item)!.hasPaid)
            if !retrieveItem(itemName: item)!.hasPaid{
                return false
            }
        }
        return true
    }
    
    // gets the corresponding Item object when given an item's name
    func retrieveItem(itemName: String) -> Item?{
        var found: Item?
        
        // checks that an object with the itemName exists
        if allObjects.first(where: { $0.name.lowercased() == itemName.lowercased() }) == nil{
            commandOutput.text = "\(itemName) is not a valid item"
            found = nil
        }
        else{
            found = allObjects.first(where: { $0.name.lowercased() == itemName.lowercased() })
        }
        return found
    }
        
    func getInventory() -> String{
        var outputString = "Inventory: "
        for item in inventory{
            outputString += "\n\t" + item
        }
        
        return outputString
    }
    
    @IBAction func enterButton(_ sender: Any) {
        var command: String
        var itemArg = ""
        
        let commandFieldText = commandField.text
        
        var commandTextSplit = commandFieldText?.components(separatedBy: " ")
        
        // isolates the command from the rest of the commandField text
        command = commandTextSplit![0].lowercased()
        
        if commandTextSplit!.count > 0{
            // removes the command
            commandTextSplit?.remove(at: 0)
            
            // rejoins the remaining text to form the object name if using
            itemArg = (commandTextSplit?.joined(separator: " "))!
        }
        
        switch command{
        case "look":
            look()
        case "north":
            current = move(direction: "north")
            saveGame()
        case "east":
            current = move(direction: "east")
            saveGame()
        case "south":
            current = move(direction: "south")
            saveGame()
        case "west":
            current = move(direction: "west")
            saveGame()
        case "up":
            current = move(direction: "up")
            saveGame()
        case "down":
            current = move(direction: "down")
            saveGame()
        case "inventory":
            commandOutput.text = getInventory()
        case "exit":
            commandOutput.text = "exit"
        case "get":
            pickup(item: itemArg)
            saveGame()
        case "drop":
            drop(item: itemArg)
            saveGame()
        case "help":
            help()
        case "buy":
            buy(itemName: itemArg)
            saveGame()
        case "sell":
            sell(itemName: itemArg)
            saveGame()
        default:
            commandOutput.text = "That's not a valid command."
        }
    }
    
    // text that loads at the start of the game
    func startText(){
        commandOutput.text = """
        Welcome to this small corner of the galaxy!
        You currently need some supplies:
            1. A fuel canister
            2. A supply crate
            3. A new maintenance robot
        
        Then you can continue on your journey!
        
        You are currently in the \(current.name)
        """
    }
    
    // exits to the loading screen
    func exit(){
        
    }
    
    
    func help(){
        commandOutput.font = UIFont(name: "DIN Alternate", size: CGFloat(15.0))
        commandOutput.text = """
        look: display the name of the current room and its contents
        north: move north
        east: move east
        south: move south
        west: move west
        up: move up
        down: move down
        inventory: list what items you’re currently carrying
        buy ITEM: buy an item in the room
        sell ITEM: sell an item in your inventory
        get ITEM: pick up an item currently in the room
        drop ITEM: drop an item you’re currently carrying
        help: print this list
        exit: quit the game
        """
    }
}

