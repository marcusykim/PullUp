import Foundation

@MainActor
class SwipeViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var currentIndex: Int = 0
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    /// Load users for swiping, using Supabase or demo mode as appropriate.
    func loadUsers() async {
        isLoading = true
        defer { isLoading = false }
        if AppConfig.isDemoMode {
            self.users = [
                User(id: UUID(), username: "Carla", age: 29, photo_url: "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg", location_tag: "within 10 mi.", race_preferences: "Drag", car_id: nil),
                User(id: UUID(), username: "John", age: 32, photo_url: "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg", location_tag: "within 25 mi.", race_preferences: "Track", car_id: nil)
            ]
            self.currentIndex = 0
        } else {
            do {
                self.users = try await SupabaseManager.shared.fetchUsers()
                self.currentIndex = 0
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    var currentUser: User? {
        guard currentIndex < users.count else { return nil }
        return users[currentIndex]
    }

    /// Like a user (swipe right), creating a match if not in demo mode.
    func likeUser(_ user: User, currentUserID: UUID) async {
        if AppConfig.isDemoMode {
            nextUser()
        } else {
            do {
                try await SupabaseManager.shared.createMatch(user1ID: currentUserID, user2ID: user.id)
                nextUser()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    /// Dislike a user (swipe left).
    func dislikeUser() {
        nextUser()
    }

    private func nextUser() {
        if currentIndex < users.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = users.count // No more users
        }
    }
}
