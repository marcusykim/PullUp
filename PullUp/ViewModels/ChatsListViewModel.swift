import Foundation

struct ChatPreview: Identifiable {
    let id: UUID
    let otherUser: User
    let latestMessage: Message?
    let match: Match
}

@MainActor
class ChatsListViewModel: ObservableObject {
    @Published var chatPreviews: [ChatPreview] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    /// Load chat previews for the current user, using Supabase or demo mode as appropriate.
    func loadChats(for userID: UUID) async {
        isLoading = true
        defer { isLoading = false }
        if AppConfig.isDemoMode {
            let user1 = User(id: UUID(), username: "Carla", age: 29, photo_url: "https://randomuser.me/api/portraits/women/44.jpg", location_tag: "within 10 mi.", race_preferences: "Drag", car_id: nil)
            let user2 = User(id: UUID(), username: "John", age: 32, photo_url: "https://randomuser.me/api/portraits/men/32.jpg", location_tag: "within 25 mi.", race_preferences: "Track", car_id: nil)
            let match1 = Match(id: UUID(), user1_id: userID, user2_id: user1.id, timestamp: Date().addingTimeInterval(-3600))
            let match2 = Match(id: UUID(), user1_id: userID, user2_id: user2.id, timestamp: Date().addingTimeInterval(-7200))
            let message1 = Message(id: UUID(), content: "Hey, want to race?", timestamp: Date().addingTimeInterval(-3500), sender_id: user1.id, match_id: match1.id)
            let message2 = Message(id: UUID(), content: "Sure, let's do it!", timestamp: Date().addingTimeInterval(-3400), sender_id: userID, match_id: match1.id)
            let message3 = Message(id: UUID(), content: "Ready for the track?", timestamp: Date().addingTimeInterval(-7100), sender_id: user2.id, match_id: match2.id)
            self.chatPreviews = [
                ChatPreview(id: match1.id, otherUser: user1, latestMessage: message2, match: match1),
                ChatPreview(id: match2.id, otherUser: user2, latestMessage: message3, match: match2)
            ]
        }
        // When ready for Supabase, restore the else block here.
    }
} 
