import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var age: String = ""
    @Published var locationTag: String = ""
    @Published var racePreferences: String = ""
    @Published var userPhoto: UIImage?
    @Published var carMake: String = ""
    @Published var carModel: String = ""
    @Published var carYear: String = ""
    @Published var carMods: String = ""
    @Published var carPhoto: UIImage?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    /// Create a new user and car profile, using Supabase or demo mode as appropriate.
    func createProfile() async {
        isLoading = true
        defer { isLoading = false }
        if AppConfig.isDemoMode {
            // Simulate profile creation in demo mode
            await MainActor.run {
                self.errorMessage = nil
            }
            return
        }
        do {
            // Upload user photo
            var userPhotoURL: String? = nil
            if let image = userPhoto, let data = image.jpegData(compressionQuality: 0.8) {
                let path = "user-photos/\(UUID().uuidString).jpg"
                userPhotoURL = try await SupabaseManager.shared.uploadImage(data: data, path: path, bucket: "user-photos")
            }
            // Create user
            let user = User(
                id: UUID(),
                username: username,
                age: Int(age),
                photo_url: userPhotoURL,
                location_tag: locationTag,
                race_preferences: racePreferences,
                car_id: nil
            )
            try await SupabaseManager.shared.createUser(user)
            // Upload car photo
            var carPhotoURL: String? = nil
            if let image = carPhoto, let data = image.jpegData(compressionQuality: 0.8) {
                let path = "car-photos/\(UUID().uuidString).jpg"
                carPhotoURL = try await SupabaseManager.shared.uploadImage(data: data, path: path, bucket: "car-photos")
            }
            // Create car
            let car = Car(
                id: UUID(),
                make: carMake,
                model: carModel,
                year: Int(carYear),
                mods: carMods,
                photo_url: carPhotoURL,
                owner_id: user.id
            )
            try await SupabaseManager.shared.createCar(car)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
} 