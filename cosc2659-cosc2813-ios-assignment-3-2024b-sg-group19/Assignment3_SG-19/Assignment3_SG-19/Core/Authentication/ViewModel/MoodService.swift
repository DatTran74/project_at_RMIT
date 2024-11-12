
/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Authors: Tran Xuan Hoang Dat, Tran Vinh Trong, Nguyen Huy Anh, Nguyen The Anh
  ID: s3651550, s3863973, s3956092, s3927195
  Created date: 20/09/2024
  Last modified: 22/09/2024
  Acknowledgement: https://github.com/TomHuynhSG/Movie-List-Firestore-iOS-Firebase
*/

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MoodService: ObservableObject {
    @Published var moodScore: Double = 0.0
    private var listener: ListenerRegistration?
    private var db = Firestore.firestore()
    
    // Mood detection logic based on keywords
    func detectMood(from message: String) -> Double {


        let positiveKeywords = [
            "happy", "well", "good", "great", "fantastic",
            "vui", "khoẻ", "tốt", "tuyệt", "hạnh phúc"
        ]
        let negativeKeywords = [
            "sad", "bad", "unhappy", "terrible", "awful",
            "buồn", "tệ", "tồi", "đau buồn", "tuyệt vọng"
        ]
        let neutralPositiveKeywords = [
            "okay", "fine", "alright", "decent", "manageable",
            "ổn", "thường", "khá tốt", "bình thường", "ổn thôi"
        ]
        let neutralNegativeKeywords = [
            "meh", "not great", "not bad", "so-so", "indifferent",
            "không tốt", "bình bình", "không có gì đặc biệt", "nhạt nhẽo", "không hài lòng"
        ]


        let lowercasedMessage = message.lowercased()
        
        for keyword in positiveKeywords {
            if lowercasedMessage.contains(keyword) {
                return 1.0 // Positive mood
            }
        }
        
        for keyword in negativeKeywords {
            if lowercasedMessage.contains(keyword) {
                return -1.0 // Negative mood
            }
        }
        
        for keyword in neutralPositiveKeywords {
            if lowercasedMessage.contains(keyword) {
                return 0.5 // Neutral positive mood
            }
        }
        
        for keyword in neutralNegativeKeywords {
            if lowercasedMessage.contains(keyword) {
                return -0.5 // Neutral negative mood
            }
        }
        
        return 0.0 // Neutral mood if no keywords match
    }
    
    // Store mood score in Firebase
    func storeMoodScore(_ score: Double, in db: Firestore) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let moodData: [String: Any] = [
            "score": score,
            "timestamp": Timestamp(),
            "userID": userID
        ]
        
        db.collection("moods").addDocument(data: moodData) { error in
            if let error = error {
                print("Error storing mood score: \(error.localizedDescription)")
            } else {
                print("Mood score successfully stored.")
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
                print("Error resetting mood scores: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            
            for document in snapshot?.documents ?? [] {
                document.reference.delete()
            }
            
     
            let moodData: [String: Any] = [
                "score": 0.0,
                "timestamp": Timestamp(),
                "userID": userID
            ]
            self.db.collection("moods").addDocument(data: moodData) { error in
                if let error = error {
                    print("Error resetting mood score: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Mood score reset to 0 successfully.")
                    completion(true)
                }
            }
        }
    }


    
    // Retrieve and sum all mood scores for the current user
    func fetchTotalMoodScore(completion: @escaping (Double) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            completion(0.0)
            return
        }
        
        db.collection("moods").whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching mood scores: \(error.localizedDescription)")
                completion(0.0)
            } else {
                var totalMoodScore: Double = 0.0
                
                for document in snapshot?.documents ?? [] {
                    if let score = document.data()["score"] as? Double {
                        totalMoodScore += score
                    }
                }
                
                // Clamp the totalMoodScore to the range [0, 10]
                totalMoodScore = min(max(totalMoodScore, 0.0), 10.0)
                completion(totalMoodScore)
            }
        }
    }

}

