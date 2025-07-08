import SwiftUI

struct SplashView: View {
    var onGetStarted: () -> Void
    var body: some View {
        VStack(spacing: 40) {
            Image("car_logo") // Use custom car icon asset if available
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding(.top, 100)
            Spacer()
            Text("Swipe.\nMatch.\nRace.")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Spacer()
            Button(action: onGetStarted) {
                Text("GET STARTED")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
        .background(Color.black.ignoresSafeArea())
    }
}
