/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Authors: Tran Xuan Hoang Dat, Tran Vinh Trong, Nguyen Huy Anh, Nguyen The Anh
  ID: s3651550, s3863973, s3956092, s3927195
  Created date: 17/09/2024
  Last modified: 22/09/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class ChatService: ObservableObject {
    @Published var messages: [Chat] = []
    private var db = Firestore.firestore()
    private let chatCollectionPath = "generate"
    private let greetingCollectionPath = "greetings"
    private let moodCollectionPath = "moods"
    private let greetingDocumentID = "greetingMessage"
    private var isGreetingShown = false
    private let moodService = MoodService()
    
    @AppStorage("vietnamese") private var vietnamese = false {
        didSet {
            fetchGreetingMessage()
        }
    }
    
    private var userID: String {
        return Auth.auth().currentUser?.uid ?? "Unknown User"
    }
    
    func summarizeResponse(_ response: String) -> String {
        var summary = response
        if response.count > 100 {
            DispatchQueue.global(qos: .userInitiated).async {
                let sentences = response.split(separator: ".").map { String($0) }
                summary = sentences.prefix(2).joined(separator: ". ")
            }
        }
        return summary
    }
    
    func fetchMessages(limit: Int = 20) {
        db.collection(chatCollectionPath)
            .whereField("userID", isEqualTo: userID)
            .order(by: "createTime", descending: false)
            .limit(to: limit)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                let newMessages = documents.compactMap { snapshot -> [Chat]? in
                    do {
                        let document = try snapshot.data(as: ChatDocument.self)
                        let promptChat = Chat(text: document.prompt, isUser: true, state: .COMPLETED)
                        let responseChat = Chat(text: self.summarizeResponse(document.response ?? ""), isUser: false, state: document.status.chatState)
                        return [promptChat, responseChat]
                    } catch {
                        print(error.localizedDescription)
                        return nil
                    }
                }.flatMap { $0 }
                
                DispatchQueue.main.async {
                    self.messages = newMessages // Ensure UI updates are done on main thread
                    self.fetchGreetingMessageIfNeeded() // Load greeting message if not shown
                }
            }
    }
    
    private func fetchGreetingMessageIfNeeded() {
        if !isGreetingShown {
            fetchGreetingMessage()
            isGreetingShown = true
        }
    }
    
    func resetGreeting() {
        isGreetingShown = false
    }
    
    func sendMessage(_ message: String) {
        let moodScore = moodService.detectMood(from: message)
        moodService.storeMoodScore(moodScore, in: db)
        
        let placeholderMessages = [Chat(text: message, isUser: true, state: .COMPLETED), Chat(text: "", isUser: false)]
        messages.append(contentsOf: placeholderMessages)
        
        let chatData: [String: Any] = [
            "prompt": message,
            "moodScore": moodScore,
            "userID": userID,
            "createTime": Timestamp()
        ]
        
        db.collection(chatCollectionPath).addDocument(data: chatData)
    }
    
    func fetchGreetingMessage() {
        db.collection(greetingCollectionPath)
            .document(userID)
            .getDocument { [weak self] documentSnapshot, error in
                if let error = error {
                    print("Error fetching greeting: \(error.localizedDescription)")
                    return
                }
                
                if let document = documentSnapshot, document.exists {
                    let storedGreeting = document.data()?["prompt"] as? String ?? "Hello!"
                    let correctGreeting = !self!.vietnamese ? "Hello, how are you feeling now?" : "Xin chào, bạn đang cảm thấy thế nào?"
                    
                    if storedGreeting != correctGreeting {
                        self?.storeGreetingMessage()
                    } else {
                        self?.insertGreetingMessage(storedGreeting)
                    }
                } else {
                    self?.storeGreetingMessage()
                }
            }
    }
    
    private func storeGreetingMessage() {
        let greetingText = !vietnamese ? "Hello, how are you feeling now?" : "Xin chào, bạn đang cảm thấy thế nào?"
        let greetingData: [String: Any] = [
            "prompt": greetingText,
            "createdTime": Timestamp(),
            "mood": NSNull(),
            "userID": userID
        ]
        
        db.collection(greetingCollectionPath)
            .document(userID)
            .setData(greetingData) { error in
                if let error = error {
                    print("Error storing greeting message: \(error.localizedDescription)")
                } else {
                    print("Greeting message successfully stored.")
                    self.insertGreetingMessage(greetingText)
                }
            }
    }
    
    private func insertGreetingMessage(_ greeting: String) {
        let greetingMessage = Chat(text: greeting, isUser: false, state: .COMPLETED)
        DispatchQueue.main.async {
            if self.messages.first(where: { $0.message == greetingMessage.message }) == nil {
                self.messages.insert(greetingMessage, at: 0)
            }
        }
    }
    
    func listenForResponse(documentID: String) {
        let docRef = db.collection(chatCollectionPath).document(documentID)
        docRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error listening for document updates: \(error.localizedDescription)")
            } else if let document = documentSnapshot, document.exists {
                if let response = document["response"] as? String {
                    let prompt = document["prompt"] as? String ?? ""
                    
                    let promptChat = Chat(text: prompt, isUser: true, state: .COMPLETED)
                    let responseChat = Chat(text: response, isUser: false, state: .COMPLETED)
                    
                    DispatchQueue.main.async {
                        self.messages.append(promptChat)
                        self.messages.append(responseChat)
                    }
                }
            }
        }
    }
    
    func fetchMoodScore(completion: @escaping (Double) -> Void) {
        db.collection(moodCollectionPath)
            .whereField("userID", isEqualTo: userID) // Filter based on userID
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching mood scores: \(error?.localizedDescription ?? "Unknown error")")
                    completion(0.0) // Return 0 if there's an error
                    return
                }
                
                let moodScores = documents.compactMap { $0.data()["score"] as? Double }
                let overallMood = moodScores.isEmpty ? 0.0 : moodScores.reduce(0, +) / Double(moodScores.count)
                completion(overallMood)
            }
    }
    func deleteChatHistory(completion: @escaping (Bool) -> Void) {
        db.collection(chatCollectionPath)
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching chat history: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                    return
                }
                
                let batch = self.db.batch()
                for document in documents {
                    batch.deleteDocument(document.reference)
                }
                
                batch.commit { error in
                    if let error = error {
                        print("Error deleting chat history: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Chat history successfully deleted.")
                        self.messages.removeAll() // Clear the local messages as well
                        completion(true)
                    }
                }
            }
    }
}
