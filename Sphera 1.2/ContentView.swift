import SwiftUI
import AVFoundation
import Foundation
import SwiftData

struct AudioPlayerView: View {
    
    @Environment(\.openWindow) private var openWindow
    @Binding var Deck_1: Deck
    @Binding var menu: Bool
    
    //Music vars
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
//    private func updateProgress() {
//        guard let player = player, player.isPlaying else { return }
//        currentTime = player.currentTime
//    }
    @State private var playLogo: String = ""
    var body: some View {
        ZStack {
            MeshGradient(
                width: 2,
                height: 2,
                points: [
                    [0.0, 0.0],[1.0, 0.0],
                    [0.0, 1.0],[1.0, 1.0]
                ],
                colors: [
                    .blue,
                    .indigo,
                    .blue,
                    .indigo
                ]
            )
            .opacity(0.1)
            VStack {
                
                Spacer()
                if let player = Deck_1.player {
                    HStack {
                        Button(action: {
                            
                            isPlaying.toggle()
                            if isPlaying {
                                player.play()
                                
                            } else {
                                player.pause()
                            }
                        })
                        {
                            
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.largeTitle)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                        Slider(value: Binding(get: {
                            player.currentTime
                        }, set: { newValue in
                            player.currentTime = newValue
                        }), in: 0...(player.duration))
                        .accentColor(.blue)
                    }
                    
                    
                    HStack {
                        Text("To the end of Scene: " + "\(formatTime(player.duration - player.currentTime))")
                    }
                    Spacer()
                    Text("Now playing: " + (Deck_1.path))
                        .padding(.horizontal)
                    
                    Button("Set") {
//                        openWindow(id: "mail-viewer")
                        menu = false
                        
                    }
                }
            }
            .padding()
            
        }
            
        
        .onAppear {
            
            Deck_1.loadAVAudio()
            
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if Deck_1.trigger == true {
                Deck_1.loadAVAudio()
                Deck_1.player?.play()
                Deck_1.trigger = false
            }
            Deck_1.updateProgress()
            
        }
        .onDisappear {
            Deck_1.player?.stop()
        }
        
    }
    
}

struct ContentView: View {
    @Binding var menu: Bool
    @Binding var Deck_1: Deck
//    @Binding var Deck_2: Deck
    var body: some View {
        if menu {
            AudioPlayerView(Deck_1: $Deck_1, menu: $menu)
        }
        else {
            DetailView(init_mood: 0.0, Deck_1: $Deck_1, Deck_2: .constant(Deck(play: "", path: "", trigger: false)))
        }
    }
}
