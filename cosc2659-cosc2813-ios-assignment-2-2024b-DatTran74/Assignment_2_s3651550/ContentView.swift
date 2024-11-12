/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Tran Xuan Hoang Dat
  ID: s3651550
  Created  date: 25/07/2024
  Last modified: dd/mm/yyyy (e.g. 05/08/2023)
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

struct ContentView: View {
    @StateObject var matchManager = MatchManager()
    
    var body: some View {
        ZStack {
            if matchManager.isGameOver {
                GameOverView(matchManager: matchManager)
            } else if matchManager.inGame {
                GameView(matchManager: matchManager)
            } else {
                MenuView(matchManager: matchManager)
            }
        }
        .onAppear {
            matchManager.authenticateUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
