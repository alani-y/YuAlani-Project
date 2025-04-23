// Project: YuAlani-Project
// EID: ay7892
// Course: CS329E

//  Room.swift
//  YuAlani-Project
//
//  Created by Alani Yu on 2/24/25.
//

import Foundation

class Room {
    var name: String
    var north: String
    var east: String
    var south: String
    var west: String
    var up: String
    var down: String
    var contents: [String]
    
    init(name: String, north: String, east: String, south: String, west: String, up: String, down: String, contents: [String]){
        self.name = name
        self.north = north
        self.east = east
        self.south = south
        self.west = west
        self.up = up
        self.down = down
        self.contents = contents
    }
    
    // prints adjacent rooms
    func displayRoom(){
        print("Room name: \(self.name)")
        if(self.north != "None"){
            print("\tRoom to the north: \(self.north)")
        }
        if(self.east != "None"){
            print("\tRoom to the east: \(self.east)")
        }
        if(self.south != "None"){
            print("\tRoom to the south: \(self.south)")
        }
        if(self.west != "None"){
            print("\tRoom to the west: \(self.west)")
        }
        if(self.up != "None"){
            print("\tRoom above: \(self.up)")
        }
        if(self.down != "None"){
            print("\tRoom below: \(self.down)")
        }
        print()
    }
}
