/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Xuan Hoang Dat
  ID:s3651550
  Created  date: 13/9/2024
  Last modified: 17/9/2024
  Acknowledgement: Acknowledge the resources that you use here.
*/

import Foundation

struct User: Identifiable,Codable{
    let id: String
    let fullname:String
    let email: String
    
    var initials :String{
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
          return""
    }
}
extension User{
    static var MOCK_USER = User(id:NSUUID().uuidString,fullname: "Hoang Dat",email: "test@gmail.com")
}
