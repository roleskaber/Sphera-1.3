//
//  ObjView.swift
//  Sphera 1.2
//
//  Created by Виталик Марченко on 23.03.25.
//
import SwiftUI
import SwiftData

struct ObjView: View  {
    var item: Music
    var init_mood: Double
    @Environment(\.modelContext) private var modelContext
    
    var Deck_1: Deck
    var Deck_2: Deck
    var body: some View {
        NavigationLink {
            HStack {
                
                
                VStack {
                    Spacer()
                    Text(item.name)
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                    HStack {
                        Button("", systemImage: "trash", role: .destructive) {
                            modelContext.delete(item)
                            
                        } .buttonStyle(PlainButtonStyle())
                            .opacity(40)
                        
                        
                        
                        Spacer()
                        Button("Load Background", systemImage: "circle.bottomrighthalf.pattern.checkered") {
        //                                    Deck_2.play = item.name
        //                                    Deck_2.path = item.path
        //                                    Deck_2.trigger = true
                        }.buttonStyle(.myAppPrimaryButton)
                        Button("Load main", systemImage: "lightspectrum.horizontal") {
                            Deck_1.song.name = item.name
                            Deck_1.song.path = item.path
                            Deck_1.song.mood = item.mood
                            Deck_1.trigger = true
                        } .buttonStyle(.myAppPrimaryButton)
                        
                        
                    }
                    .controlSize(.large)
                    .buttonBorderShape(.capsule)
                    .padding()
                }
                Spacer()
                VStack {
                    AnimatedFigureView()
                        .padding()
                }
                
            }
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
            
            
        } label: {
            Text(item.name)
        }
    }
    
    
    
}
