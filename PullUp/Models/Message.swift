import Foundation

/// Represents a chat message between users in a match.
struct Message: Codable, Identifiable {
    let id: UUID
    let content: String
    let timestamp: Date
    let sender_id: UUID
    let match_id: UUID
}

struct Attachment: Codable, Identifiable {
    let id: UUID
    let url: String
    let type: String // e.g., "image", "video"
} 