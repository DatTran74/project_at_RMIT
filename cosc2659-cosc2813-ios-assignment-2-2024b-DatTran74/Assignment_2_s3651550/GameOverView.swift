import SwiftUI
import AVFoundation

struct GameOverView: View {
    @ObservedObject var matchManager: MatchManager
    @State private var gameOverAudioPlayer: AVAudioPlayer?

    func playGameOverMusic() {
        if let sound = Bundle.main.path(forResource: "Gameover", ofType: "mp3") {  // Ensure the "gameover.mp3" file is added to your project
            do {
                gameOverAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                gameOverAudioPlayer?.numberOfLoops = -1  // Loop indefinitely
                gameOverAudioPlayer?.play()
            } catch {
                print("Failed to play Game Over music: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("gameOver")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 70)
                .padding(.vertical)
            
            Text("Score: \(matchManager.score)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color("primaryYellow"))
            
            Spacer()
            
            Button {
                matchManager.resetGame()
                gameOverAudioPlayer?.stop()  // Stop the music when returning to the menu
            } label: {
                Text("Menu")
                    .foregroundColor(Color("menuBtn"))
                    .brightness(-0.4)
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
            .padding(.horizontal, 50)
            .background(
                Capsule(style: .circular)
                    .fill(Color("menuBtn"))
            )
            
            Spacer()
        }
        .background(
            Image("gameOverBg")
                .resizable()
                .scaledToFill()
                .scaleEffect(1.1)
        )
        .ignoresSafeArea()
        .onAppear {
            playGameOverMusic()  // Play the Game Over music when the view appears
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(matchManager: MatchManager())
    }
}
