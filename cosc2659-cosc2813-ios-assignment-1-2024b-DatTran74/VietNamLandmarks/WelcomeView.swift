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

struct WelcomeView: View {
    @State private var showingAlert = false
    @State private var modeName = Image(systemName: "sun.max")
    @State private var isLightMode = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
                
                VStack {
                    Text("Vietnam Famous Tourist attraction & Landmarks")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .shadow(radius: 10)
                    
                    
                    Image("Vietnam")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.vertical, 20)
                        .shadow(radius: 10)
                    
                    NavigationLink(destination: LandmarkList()) {
                        Text("LET'S GO")
                            .font(.title2)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .preferredColorScheme(isLightMode ? .light : .dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingAlert = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Information"), message: Text("Name: Tran Xuan Hoang Dat\ns3651550"), dismissButton: .default(Text("OK")))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        toggleMode()
                    }) {
                        modeName
                            .font(.title)
                            .padding()
                            .shadow(radius: 10)
                    }
                }
            }
        }
    }
    
    private func toggleMode() {
        if isLightMode {
            modeName = Image(systemName: "moon.stars")
        } else {
            modeName = Image(systemName: "sun.max")
        }
        isLightMode.toggle()
    }
}

#Preview {
    WelcomeView()
        .environment(ModelData()) // Corrected the view name
}
