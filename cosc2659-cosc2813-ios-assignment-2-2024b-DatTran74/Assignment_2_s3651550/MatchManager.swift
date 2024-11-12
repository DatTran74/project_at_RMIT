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

import Foundation
import GameKit
import PencilKit

class MatchManager:NSObject, ObservableObject {
    @Published var authenticationState = PlayerAuthState.authenticating
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var lastReceivedDrawing =  PKDrawing()
    @Published var isTimeKeeper = false
    
    @Published var currentlyDrawing = false
    @Published var drawPrompt = ""
    @Published var pastGuesses = [PassGuess]()
    
    @Published var score = 0
    @Published var remainingTime = maxTimeRemaining
    
    var match: GKMatch?
    var otherPlayer: GKPlayer?
    var localPlayer = GKLocalPlayer.local
    
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController : UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    func authenticateUser(){
        GKLocalPlayer.local.authenticateHandler = { [self] vc , e in
            if let viewController = vc {
                rootViewController?.present(viewController, animated: true)
                return
            }
            if let error = e {
                authenticationState = .error
                print(error.localizedDescription)
                
                return
            }
            if localPlayer.isAuthenticated{
                if localPlayer.isMultiplayerGamingRestricted{
                    authenticationState = .restricted
                }else{
                    authenticationState = .authenticated
                }
            }else{
                authenticationState = .unauthenticated
            }
        }
    }
    func stateMatchmaking(){
        let request = GKMatchRequest()
        request.minPlayers=2
        request.maxPlayers=2
        
        let matchmakingVC = GKMatchmakerViewController(matchRequest:  request)
        matchmakingVC?.matchmakerDelegate = self
        
        rootViewController?.present(matchmakingVC! , animated: true)
    }
    func startGame(newMatch: GKMatch){
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        drawPrompt = everydayObjects.randomElement()!
        
        sendString("Began:\(playerUUIDKey)")
    }
    func receivedString (_ message: String){
        let messageSpilt = message.split(separator: ":")
        guard let messagePrefix = messageSpilt.first else {return}
        let parameter = String(messageSpilt.last ?? "")
        switch messagePrefix{
        case "began":
            if playerUUIDKey == parameter{
                playerUUIDKey = UUID().uuidString
                playerUUIDKey =  UUID().uuidString
                sendString("began:\(playerUUIDKey)")
            }
            currentlyDrawing =  playerUUIDKey < parameter
            inGame = true
            isTimeKeeper = true
            
            if isTimeKeeper{
                countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        default:
            break
        }
    }
}
