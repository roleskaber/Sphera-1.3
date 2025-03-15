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
    @Environment(\.modelContext) private var modelContext
    
    @Query var musicLib: [Music]
    @Query var standartMusicLib: [Music]
    
    //Finder
    @State private var isImporting: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List {
                Section ("Standart library") {
                    ForEach(standartMusicLib) { item in
                        NavigationLink {
                            HStack {
                                Text(item.name)
                                    .font(.largeTitle)
                                    .padding()
                                
                            }
                            Spacer()
                            HStack {
                                if item.mood != nil {
                                    Slider(value: Binding(
                                        get: { item.mood ?? 0.0 },
                                        set: { newValue in item.mood = newValue }
                                    ), in: 0...1)
                                    .accentColor(.blue)
                                    Text("Choose mood")
                                        .padding()
                                } else {
                                    Button("add mood") {
                                        item.mood = 0.0
                                    }
                                }
                            }
                            .padding()
                            HStack {
                                Button("", systemImage: "trash", role: .destructive) {
                                    modelContext.delete(item)
                                    
                                } .buttonStyle(PlainButtonStyle())
                                    .opacity(40)
                                    
                            
                                
                                Spacer()
                                Button("Load Background", systemImage: "circle.bottomrighthalf.pattern.checkered") {
                                    Deck_2.play = item.name
                                    Deck_2.path = item.path
                                    Deck_2.trigger = true
                                }.buttonStyle(.borderedProminent)
                                Button("Load main", systemImage: "lightspectrum.horizontal") {
                                    Deck_1.play = item.name
                                    Deck_1.path = item.path
                                    Deck_1.trigger = true
                                }.buttonStyle(.borderedProminent)
                            }
                            .controlSize(.large)
                            .padding()
                            
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
                    Button("Add Item", systemImage: "plus") {
                            isImporting = true
                        }
                        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.mp3]) { result in
                            switch result {
                            case .success(let url):
                                let filepath: URL = URL(string: url.path)!
                                addItem(url: filepath)
                            case .failure(let error):
                                print(error)
                        }
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .task {
            let newItems: [Music] = [Music(name: "nature", path: "nature.mp3", mood: 0.6),
                                    Music(name: "rain", path: "rain.mp3", mood: 0.2),
                                    Music(name: "library", path: "library.mp3", mood: 0.8),]
            for standartItem in newItems {
                var availiable: Bool = false
                for item in standartMusicLib {
                    if item.path == standartItem.path  { availiable = true }
                }
                if !availiable { modelContext.insert(standartItem) }
                
            }
        }
        .toolbar {
            ToolbarItem {
                Menu("Options") {
                    Button("reload items", action: reloadItems)
                }
            }
        }
    }
        
    private func reloadItems () {
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
                if item.path == fileName {
                    avaliable = true
                }
            }
            if avaliable == false {
                modelContext.insert(Music(name: fileName, path: fileName, mood: nil))
            }
        }
    }
    private func addItem(url: URL) {
        let name = url.deletingPathExtension().lastPathComponent
        let newItem = Music(name: name, path: url.path, mood: nil)
        modelContext.insert(newItem)
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

