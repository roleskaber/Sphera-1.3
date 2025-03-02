import SwiftUI
import AVFoundation
import Foundation
import SwiftData

@Model
class Music {
    var name: String
    var path: String
    var mood: Double
    
    init(name: String, path: String, mood: Double) {
        self.name = name
        self.path = path
        self.mood = mood
    }
}

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

struct DetailView: View {
    var init_mood: Double
    
    //Lib model tools
    @Environment(\.modelContext) private var modelContext
    @Query var musicLib: [Music] = []

    @Query var standartMusicLib: [Music] = []
    
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
                            Slider(value: Binding(get: {
                                item.mood
                            }, set: { newValue in
                                item.mood = newValue
                            }), in: 0...1)
                            .accentColor(.blue)
                            Text("Choose mood")
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
                {if item.name == fileName {
                    avaliable = true
                }}
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
                modelContext.delete(musicLib[index])
            }
        }
    }

}

#Preview {
    ContentView()
}
