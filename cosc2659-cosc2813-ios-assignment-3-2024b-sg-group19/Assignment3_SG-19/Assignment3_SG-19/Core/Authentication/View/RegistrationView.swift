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

struct RegistrationView: View {
    @AppStorage("isDark") private var isDark = false
    @AppStorage("vietnamese") private var vietnamese = false
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing : 20){
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 220)
                    .padding(.vertical, 32)
            VStack(spacing : 24){
                InputView(text: $email, title: !vietnamese ? "Email Address" : "Địa chỉ email", placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $fullname, title: !vietnamese ? "Full Name" : "Họ và tên", placeholder: !vietnamese ? "Enter your name" : "Nhập tên của bạn")
            
                InputView(text: $password, title: !vietnamese ? "Password" : "Mật khẩu", placeholder: !vietnamese ? "Enter your password" : "Nhập mật khẩu", isSecureField: true)
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword, title: !vietnamese ? "Confirm Password" : "Nhập lại mật khẩu", placeholder: !vietnamese ? "Confirm your password" : "Nhập lại mật khẩu", isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword{
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }else{
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                            
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            Button{
                Task{
                    try await viewModel.createUser(withEmail:email,password:password,fullname:fullname)
                }
            }label: {
                HStack{
                    Text(!vietnamese ? "SIGN UP" : "ĐĂNG KÍ")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))

            .cornerRadius(10)
            .padding(.top,20)
            Spacer()
            Button {
                dismiss()
            } label: {
                HStack(spacing:3){
                    Text(!vietnamese ? "Already have an account?" : "Đã có tài khoản?")
                    Text(!vietnamese ? "Sign in" : "Đăng nhập")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
                .foregroundColor(Color("TextColor"))
            }

        }
    }
}
//extension RegistrationView : AuthenicationFormProtocol{
//    var formIsValid: Bool {
//        return !email.isEmpty
//        && email.contains("@")
//        && !password.isEmpty
//        && password.count > 5
//        && !fullname.isEmpty
//        && confirmPassword == password
//        
//    }
//}

#Preview {
    RegistrationView()
}
