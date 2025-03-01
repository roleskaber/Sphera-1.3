import SwiftUI
import AVFoundation
import Foundation
import SwiftData

struct AudioPlayerView: View {
    @Environment(\.openWindow) private var openWindow
    
    //Music vars
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    var fileName: String?
    var url: URL?
    
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateProgress() {
        guard let player = player, player.isPlaying else { return }
        currentTime = player.currentTime
    }
    
    var body: some View {
        VStack {
            if let player = player {
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
                        currentTime
                    }, set: { newValue in
                        player.currentTime = newValue
                        currentTime = newValue
                    }), in: 0...totalTime)
                    .accentColor(.blue)
                
                }
                
                
                HStack {
                    Text("\(formatTime(currentTime))")
                    Spacer()
                    Text("\(formatTime(totalTime))")
                }
                Text("Now playing: " + (fileName ?? "File"))
                .padding(.horizontal)
                
                Button("Show details") {
                            openWindow(id: "mail-viewer")
                        }
            }
        }
        .onAppear {
            if let url = Bundle.main.url(forResource: "QT – Hey QT", withExtension: "mp3"){
                    do {
                        player = try AVAudioPlayer(contentsOf: url)
                        player?.prepareToPlay()
                        totalTime = player?.duration ?? 0.0
                    } catch {
                        print("Error loading audio: \(error)")
                    }
                
            } else {
                print("Audio file URL is nil.")
            }
            
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
        .onDisappear {
            player?.stop()
        }
        
        }
}

struct ContentView: View {
    var body: some View {
        
        AudioPlayerView(fileName: "QT – Hey QT", url: Bundle.main.url(forResource: "QT – Hey QT", withExtension: "mp3"))
            .padding()
    }
}

#Preview {
    ContentView()
}
