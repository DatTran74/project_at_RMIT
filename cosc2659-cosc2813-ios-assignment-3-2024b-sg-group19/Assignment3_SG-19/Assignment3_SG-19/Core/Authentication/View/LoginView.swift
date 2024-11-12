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

struct LoginView: View {
    @AppStorage("isDark") private var isDark = false
    @AppStorage("vietnamese") private var vietnamese = false
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        NavigationStack{
            VStack{
                //image
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 220)
                    .padding(.vertical, 32)
                VStack(spacing : 24){
                    InputView(text:$email, title: !vietnamese ? "Email Address" : "Địa chỉ email", placeholder : "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: !vietnamese ? "Password" : "Mật khẩu", placeholder: !vietnamese ? "Enter your password" : "Nhập mật khẩu của bạn" , isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                Button{
                    Task{
                        try await viewModel.signIn(withEmail:email,password:password)
                    }
                }label: {
                    HStack{
                        Text(!vietnamese ? "SIGN IN" : "ĐĂNG NHẬP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
//                .disabled(formIsValid)
//                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top,24)
                
                Spacer()
                NavigationLink{
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                    
                } label: {
                    HStack(spacing:3){
                        Text(!vietnamese ? "Don't have an account?" : "Không có tài khoản?")
                        Text(!vietnamese ? "Sign Up" : "Đăng kí")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextColor"))
                }
            }
        }
    }
}
//extension LoginView : AuthenicationFormProtocol{
//    var formIsValid: Bool {
//        return !email.isEmpty
//        && email.contains("@")
//        && !password.isEmpty
//        && password.count > 5
//    }
//}

#Preview {
    LoginView()
}
