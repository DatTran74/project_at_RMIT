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

struct SettingRowView: View {
    let imageName:String
    let title:String
    let tintColor: Color
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
//                .imageScale(.small)
//                .font(.title)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(textColor)
        }
    }
}

#Preview {
    Section("Settings") {
        SettingRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray), textColor: Color(.systemGray))
        SettingRowView(imageName: "moon.fill", title: "Version", tintColor: Color(.systemGray), textColor: Color(.systemGray))
        SettingRowView(imageName: "abc", title: "Version", tintColor: Color(.systemGray), textColor: Color(.systemGray))
    }
}
