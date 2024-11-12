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

struct ContentView: View {
    @AppStorage("isDark") private var isDark = false
    @State private var isActive = false
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if isActive {
            Group{
                if viewModel.userSession != nil{
                    ProfileView()
                } else {
                    LoginView()
                }
            }
        } else {
            SplashScreen(isActive: $isActive)
        }
    }
}

#Preview {
    ContentView()
}
