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

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
    

    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        self.currentUser = try? snapshot?.data(as: User.self)
    }
    
    // MARK: Delete Account and All Data
    func deleteAccountAndData() async throws {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid

        do {
        
            let db = Firestore.firestore()
            try await db.collection("users").document(userID).delete()

            let moodQuery = db.collection("moods").whereField("userID", isEqualTo: userID)
            let moodDocuments = try await moodQuery.getDocuments()
            for document in moodDocuments.documents {
                try await document.reference.delete()
            }

            try await user.delete()

            self.userSession = nil
            self.currentUser = nil

        } catch {
            throw error
        }
    }

    
    func listenForMoodScoreUpdates(completion: @escaping (Double) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("moods")
            .whereField("userID", isEqualTo: uid)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    completion(0.0)
                    return
                }
                let moodScores = documents.compactMap { $0.data()["score"] as? Double }
                let overallMood = moodScores.isEmpty ? 0.0 : moodScores.reduce(0, +) / Double(moodScores.count)
                completion(overallMood)
            }
    }
}
