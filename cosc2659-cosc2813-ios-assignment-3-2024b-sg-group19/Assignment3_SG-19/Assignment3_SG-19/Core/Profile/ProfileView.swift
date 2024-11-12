/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Authors: Tran Xuan Hoang Dat, Tran Vinh Trong, Nguyen Huy Anh, Nguyen The Anh
  ID: s3651550, s3863973, s3956092, s3927195
  Created date: 13/09/2024
  Last modified: 22/09/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("isDark") private var isDark = false
    @AppStorage("vietnamese") private var vietnamese = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateToChat = false
    @StateObject private var chatService = ChatService()
    @StateObject private var moodService = MoodService()
    @State private var overallMood = 0.0
    @State private var showSwitchLanguageAlert = false
    private var db = Firestore.firestore()
    private var maxMoodScore = 0
    @State private var showDeleteAccountAlert = false



    
    var body: some View {
        NavigationStack {
            if let user = viewModel.currentUser {
                List {
                    Section {
                        profileHeader(user: user) // Profile info
                    }
                    generalSettings() // General settings
                    accountSettings() // Account-related settings
                }
            }
        }
        .tint(Color("TextColor"))
        .onAppear {
            // Fetch the total mood score on view appear
            viewModel.listenForMoodScoreUpdates { moodScore in
                overallMood = moodScore
            }
        }
    }
    
    // MARK: Profile Header
    @ViewBuilder private func profileHeader(user: User) -> some View {
        HStack {
            Text(user.initials)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 72, height: 72)
                .background(Color(.systemGray3))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullname)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.top, 4)
                    .foregroundColor(Color("TextColor"))
                Text(user.email)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
    
    // MARK: General Settings
    @ViewBuilder private func generalSettings() -> some View {
        Section(!vietnamese ? "General" : "Cài đặt chung") {
            // Other general settings, like version and dark mode
            languageButton()
            darkModeToggle()
        }
    }
    
    // MARK: Account Settings
    @ViewBuilder private func accountSettings() -> some View {
        Section(!vietnamese ? "Account" : "Tài khoản") {
            moodGauge()
            resetMoodScoreButton()
            chatButton() // Button to navigate to ChatView
            signOutButton()
            deleteAccountButton()
    
        }
    }


    
    private func chatButton() -> some View {
        Button {
            navigateToChat = true
        } label: {
            SettingRowView(imageName: "person.circle", title: !vietnamese ? "Chat with your AI friend" : "Trò chuyện với người bạn AI của bạn", tintColor: .blue, textColor: .blue)
        }
        .navigationDestination(isPresented: $navigateToChat) {
            ChatView() // Navigate to ChatView
        }
    }
    
    // Add a button to delete the user's account
    private func deleteAccountButton() -> some View {
        Button {
            showDeleteAccountAlert = true // Show confirmation alert
        } label: {
            Text(!vietnamese ? "Delete Account" : "Xóa tài khoản")
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .alert(isPresented: $showDeleteAccountAlert) {
            Alert(
                title: Text(!vietnamese ? "Delete Account" : "Xóa tài khoản"),
                message: Text(!vietnamese ? "Are you sure you want to delete your account? This action cannot be undone." : "Bạn có chắc chắn muốn xóa tài khoản không? Hành động này không thể hoàn tác."),
                primaryButton: .destructive(Text(!vietnamese ? "Delete" : "Xóa")) {
                    
                    deleteUserAccount()
                },
                secondaryButton: .cancel(Text(!vietnamese ? "Cancel" : "Hủy"))
            )
        }
    }


    private func deleteUserAccount() {
        Task {
            do {
                // Gọi hàm deleteAccountAndData() từ AuthViewModel để xóa tài khoản
                try await viewModel.deleteAccountAndData()

                // Sau khi xóa tài khoản, điều hướng về RegistrationView
                navigateToRegistration()
            } catch {
                print("Error deleting account: \(error.localizedDescription)")
            }
        }
    }

    private func navigateToRegistration() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    // Set the root view to RegistrationView
                    window.rootViewController = UIHostingController(rootView: RegistrationView())
                    window.makeKeyAndVisible()
                }
            }
        }
    }



    
    
    func resetMoodScore(completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        let moodQuery = db.collection("moods").whereField("userID", isEqualTo: userID)
        moodQuery.getDocuments { snapshot, error in
            if let error = error {
                print("Error deleting mood scores: \(error.localizedDescription)")
                completion(false)
                return
            }

            for document in snapshot?.documents ?? [] {
                document.reference.delete()
            }

             moodService.moodScore = 0.0
            completion(true)
        }
    }



    
    // MARK: Additional Helpers
    // Language button with deletion logic


    private func languageButton() -> some View {
        Button {
            showSwitchLanguageAlert = true
        } label: {
            HStack {
                Text(!vietnamese ? "Language" : "Ngôn ngữ")
                    .font(.subheadline)
                    .foregroundColor(Color("TextColor"))
                Spacer()
                Text(!vietnamese ? "English" : "Tiếng Việt")
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
            }
        }
        .alert(isPresented: $showSwitchLanguageAlert) {
            Alert(
                title: Text(vietnamese ? "Đổi ngôn ngữ" : "Switch Language"),
                message: Text(vietnamese ? "Bạn có chắc chắn muốn chuyển sang Tiếng Anh không? Lịch sử chat sẽ bị xoá nếu chuyển ngôn ngữ." : "Are you sure you want to switch to Vietnamese? Chat history will be deleted if execute."),
                primaryButton: .default(Text(vietnamese ? "Chuyển" : "Switch")) {
                    // Trigger language switch and delete chat history
                    chatService.deleteChatHistory { success in
                        if success {
                            vietnamese.toggle()  // Switch language after deletion
                        } else {
                            print("Failed to delete chat history.")
                        }
                    }
                },
                secondaryButton: .cancel(Text(vietnamese ? "Hủy" : "Cancel"))
            )
        }
    }

    private func darkModeToggle() -> some View {
        Toggle(isOn: $isDark) {
            Text(!vietnamese ? "Dark Mode" : "Chế độ tối")
                .font(.subheadline)
                .foregroundColor(Color("TextColor"))
        }
        .toggleStyle(SwitchToggleStyle(tint: .green))
    }


    
    // Function to determine the color based on mood
    private func moodColor(for mood: Double) -> Color {
        switch mood {
        case _ where mood < 0:
            return Color.red // Unhappy mood
        case 0..<2:
            return Color.orange // Neutral mood
        case 2..<5:
            return Color.yellow // Positive mood
        default:
            return Color.green // Very happy mood
        }
    }

    


    
    private func moodGauge() -> some View {
        VStack {
            Text(!vietnamese ? "How are you feeling?" : "Bạn đang cảm thấy thế nào?")
            Text(overallMood < 0 ? "🙁" : overallMood < 5 ? "😐" : "😊")
            
            // Display the total mood score
            Text("\(!vietnamese ? "Total Mood Score" : "Điểm tâm trạng"): \(String(format: "%.1f", overallMood))")
                .foregroundColor(Color("TextColor"))
                .font(.headline)
                .padding(.top)
            
            // Add a bar gauge to visualize overall mood
            ProgressView(value: (overallMood + 1) / 2, total: 5) // Normalize to 0-1 range
                .progressViewStyle(LinearProgressViewStyle(tint: moodColor(for: overallMood)))
                .frame(height: 20)
                .padding(.top)
        }
    }
    
    private func resetMoodScoreButton() -> some View {
        Button {

            moodService.resetMoodScore { success in
                if success {
                    overallMood = 0.0 
                } else {
                    print("Failed to reset mood score.")
                }
            }
        } label: {
            Text(!vietnamese ? "Reset Mood Score" : "Đặt lại điểm tâm trạng")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }


    
    private func signOutButton() -> some View {
        Button {
            viewModel.signOut()
        } label: {
            Text(!vietnamese ? "Sign Out" : "Đăng xuất")
                .font(.subheadline)
                .foregroundColor(Color("TextColor"))
        }
    }
    

}


#Preview {
    ProfileView()
}
