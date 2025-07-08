import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient

    private init() {
        let supabaseURL = Bundle.main.object(forInfoDictionaryKey: "SupabaseURL") as? String ?? ""
        let supabaseAnonKey = Bundle.main.object(forInfoDictionaryKey: "SupabaseAnonKey") as? String ?? ""
        self.client = SupabaseClient(supabaseURL: URL(string: supabaseURL)!, supabaseKey: supabaseAnonKey)
    }

    // MARK: - User APIs
    func fetchUsers() async throws -> [User] {
        if AppConfig.isDemoMode {
            return []
        } else {
            let response = try await client.database.from("users").select().execute()
            let data = response.data
            let users = try JSONDecoder().decode([User].self, from: JSONSerialization.data(withJSONObject: data))
            return users
        }
    }

    func createUser(_ user: User) async throws {
        if AppConfig.isDemoMode {
            return
        } else {
            let _ = try await client.database.from("users").insert([user]).execute()
        }
    }

    // MARK: - Car APIs
    func fetchCars(for userID: UUID) async throws -> [Car] {
        if AppConfig.isDemoMode {
            return []
        } else {
            let response = try await client.database.from("cars").select().eq("owner_id", value: userID.uuidString).execute()
            let data = response.data
            let cars = try JSONDecoder().decode([Car].self, from: JSONSerialization.data(withJSONObject: data))
            return cars
        }
    }

    func createCar(_ car: Car) async throws {
        if AppConfig.isDemoMode {
            return
        } else {
            let _ = try await client.database.from("cars").insert([car]).execute()
        }
    }

    // MARK: - Match APIs
    func fetchMatches(for userID: UUID) async throws -> [Match] {
        if AppConfig.isDemoMode {
            return []
        } else {
            let response = try await client.database.from("matches")
                .select()
                .or("user1_id.eq.\(userID.uuidString),user2_id.eq.\(userID.uuidString)")
                .execute()
            let data = response.data
            let matches = try JSONDecoder().decode([Match].self, from: JSONSerialization.data(withJSONObject: data))
            return matches
        }
    }

    func createMatch(user1ID: UUID, user2ID: UUID) async throws {
        if AppConfig.isDemoMode {
            return
        } else {
            let _ = try await client.database.from("matches").insert([
                ["user1_id": user1ID.uuidString, "user2_id": user2ID.uuidString]
            ]).execute()
        }
    }

    // MARK: - Message APIs
    func fetchMessages(matchID: UUID) async throws -> [Message] {
        if AppConfig.isDemoMode {
            return []
        } else {
            let response = try await client.database.from("messages")
                .select()
                .eq("match_id", value: matchID.uuidString)
                .order("timestamp", ascending: true)
                .execute()
            let data = response.data
            let messages = try JSONDecoder().decode([Message].self, from: JSONSerialization.data(withJSONObject: data))
            return messages
        }
    }

    func sendMessage(matchID: UUID, senderID: UUID, content: String) async throws {
        if AppConfig.isDemoMode {
            return
        } else {
            let _ = try await client.database.from("messages").insert([
                ["match_id": matchID.uuidString, "sender_id": senderID.uuidString, "content": content]
            ]).execute()
        }
    }

    // MARK: - Image Upload/Download
    func uploadImage(data: Data, path: String, bucket: String) async throws -> String {
        if AppConfig.isDemoMode {
            return ""
        } else {
            let _ = try await client.storage.from(bucket).upload(
                path: path,
                file: data
            )
            // TODO: Construct public URL as needed for your Supabase project
            return "https://YOUR_PROJECT.supabase.co/storage/v1/object/public/\(bucket)/\(path)"
        }
    }

    // MARK: - Moderation APIs
    /// Report a user for inappropriate behavior.
    func reportUser(reporterID: UUID, reportedUserID: UUID, reason: String) async throws {
        if AppConfig.isDemoMode {
            return
        } else {
            // Implement Supabase call to insert into reports table
        }
    }

    /// Block a user.
    func blockUser(blockerID: UUID, blockedUserID: UUID) async throws {
        if AppConfig.isDemoMode {
            return
        } else {
            // Implement Supabase call to insert into blocks table
        }
    }
} 
