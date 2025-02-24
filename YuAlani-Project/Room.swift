//
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
    
    init(name: String, north: String, east: String, south: String, west: String, up: String, down: String){
        self.name = name
        self.north = north
        self.east = east
        self.south = south
        self.west = west
        self.up = up
        self.down = down
        
    }
    
    // prints adjacent rooms
    func displayRoom(){
        
    }
}
