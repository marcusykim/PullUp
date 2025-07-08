import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: FiltersViewModel
    var onApply: () -> Void
    let raceTypes = ["Drag", "Track", "Street"]
    let carMakes = ["Any Make", "BMW", "Ford"]
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("Filters")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)
            Text("Race Type")
                .font(.headline)
                .foregroundColor(.white)
            HStack(spacing: 16) {
                ForEach(raceTypes, id: \.self) { type in
                    Button(action: { viewModel.selectedRaceType = type }) {
                        Text(type)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .padding(.horizontal, 22)
                            .padding(.vertical, 10)
                            .background(viewModel.selectedRaceType == type ? Color.teal : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: viewModel.selectedRaceType == type ? Color.teal.opacity(0.3) : .clear, radius: 6, x: 0, y: 2)
                    }
                }
            }
            Text("Car Make")
                .font(.headline)
                .foregroundColor(.white)
            HStack(spacing: 16) {
                ForEach(carMakes, id: \.self) { make in
                    Button(action: { viewModel.selectedCarMake = make }) {
                        Text(make)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .padding(.horizontal, 22)
                            .padding(.vertical, 10)
                            .background(viewModel.selectedCarMake == make ? Color.teal : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: viewModel.selectedCarMake == make ? Color.teal.opacity(0.3) : .clear, radius: 6, x: 0, y: 2)
                    }
                }
            }
            Text("Location Radius")
                .font(.headline)
                .foregroundColor(.white)
            HStack {
                Slider(value: $viewModel.locationRadius, in: 1...50, step: 1)
                    .accentColor(.teal)
                Text("\(Int(viewModel.locationRadius)) mi")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            Spacer()
            Button(action: onApply) {
                Text("APPLY")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(16)
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
        .background(Color.black.ignoresSafeArea())
    }
}
