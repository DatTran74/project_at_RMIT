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

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

struct ChatDocument: Codable {
    let createTime: Timestamp
    let prompt: String
    let response: String?
    let status: Status
    
    struct Status: Codable {
        let startTime: Timestamp?
        let completeTime: Timestamp?
        let updateTime: Timestamp
        let state: String
        let error: String?
        
        var chatState: ChatState {
            return ChatState(rawValue: state) ?? .PROCESSING
        }
    }
}

enum ChatState: String, Codable {
    case COMPLETED
    case ERROR
    case PROCESSING
}

struct Chat: Hashable {
    private(set) var id: UUID = .init()
    var text: String?
    var isUser: Bool
    var state: ChatState = .PROCESSING
    var message: String {
        switch state {
        case .COMPLETED:
            return text ?? ""
        case .ERROR:
            return "Something went wrong. Please try again."
        case .PROCESSING:
            return "..."
        }
    }
}
