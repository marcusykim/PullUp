import Foundation

/// Represents a car in the PullUp app.
struct Car: Codable, Identifiable {
    let id: UUID
    let make: String
    let model: String
    let year: Int?
    let mods: String? // Comma-separated for MVP, but could be [Modifier] in future
    let photo_url: String?
    let owner_id: UUID?
    // let modifierIDs: [UUID]? // Uncomment for future extensibility
} 