import SwiftUI
import AVFoundation
import Foundation
import SwiftData

struct AudioPlayerView: View {
    @Environment(\.openWindow) private var openWindow
    @Binding var Deck_1: Deck
    @Binding var menu: Bool
    
    @State var isCompact = false
    
    @State private var colors = [Color.purple, Color.cyan, Color.blue, Color.mint,
                                 Color.mint, Color.indigo, Color.yellow,
                                 Color.orange, Color.red, Color.brown]
    
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            MeshGradient(
                width: 2,
                height: 2,
                points: [[0.0, 0.0], [1.0, 0.0], [0.0, 1.0], [1.0, 1.0]],
                colors: [.blue, .indigo, .blue, .indigo]
            )
            .opacity(0.1)
            
            VStack {
                Button(
                    action:{
                        menu.toggle()
                    } ) {
                        Image(systemName: menu ? "arrowtriangle.up" : "arrowtriangle.down")
                    }
                if !isCompact { Spacer() }
                if let player = Deck_1.player {
                    HStack {
                        Button(action: {
                            isPlaying.toggle()
                            if isPlaying {player.play()}
                            else {player.pause()}
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.largeTitle)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Slider(value: Binding(
                            get: { currentTime },
                            set: { newValue in
                                player.currentTime = newValue
                            }
                        ), in: 0...(totalTime))
                        .accentColor(.blue)
                    }
                    if !isCompact {
                        Text("To the end of Scene: " + formatTime(totalTime - currentTime))
                            .padding(.top, 5)
                            .opacity(0.5)
                        Spacer()
                        Text("Now playing: " + Deck_1.path)
                            .padding(.horizontal)
                            .opacity(0.5)
                    }
                    
                } else {
                    Text("Error: AVPlayer is unavaliable")
                }
            }
            
            .padding()
        }
        .onAppear {
            Deck_1.loadAVAudio()
            totalTime = Deck_1.player?.duration ?? 0.0
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            if let player = Deck_1.player, player.isPlaying {
                currentTime = player.currentTime
            }
            
            if Deck_1.trigger {
                Deck_1.loadAVAudio()
                Deck_1.player?.play()
                Deck_1.trigger = false
                totalTime = Deck_1.player?.duration ?? 0.0
            }
        }
        .onDisappear {
            Deck_1.player?.stop()
        }
    }
}
