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

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var body: some View {
        VStack(alignment:.leading,spacing: 12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField{
                SecureField(placeholder,text: $text)
                    .font(.system(size: 14))
            }else{
                TextField(placeholder,text: $text)
                    .font(.system(size: 14))
                
            }
            Divider()
            
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder:"name@example.com")
}
