//
//  Sphera_1_2App.swift
//  Sphera 1.2
//
//  Created by Виталик Марченко on 20.02.25.
//

import SwiftUI
import SwiftData



                                
@main
struct Sphera_1_2App: App {
    @State private var deck1 = Deck(play: "", path: "", trigger: false)
    @State private var deck2 = Deck(play: "", path: "", trigger: false)
    @State private var menu = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Music.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(menu: $menu, Deck_1: $deck1)
        }
        .modelContainer(sharedModelContainer)
         
    }
}
