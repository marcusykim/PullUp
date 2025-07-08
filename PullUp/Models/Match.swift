import Foundation

/// Represents a match between two users in the PullUp app.
struct Match: Codable, Identifiable {
    let id: UUID
    let user1_id: UUID
    let user2_id: UUID
    let timestamp: Date
} 