//
//  DetailView.swift
//  Sphera 1.2
//
//  Created by Виталик Марченко on 2.03.25.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    var init_mood: Double
    @Binding var Deck_1: Deck
    @Binding var Deck_2: Deck
    //Lib model tools
    @Environment(\.modelContext) private var modelContext
    @Query var musicLib: [Music]
    @Query var standartMusicLib: [Music]
    
    var body: some View {
        NavigationSplitView {
            List {
                Section ("Standart library") {
                    ForEach(standartMusicLib) { item in
                        NavigationLink {
                            HStack {
                                Text(item.name)
                                    .font(.largeTitle)
                                Spacer()
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    modelContext.delete(item)
                                }
                            }
                            Spacer()
                            HStack {
                                Slider(value: Binding(get: {
                                    item.mood
                                }, set: { newValue in
                                    item.mood = newValue
                                }), in: 0...1)
                                .accentColor(.blue)
                                Text("Choose mood")
                                    .padding()
                                Button("Load Background", systemImage: "trash") {
                                    Deck_2.play = item.name
                                    Deck_2.path = item.path
                                }
                                Button("Load main", systemImage: "trash") {
                                    Deck_1.play = item.name
                                    Deck_1.path = item.path
                                }
                            }
                            
                            
                        } label: {
                            Text(item.name)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section ("Added") {
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        
        .onAppear {
            var fileNames: [String] = []
            let fileManager = FileManager.default
            guard let resourcePath = Bundle.main.resourcePath else {
                print("Не удалось найти путь к ресурсам.")
                return
            }
            
            do {
                let files = try fileManager.contentsOfDirectory(atPath: resourcePath)
                fileNames = files.filter { $0.hasSuffix(".mp3") }
            } catch {
                print("Ошибка при чтении файлов: \(error)")
            }
            for fileName in fileNames {
                var avaliable: Bool = false
                for item in standartMusicLib
                {
                    if item.name == fileName {
                        avaliable = true
                    }
                }
                if avaliable == false {
                    modelContext.insert(Music(name: fileName, path: fileName, mood: 0))
                }
            }
        }
        
    }
    private func addItem() {
        withAnimation {
            let newItem = Music(name: "Hui", path: "", mood: 0)
            modelContext.insert(newItem)
        }
    }
    

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let itemToDelete = musicLib[index]
                modelContext.delete(itemToDelete)
            }
        }
    }
}


