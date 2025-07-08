import SwiftUI

struct SwipeView: View {
    @StateObject var viewModel = SwipeViewModel()
    var currentUserID: UUID
    var onMatch: (User) -> Void
    var onFilters: () -> Void
    var onBack: (() -> Void)? = nil // Optional back action for navigation
    @GestureState private var dragOffset: CGSize = .zero
    @State private var animateCard: Bool = false
    @State private var cardRemoval: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if let user = viewModel.currentUser {
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            // Profile image full width
                            AsyncImage(url: URL(string: user.photo_url ?? "")) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: geo.size.width, height: geo.size.height * 0.55)
                            .clipped()
                            .cornerRadius(28)
                            .shadow(radius: 12)
                            // Overlay: back button
                            HStack {
                                if let onBack = onBack {
                                    Button(action: onBack) {
                                        Image(systemName: "chevron.left")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(Color.black.opacity(0.4))
                                            .clipShape(Circle())
                                    }
                                    .padding(.leading, 12)
                                    .padding(.top, 12)
                                }
                                Spacer()
                            }
                            // Overlay: user info
                            VStack(alignment: .leading, spacing: 4) {
                                Spacer()
                                Text("\(user.username), \(user.age ?? 0)")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(radius: 4)
                                Text("\(user.race_preferences ?? "") – \(user.location_tag ?? "")")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.85))
                                    .shadow(radius: 2)
                            }
                            .padding(.leading, 24)
                            .padding(.bottom, 36)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        }
                        // Car card
                        if let car = demoCarForUser(user: user) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(.systemGray6).opacity(0.97))
                                    .shadow(radius: 12)
                                VStack(spacing: 0) {
                                    AsyncImage(url: URL(string: car.photo_url ?? "")) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(height: 120)
                                    .clipped()
                                    .cornerRadius(24, corners: [.topLeft, .topRight])
                                    HStack {
                                        Text("\(car.make) \(car.model)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Spacer()
                                        if let year = car.year {
                                            Text("\(year)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding([.horizontal, .top], 16)
                                    .padding(.bottom, 10)
                                }
                            }
                            .frame(height: 170)
                            .padding(.horizontal, 24)
                            .padding(.top, -36)
                        }
                        Spacer()
                        // Buttons
                        HStack(spacing: 60) {
                            Button(action: {
                                withAnimation {
                                    animateCard = true
                                    cardRemoval = -1
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    viewModel.dislikeUser()
                                    animateCard = false
                                    cardRemoval = 0
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 80, height: 80)
                                        .shadow(radius: 8)
                                    Image(systemName: "xmark")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            Button(action: {
                                withAnimation {
                                    animateCard = true
                                    cardRemoval = 1
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    Task { await viewModel.likeUser(user, currentUserID: currentUserID); onMatch(user) }
                                    animateCard = false
                                    cardRemoval = 0
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.teal)
                                        .frame(width: 80, height: 80)
                                        .shadow(radius: 8)
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.vertical, 32)
                    }
                    .offset(x: animateCard ? cardRemoval * geo.size.width * 1.2 : dragOffset.width)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                if value.translation.width < -100 {
                                    // Swipe left
                                    withAnimation {
                                        animateCard = true
                                        cardRemoval = -1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        viewModel.dislikeUser()
                                        animateCard = false
                                        cardRemoval = 0
                                    }
                                } else if value.translation.width > 100 {
                                    // Swipe right
                                    withAnimation {
                                        animateCard = true
                                        cardRemoval = 1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        Task { await viewModel.likeUser(user, currentUserID: currentUserID); onMatch(user) }
                                        animateCard = false
                                        cardRemoval = 0
                                    }
                                }
                            }
                    )
                }
            } else {
                VStack {
                    Spacer()
                    Text("No more users")
                        .foregroundColor(.white)
                        .font(.title2)
                    Spacer()
                }
            }
            // Filters button (floating)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: onFilters) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.teal)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear {
            Task { await viewModel.loadUsers() }
        }
    }

    // Demo: Return a car for the user (replace with real lookup in production)
    func demoCarForUser(user: User) -> Car? {
        // For demo, return a static car for Carla and John
        if user.username == "Carla" {
            return Car(id: UUID(), make: "Ford", model: "Mustang", year: 2020, mods: "Turbo, Exhaust", photo_url: "https://images.pexels.com/photos/358070/pexels-photo-358070.jpeg", owner_id: user.id)
        } else if user.username == "John" {
            return Car(id: UUID(), make: "BMW", model: "M3", year: 2018, mods: "Lowered, Intake", photo_url: "https://images.pexels.com/photos/170782/pexels-photo-170782.jpeg", owner_id: user.id)
        }
        return nil
    }
}

// Helper for corner radius on specific corners
fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
