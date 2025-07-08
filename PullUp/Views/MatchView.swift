import SwiftUI

struct MatchView: View {
    var matchedUser: User
    var onSendMessage: () -> Void
    var onKeepSwiping: () -> Void
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("It's a Match!")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 16)
            Text("You and \(matchedUser.username) have liked each other.")
                .font(.headline)
                .foregroundColor(.white.opacity(0.85))
                .padding(.bottom, 8)
            AsyncImage(url: URL(string: matchedUser.photo_url ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 220, height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(radius: 14)
            Spacer()
            VStack(spacing: 16) {
                Button(action: onSendMessage) {
                    Text("SEND MESSAGE")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal)
                        .cornerRadius(16)
                }
                Button(action: onKeepSwiping) {
                    Text("KEEP SWIPING")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color.black.ignoresSafeArea())
    }
}
