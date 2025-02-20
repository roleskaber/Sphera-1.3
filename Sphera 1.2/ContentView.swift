import SwiftUI
import AVFoundation
import AVKit


struct AudioPlayerView: View {
    
    @State private var player: AVAudioPlayer?  // The audio player instance
    @State private var isPlaying = false  // Tracks whether the audio is playing or not
    @State private var totalTime: TimeInterval = 0.0  // Total duration of the audio
    @State private var currentTime: TimeInterval = 0.0  // Current playback time of the audio
    
    var fileName: String?  // The name of the audio file to display
    var url: URL?  // The URL of the audio file
    
    
    
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Setup the audio player with the given URL
    private func setupAudio(withURL url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0  // Set the total duration of the audio
        } catch {
            print("Error loading audio: \(error)")
        }
    }

    // Update the current time of the audio playback
    private func updateProgress() {
        guard let player = player, player.isPlaying else { return }
        currentTime = player.currentTime  // Update the current time state
    }
    
    var body: some View {
        ZStack {
            VStack {
                if let player = player {
                    Text(fileName ?? "File")  // Display the file name or a default text
                    
                    HStack {
                        Button(action: {
                            // Toggle play/pause state
                            isPlaying.toggle()
                            if isPlaying {
                                player.play()  // Play the audio
                            } else {
                                player.pause()  // Pause the audio
                            }
                        }) {
                            // Display play or pause button based on the isPlaying state
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.largeTitle)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Slider(value: Binding(get: {
                            currentTime
                        }, set: { newValue in
                            // Update the player's current time and the currentTime state
                            player.currentTime = newValue
                            currentTime = newValue
                        }), in: 0...totalTime)  // Slider range from 0 to the total duration of the audio
                        .accentColor(.blue)  // Slider color
                    }
                    
                    HStack {
                        Text("\(formatTime(currentTime))")  // Display the current time
                        Spacer()
                        Text("\(formatTime(totalTime))")  // Display the total time
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                // Setup the audio player when the view appears
                if let url = url {
                    setupAudio(withURL: url)
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
        AudioPlayerView(fileName: "Example Audio", url: Bundle.main.url(forResource: "sample", withExtension: "mp3"))
            .padding()
    }
}
#Preview {
    AudioPlayerView(fileName: "QT – Hey QT", url: URL(string: "QT – Hey QT"))
        .padding()
}
