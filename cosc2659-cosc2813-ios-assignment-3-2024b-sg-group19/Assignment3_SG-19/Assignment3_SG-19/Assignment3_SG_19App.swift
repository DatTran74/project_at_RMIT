/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Authors: Tran Xuan Hoang Dat, Tran Vinh Trong, Nguyen Huy Anh, Nguyen The Anh
  ID: s3651550, s3863973, s3956092, s3927195
  Created date: 11/09/2024
  Last modified: 22/09/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI
import Firebase

@main
struct Assignment3_SG_19App: App {
    //  Dark mode boolean
    @AppStorage("isDark") private var isDark = false
    //  User mood
    @AppStorage("mood") private var mood = 0.0
    //  App language
    @AppStorage("vietnamese") private var vietnamese = false
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var viewModel = AuthViewModel()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .preferredColorScheme(isDark ? .dark : .light)
                .onChange(of: isDark) {
                    // Force the color scheme change when isDark updates
                    updateAppearance(isDark: isDark)
                }
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        // Ensure the theme is correctly set when the app becomes active
                        updateAppearance(isDark: isDark)
                    }
                }
        }
    }
}

// Helper function to trigger the view hierarchy update
func updateAppearance(isDark: Bool) {
    // Iterate through all connected scenes and apply to the first active UIWindowScene
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            // Update the first window in the active scene
            if let window = windowScene.windows.first {
                window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            }
        }
}
