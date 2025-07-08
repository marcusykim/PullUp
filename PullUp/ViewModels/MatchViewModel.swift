import Foundation

@MainActor
class MatchViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    /// Load matches for the current user, using Supabase or demo mode as appropriate.
    func loadMatches(for userID: UUID) async {
        isLoading = true
        defer { isLoading = false }
        if AppConfig.isDemoMode {
            let user1ID = UUID()
            let user2ID = UUID()
            let match1 = Match(id: UUID(), user1_id: userID, user2_id: user1ID, timestamp: Date().addingTimeInterval(-3600))
            let match2 = Match(id: UUID(), user1_id: userID, user2_id: user2ID, timestamp: Date().addingTimeInterval(-7200))
            self.matches = [match1, match2]
        } else {
            do {
                self.matches = try await SupabaseManager.shared.fetchMatches(for: userID)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
} 