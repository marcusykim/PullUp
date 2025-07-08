import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    /// Load messages for a match, using Supabase or demo mode as appropriate.
    func loadMessages(matchID: UUID) async {
        isLoading = true
        defer { isLoading = false }
        if AppConfig.isDemoMode {
            // Dummy messages for demo
            let user1ID = UUID()
            let user2ID = UUID()
            self.messages = [
                Message(id: UUID(), content: "Hey, want to race?", timestamp: Date().addingTimeInterval(-3500), sender_id: user1ID, match_id: matchID),
                Message(id: UUID(), content: "Sure, let's do it!", timestamp: Date().addingTimeInterval(-3400), sender_id: user2ID, match_id: matchID)
            ]
        } else {
            do {
                self.messages = try await SupabaseManager.shared.fetchMessages(matchID: matchID)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    /// Send a message in a match, using Supabase or demo mode as appropriate.
    func sendMessage(matchID: UUID, senderID: UUID, content: String) async {
        if AppConfig.isDemoMode {
            let newMessage = Message(id: UUID(), content: content, timestamp: Date(), sender_id: senderID, match_id: matchID)
            self.messages.append(newMessage)
        } else {
            do {
                try await SupabaseManager.shared.sendMessage(matchID: matchID, senderID: senderID, content: content)
                await loadMessages(matchID: matchID)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
} 