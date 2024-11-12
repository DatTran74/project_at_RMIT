import SwiftUI
import AVFoundation

struct MenuView: View {
    @ObservedObject var matchManager: MatchManager
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            Spacer()
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding(30)
            
            Spacer()
            
            Button {
                matchManager.startMatchmaking()
            } label: {
                Text("PLAY")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
            }
            .disabled(matchManager.authenticationState != .authenticated || matchManager.inGame)
            .padding(.vertical, 20)
            .padding(.horizontal, 100)
            .background(
                Capsule(style: .circular)
                    .fill(matchManager.authenticationState != .authenticated || matchManager.inGame ? .gray : Color("playBtn"))
            )
            
            Text(matchManager.authenticationState.rawValue)
                .font(.headline.weight(.semibold))
                .foregroundColor(Color("primaryYellow"))
                .padding()
            
            Spacer()
        }
        .background(
            Image("menuBg")
                .resizable()
                .scaledToFill()
                .scaleEffect(1.1)
        )
        .ignoresSafeArea()
        .onAppear {
            playBackgroundMusic()
        }
    }

    func playBackgroundMusic() {
        if let sound = Bundle.main.path(forResource: "menu", ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                audioPlayer?.numberOfLoops = -1 // Loop indefinitely
                audioPlayer?.play()
            } catch {
                print("Failed to play background music: \(error.localizedDescription)")
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(matchManager: MatchManager())
    }
}
