//
//  Music.swift
//  Sphera 1.2
//
//  Created by Виталик Марченко on 2.03.25.
//
import SwiftData

@Model
class Music {
    var name: String
    var path: String
    var mood: Double?
    
    init(name: String, path: String, mood: Double?) {
        self.name = name
        self.path = path
        self.mood = mood
    }
}
