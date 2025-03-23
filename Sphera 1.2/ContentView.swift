import SwiftUI

struct ContentView: View {
    @Binding var menu: Bool
    @Binding var Deck_1: Deck
//    @Binding var Deck_2: Deck
    var body: some View {

        if menu {
            AudioPlayerView(Deck_1: $Deck_1, menu: $menu, isCompact: false)

        }
        else {
            VStack {
                DetailView(init_mood: 0.0, Deck_1: $Deck_1, Deck_2:
                        .constant(Deck(play: "", path: "", trigger: false)))
                AudioPlayerView(Deck_1: $Deck_1, menu: $menu, isCompact: true)
                    .frame(height: 100)
            }
            
        }
        
    }

}
