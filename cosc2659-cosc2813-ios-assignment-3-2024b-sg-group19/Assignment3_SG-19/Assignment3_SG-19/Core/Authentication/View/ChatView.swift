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

struct ChatView: View {
    @AppStorage("isDark") private var isDark = false
    @State private var textInput = ""
    @StateObject private var chatService = ChatService()
    @State private var scrollToBottomProxy: ScrollViewProxy? // Proxy reference
    
    var body: some View {
        VStack {
            titleView()
            chatListView()
            inputView()
        }
        .padding()
        .background(Color("AccentColor").ignoresSafeArea())
        .overlay(scrollToBottomButton(), alignment: .top)
        .onAppear {
            chatService.resetGreeting()
            chatService.fetchMessages()
        }
    }
    
    // MARK: Title view
    @ViewBuilder private func titleView() -> some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                SettingRowView(imageName: "person", title: "Chat Bot", tintColor: Color("TextColor"), textColor: Color("TextColor"))
            }
            .frame(height: 50)
        }
    }
    
    // MARK: Chat list view
    @ViewBuilder private func chatListView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ForEach(chatService.messages, id: \.id) { chatMessage in
                        chatMessageView(chatMessage)
                            .id(chatMessage.id)
                    }
                }
            }
            .onAppear {
                scrollToBottomProxy = proxy // Store the proxy reference
            }

            .onChange(of: chatService.messages) {
                if let lastMessage = chatService.messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }


        }
    }
    
    // MARK: Chat message view
    @ViewBuilder
    private func chatMessageView(_ chat: Chat) -> some View {
        ChatBubble(direction: chat.isUser ? .right : .left) {
            Text(chat.message)
                .font(.title3)
                .padding(.all, 20)
                .foregroundStyle(.white)
                .background {
                    chat.isUser ? Color.blue : Color.green
                }
        }
    }
    
    // MARK: Send message
    private func sendMessage() {
        chatService.sendMessage(textInput)
        textInput = ""
    }
    
    // MARK: Input view
    @ViewBuilder private func inputView() -> some View {
        HStack {
            TextField("Enter a message...", text: $textInput)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(Color("TextColor"))
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
            }
        }
    }
    
    // MARK: Scroll to Bottom Button
    @ViewBuilder private func scrollToBottomButton() -> some View {
        Button(action: {
            if let lastMessage = chatService.messages.last, let proxy = scrollToBottomProxy {
                withAnimation {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }) {
            Image(systemName: "chevron.down")
                .resizable()
                .scaledToFit() // Ensures the image maintains its aspect ratio
                .frame(width: 30, height: 30) // Set a fixed size for the image
                .foregroundColor(.blue)
                .padding()
        }
        .padding()


        .padding()
    }
}

#Preview {
    ChatView()
}
