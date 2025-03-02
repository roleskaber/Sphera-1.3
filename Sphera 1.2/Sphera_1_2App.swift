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
            ContentView()
        }
        WindowGroup (id: "mail-viewer"){
            DetailView(init_mood: 1)
        }
        .modelContainer(sharedModelContainer)
        
    }
}
