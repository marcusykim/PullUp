import SwiftUI

struct ChatsListView: View {
    @StateObject var viewModel = ChatsListViewModel()
    var currentUserID: UUID
    var onSelect: (Match) -> Void
    var body: some View {
        VStack {
            Text("Chats")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 24)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if viewModel.chatPreviews.isEmpty {
                Text("No chats yet.")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.chatPreviews) { preview in
                            Button(action: { onSelect(preview.match) }) {
                                HStack(spacing: 16) {
                                    AsyncImage(url: URL(string: preview.otherUser.photo_url ?? "")) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 56, height: 56)
                                    .clipShape(Circle())
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(preview.otherUser.username)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(preview.latestMessage?.content ?? "No messages yet.")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    if let date = preview.latestMessage?.timestamp {
                                        Text(date, style: .time)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal)
                                .background(Color.black)
                            }
                            Divider().background(Color.gray.opacity(0.3))
                        }
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            Task { await viewModel.loadChats(for: currentUserID) }
        }
    }
} 