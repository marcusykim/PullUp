import Foundation

/// Global app configuration for PullUp.
struct AppConfig {
    /// Set to true for demo mode (uses dummy data), false for live Supabase.
    static let isDemoMode = true // Set to false to use Supabase
    static let demoUserID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    // static let environment: String = "development" // For future use
} 