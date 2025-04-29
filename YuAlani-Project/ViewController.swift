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
    Item(name: "supply crate", price: 70, hasPaid: false),
    Item(name: "fuel canister", price: 100, hasPaid: false),
    Item(name: "break room key", price: 0, hasPaid: false),
    Item(name: "suspicious blender", price: 99, hasPaid: false),
    Item(name: "toolbox", price: 50, hasPaid: false),
    Item(name: "hot meal", price: 20, hasPaid: false),
    Item(name: "blankets", price: 0, hasPaid: false),
    Item(name: "brand new rifle", price: 600, hasPaid: true),
    Item(name: "maintenance robot", price: 500, hasPaid: false)
]

// the amount of credits the user has
var credits: Int = 500

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commandField: UITextField!
    @IBOutlet weak var outputArea: UILabel!
    @IBOutlet weak var creditAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commandField.delegate = self
        
        // Do any additional setup after loading the view.
        loadMap()
        displayAllRooms()
        
        if defaults.bool(forKey: "hasSaveData"){
            loadGame()
            look()
        }
        else{
            creditAmount.text = "Credits: \(credits)"
            imageView.image = UIImage(named: "\(current.name.lowercased())")
            startText()
        }
    }
    
    // Called when the user clicks on the view outside of the UITextField
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // creates the building data structure
    func loadMap(){
        let hangar: [Any] = ["hangar", "None", "None", "spaceship", "port marketplace", "None", "None", ["none"]];
        let marketplace: [Any] = ["port marketplace", "Supply depot", "Hangar", "noodles restaurant", "Mechanic shop", "None", "None", ["none"]];
        let supplyDepot: [Any] = ["supply depot", "break room", "janitor's closet", "port marketplace", "None", "None", "None", ["supply crate", "fuel canister"]];
        
        let closet: [Any] = ["janitor's closet", "None", "None", "None", "Supply depot", "None", "None", ["break room key"]]
        
        let breakRoom: [Any] = ["break room", "None", "None", "supply depot", "None", "None", "None", ["suspicious blender"]]
        
        let mechanicShop: [Any] = ["mechanic shop", "None", "port marketplace", "None", "None", "None", "None", ["toolbox", "maintenance robot"]];
        
        let restaurant: [Any] = ["noodles restaurant", "port marketplace", "None", "None", "None", "Attic", "None", ["hot meal"]];
        
        let attic: [Any] = ["attic", "None", "None", "None", "None", "None", "noodles restaurant", ["blankets"]]
        
        let spaceship: [Any] = ["spaceship", "Hangar", "None", "None", "spaceship living room", "None", "None", ["none"]];
        
        let livingRoom: [Any] = ["spaceship living room", "None", "spaceship", "None", "None", "None", "None", ["brand new rifle"]];
        
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
            for item in inventory{
                let itemObject = retrieveItem(itemName: item)
                itemObject!.hasPaid = defaults.bool(forKey: "\(item)hasPaid")
            }
        }
        else{
            print("error loading the inventory")
        }
        
        // loads the user's credits amount
        credits = defaults.integer(forKey: "credits")
        creditAmount.text = "Credits: \(credits)"
        print("retrieved \(credits)")
        
        // loads the saved current room
        if let retrievedCurrent = defaults.string(forKey: "currentRoom"){
            current = getRoom(roomName: retrievedCurrent)
            
            imageView.image = UIImage(named: "\(current.name.lowercased())")
            print(current.name.lowercased())
        }
        else{
            print("error loading the current room")
        }
        // loads the saved room contents
        if let retrievedRooms = defaults.dictionary(forKey: "rooms") as? [String : [String]]{
            
            // loads the state of all room's inventory
            for (room, roomContents) in retrievedRooms{
                getRoom(roomName: room).contents = roomContents
            }
        }
        else{
            print("error loading the room contents")
        }
    }
    
    // saves the game data
    func saveGame() {
        // saves inventory
        defaults.set(inventory, forKey: "inventory")
        // save credits
        defaults.set(credits, forKey: "credits")
        print(credits)
        
        // save current room name
        defaults.set(current.name, forKey: "currentRoom")
        // saves the contents for each room
        var roomContentsDict = [String: [String]]()
        for room in floorPlan {
            roomContentsDict[room.name] = room.contents
        }
        defaults.set(roomContentsDict, forKey: "rooms")
        defaults.set(true, forKey: "hasSaveData")
        
        for item in inventory{
            defaults.set(retrieveItem(itemName: item)!.hasPaid, forKey: "\(item)hasPaid")
        }
        
        print("saved game")
    }
    
    // creates a room object
    func createRoom(roomInfo: [Any]) -> Room{
        return Room(name: roomInfo[0] as! String, north: roomInfo[1] as! String, east: roomInfo[2] as! String, south: roomInfo[3] as! String, west: roomInfo[4] as! String, up: roomInfo[5] as! String, down: roomInfo[6] as! String, contents: roomInfo[7] as! [String])
    }
    
    // prints the current room
    func look(){
        imageView.image = UIImage(named: "\(current.name.lowercased())")
        outputArea.text = "You are currently in the \(current.name)"
        outputArea.text! += "\n" + getContentsOfRoom(roomName: current.name)
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
        if room.contents.count > 0 && room.contents[0] != "none"{
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
    
    // adds an item to inventory
    func pickup(item: String){
        let roomHasItem = current.contents.contains(item.lowercased())
        
        if inventory.contains(item) {
            outputArea.text = "You can't pick up an item you already have."
        }
        // checks to make sure that the item is in the room
        else if roomHasItem && item.lowercased() != "none"{
            inventory.append(item)
            outputArea.text = "You now have the \(item). "
            current.contents.remove(at: current.contents.firstIndex(of: item)!)
            
            imageView.image = UIImage(named: "\(item)")
            let selectedItem = retrieveItem(itemName: item)
            if selectedItem != nil && selectedItem!.price == 0 && item != "blankets"{
                selectedItem!.hasPaid = true
            }
            
            if current.contents.contains("none"){
                inventory.remove(at: inventory.firstIndex(of: "none")!)
            }
        }
        else{
            outputArea.text = "That item is not a valid item to pick up."
        }
    }
    
    // removes an item from inventory
    func drop(item: String){
        if let index = inventory.firstIndex(of: item) {
            //
            current.contents.append(item)
            
            inventory.remove(at: index)
            outputArea.text = "You have dropped the \(item)."
            
            if current.contents.contains("none"){
                current.contents.remove(at: current.contents.firstIndex(of: "none")!)
            }
            
            imageView.image = UIImage(named: "\(item)")
        }
        else{
            outputArea.text = "You don’t have that item."
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
            outputArea.text = "You can't move in that direction!"
            return current
        }
        else if newRoomName.lowercased() == "break room"{
            if !inventory.contains("break room key"){
                outputArea.text = "You need the break room key."
                return current
            }
            else{
                outputArea.text = "You are now in the \(newRoomName)."
                current = getRoom(roomName: newRoomName)
                imageView.image = UIImage(named: "\(current.name.lowercased())")
                return current
            }
        }
        else if !checkPurchase(){ // checks for if the user bought all their inventory
            print(inventory)
            if inventory.contains("blankets"){
                outputArea.text = "You hear the owner yell: \"Hey! Put the blankets back!\""
            }
            else{
                outputArea.text = "\"Hey! You need to pay for that!\""
            }
            return current
        }
        else{
            current = getRoom(roomName: newRoomName)
            
            outputArea.text = "You are now in the \(newRoomName)."
            imageView.image = UIImage(named: "\(current.name.lowercased())")
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
            outputArea.text = "That is not a valid item to buy."
            return
        }
        else if itemToBuy.hasPaid {
            outputArea.text = "You can't buy an item you already own."
        }
        else if itemToBuy.name == "blankets"{
            outputArea.text = "Those blankets belong to the owner."
        }
        else if credits - itemToBuy.price >= 0{
            credits -= itemToBuy.price
            itemToBuy.hasPaid = true
            creditAmount.text = "Credits: \(credits)"
            outputArea.text = "You bought the \(itemName)."
            imageView.image = UIImage(named: "\(itemName)")
            
            if current.contents.contains(itemName){
                current.contents.remove(at: current.contents.firstIndex(of: itemName)!)
            }
            if !inventory.contains(itemName){
                inventory.append(itemName)
            }
        }
        else{
            outputArea.text = "You don't have enough credits!"
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
            outputArea.text = "You sold the \(itemName)."
            inventory.remove(at: inventory.firstIndex(of: itemName)!)
            imageView.image = UIImage(named: "\(itemName)")
            
            if itemName != "brand new rifle"{
                current.contents.append(itemName)
            }
        }
        else{
            outputArea.text = "You can't sell an item you don't own or have in your inventory!"
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
            outputArea.text = "\(itemName) is not a valid item"
            found = nil
        }
        else{
            found = allObjects.first(where: { $0.name.lowercased() == itemName.lowercased() })
        }
        return found
    }
        
    func listInventory() -> String{
        var outputString = "You are currently carrying: "
        
        if inventory.count > 0 {
            for item in inventory{
                outputString += "\n\t" + item
            }
        }
        else{
            outputString += "\n\t" + "nothing."
        }
        return outputString
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var command: String
        var itemArg = ""
        
        guard let commandFieldText = textField.text, !commandFieldText.isEmpty else {
                return true // dismissed if no text is entered
            }
        
        var commandTextSplit = commandFieldText.components(separatedBy: " ")
        
        // isolates the command from the rest of the commandField text
        command = commandTextSplit[0].lowercased()
        
        if commandTextSplit.count > 0{
            // removes the command
            commandTextSplit.remove(at: 0)
            
            // rejoins the remaining text to form the object name if using
            itemArg = (commandTextSplit.joined(separator: " "))
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
            outputArea.text = listInventory()
        case "takeoff":
            takeOff()
        case "exit":
            exit()
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
            outputArea.text = "That's not a valid command."
        }
        textField.text = ""
        return true
    }
    
    // text that loads at the start of the game
    func startText(){
        outputArea.text = """
        Welcome to this small corner of the galaxy!
        You currently need some supplies before you can takeoff:
            1. A fuel canister
            2. A supply crate
            3. A new maintenance robot
        
        Then you can continue on your journey!
        
        You are currently in the \(current.name)
        """
    }
    
    // erases playthrough data
    func exit() {
        let controller = UIAlertController(
            title: "WARNING!",
            message: "THIS WILL ERASE YOUR GAME DATA. ARE YOU SURE?",
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction( title: "No, take me back", style: .cancel))
        controller.addAction(UIAlertAction(title: "Yes, proceed", style: .destructive) { (alert) in self.resetGame()})
        
        present(controller, animated: true)
    }
    
    func resetGame(){
        defaults.removeObject(forKey: "inventory")
        defaults.removeObject(forKey: "credits")
        defaults.removeObject(forKey: "currentRoom")
        defaults.removeObject(forKey: "rooms")
        defaults.removeObject(forKey: "hasSaveData")
        
        inventory = []
        credits = 500
        current = floorPlan[0]
        
        // resets supply depot items
        floorPlan[2].contents = ["supply crate", "fuel canister"]
        
        // resets closet items
        floorPlan[3].contents = ["break room key"]
        
        // resets break room items
        floorPlan[4].contents = ["suspicious blender"]
        
        // resets mechanic shop items
        floorPlan[5].contents = ["toolbox", "maintenance robot"]
        
        // resets restaurant items
        floorPlan[6].contents = ["hot meal"]
        
        // resets attic contents
        floorPlan[7].contents = ["blankets"]
        
        // resets spaceship living room contents
        // resets spaceship living room contents
        floorPlan[9].contents = ["brand new rifle"]
        
        for item in allObjects{
            if item.name != "brand new rifle"{
                item.hasPaid = false
            }
            else{
                item.hasPaid = true
            }
        }
        imageView.image = UIImage(named: "\(current.name.lowercased())")
        outputArea.text = "Welcome back, traveler!"
        startText()
        creditAmount.text = "Credits: \(credits)"
    }
    
    // completes the game
    func takeOff(){
        let requiredItems = ["fuel canister", "supply crate", "maintenance robot"]
        if current.name != "spaceship"{
            outputArea.text = "You need to be in the spaceship center to take off!"
        }
        // checks if the users inventory has all the required items
        else if !requiredItems.allSatisfy({ inventory.contains($0)}){
            let missingItems = requiredItems.filter { !inventory.contains($0) }
            outputArea.text = "You can't take off yet! You still need the \(missingItems.joined(separator: ", "))"
        }
        else{
            outputArea.text = "Yay! You're ready for take off! \nEnter 'exit' to start a new playthrough."
        }
    }
    
    func help(){
        //outputArea.font = UIFont(name: "DIN Alternate", size: CGFloat(15.0))
        outputArea.text = """
        look: display the name of the current room and its contents
        north: move north
        east: move east
        south: move south
        west: move west
        up: move up
        down: move down
        takeoff: get ready for takeoff
        inventory: list what items you’re currently carrying
        buy ITEM: buy an item in the room
        sell ITEM: sell an item in your inventory
        get ITEM: pick up an item currently in the room
        drop ITEM: drop an item you’re currently carrying
        help: print this list
        exit: resets the playthrough
        """
    }
}

