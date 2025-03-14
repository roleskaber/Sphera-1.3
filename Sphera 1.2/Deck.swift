//
//  Deck.swift
//  Sphera 1.2
//
//  Created by Виталик Марченко on 3.03.25.
//
import AVFoundation
class Deck {
    var player: AVAudioPlayer?
    private var totalTime: TimeInterval = 0.0
    private var currentTime: TimeInterval = 0.0
    var play: String
    var path: String
    var trigger: Bool
    
    init(play: String, path: String, trigger: Bool) {
        self.play = play
        self.path = path
        self.trigger = trigger
    }
    
    func updateProgress() {
        guard let player = player, player.isPlaying else { return }
        currentTime = player.currentTime
    }
    
    func loadAVAudio ()
    {
        
        let firstpoint = path.firstIndex(of: ".") ?? path.endIndex
        let lpath = path[..<firstpoint]
        if let url = Bundle.main.url(forResource: String(lpath), withExtension: "mp3"){
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

}


