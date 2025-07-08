import Foundation
import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var user: User?
    @Published var errorMessage: String?

    func signUp(email: String, password: String) async {
        do {
            let response = try await SupabaseManager.shared.client.auth.signUp(email: email, password: password)
            self.session = response.session
            // Fetch user profile if needed
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        do {
            let response = try await SupabaseManager.shared.client.auth.signIn(email: email, password: password)
            self.session = response
            // Fetch user profile if needed
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signOut() async {
        do {
            try await SupabaseManager.shared.client.auth.signOut()
            self.session = nil
            self.user = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
} 
