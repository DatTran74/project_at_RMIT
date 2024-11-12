/*
  RMIT University Vietnam
  Course: COSC2659|COSC2813 iOS Development
  Semester: 2024B
  Assessment: Assignment 1
  Author: Tran Xuan Hoang Dat
  ID: s3651550
  Created date: 19/07/2024
  Last modified: 25/07/2024 (e.g. 05/08/2024)
  Acknowledgement: https://developer.apple.com/tutorials/swiftui/handling-user-input
*/
import SwiftUI


@main
struct VietNamLandmarksApp: App {
    @State private var modelData = ModelData()
    
    
    var body: some Scene {
        WindowGroup {
            
            WelcomeView()
                .environment(modelData)
        }
    }
}
