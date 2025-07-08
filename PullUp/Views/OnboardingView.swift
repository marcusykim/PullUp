import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    var onComplete: () -> Void
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Create Your Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 32)
                Group {
                    TextField("Username", text: $viewModel.username)
                    TextField("Age", text: $viewModel.age)
                        .keyboardType(.numberPad)
                    TextField("Location", text: $viewModel.locationTag)
                    TextField("Race Preferences (comma separated)", text: $viewModel.racePreferences)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                VStack {
                    Text("Profile Photo")
                        .foregroundColor(.white)
                    if let image = viewModel.userPhoto {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    } else {
                        Button("Select Photo") {
                            // Use PHPicker or UIImagePickerController in real app
                        }
                        .foregroundColor(.teal)
                    }
                }
                Group {
                    TextField("Car Make", text: $viewModel.carMake)
                    TextField("Car Model", text: $viewModel.carModel)
                    TextField("Car Year", text: $viewModel.carYear)
                        .keyboardType(.numberPad)
                    TextField("Car Mods (comma separated)", text: $viewModel.carMods)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                VStack {
                    Text("Car Photo")
                        .foregroundColor(.white)
                    if let image = viewModel.carPhoto {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 8)
                    } else {
                        Button("Select Photo") {
                            // Use PHPicker or UIImagePickerController in real app
                        }
                        .foregroundColor(.teal)
                    }
                }
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                Button(action: {
                    Task {
                        await viewModel.createProfile()
                        if viewModel.errorMessage == nil {
                            onComplete()
                        }
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal)
                            .cornerRadius(12)
                    } else {
                        Text("Create Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
} 