import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    var matchID: UUID
    var senderID: UUID
    var onBack: () -> Void
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack {
            // Header with back button
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                        Text("Back")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.sender_id == senderID {
                                    Spacer()
                                    Text(message.content)
                                        .padding(10)
                                        .background(Color.teal)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                } else {
                                    Text(message.content)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.3))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    Task {
                        await viewModel.sendMessage(matchID: matchID, senderID: senderID, content: newMessage)
                        newMessage = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.teal)
                        .padding(8)
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            Task { await viewModel.loadMessages(matchID: matchID) }
        }
    }
} 