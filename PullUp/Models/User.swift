import Foundation

/// Represents a user in the PullUp app.
struct User: Codable, Identifiable {
    let id: UUID
    let username: String
    let age: Int?
    let photo_url: String?
    let location_tag: String?
    let race_preferences: String?
    let car_id: UUID?
}

/// Represents a car modifier (e.g., turbo, exhaust, etc.)
struct Modifier: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String?
}

/// Represents a report of a user for moderation.
struct Report: Codable, Identifiable {
    let id: UUID
    let reporter_id: UUID
    let reported_user_id: UUID
    let reason: String
    let timestamp: Date
}

/// Represents a block between users.
struct Block: Codable, Identifiable {
    let id: UUID
    let blocker_id: UUID
    let blocked_user_id: UUID
    let timestamp: Date
} 