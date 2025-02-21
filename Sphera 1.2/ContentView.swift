import SwiftUI
import AVFoundation
import AVKit

class Music {
    var name: String
    var path: String
    var mood: Double
    var videoPath: String
    init(name: String, path: String, mood: Double, videoPath: String) {
        self.name = name
        self.path = path
        self.mood = mood
        self.videoPath = videoPath
    }
}
let Qt = Music(name: "QT – Hey QT", path: "QT – Hey QT", mood: 0.9, videoPath: "" )
struct AudioPlayerView: View {
    
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

    private func setupAudio(withURL url: URL) {
        do {
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    private func updateProgress() {
        guard let player = player, player.isPlaying else { return }
        currentTime = player.currentTime
    }
    
    var body: some View {
        NavigationView {
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
                        NavigationLink(destination: DetailView(init_mood: Qt.mood)){
                            Text("Set")
                        }
                    }
                    
                    
                    HStack {
                        Text("\(formatTime(currentTime))")
                        Spacer()
                        Text("\(formatTime(totalTime))")
                    }
                    Text("Now playing: " + (fileName ?? "File"))
                    .padding(.horizontal)
                }
            }
            .onAppear {
                // Setup the audio player when the view appears
                if let url = url {
                    setupAudio(withURL: url)
                } else {
                    print("Audio file URL is nil.")
                }
            }
            .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                updateProgress()
            }
            .onDisappear {
                // Stop the audio player when the view disappears
                player?.stop()
            }
            
        }}
}

struct ContentView: View {
    var body: some View {
        
        AudioPlayerView(fileName: Qt.name, url: Bundle.main.url(forResource: Qt.path, withExtension: "mp3"))
            .padding()
    }
}

struct DetailView : View {
    @State var init_mood: Double
    var body: some View {
         
            VStack {
                Slider(value: Binding(get: {
                    init_mood
                }, set: { newValue in
                    init_mood = newValue
                }), in: 0...1)
                .accentColor(.blue)
                
                Text("Choose mood")
            }
        
    }
}
#Preview {
    ContentView()
}
