import Foundation
 
/// ViewModel for managing swipe filters in PullUp.
class FiltersViewModel: ObservableObject {
    @Published var selectedRaceType: String = "Drag"
    @Published var selectedCarMake: String = "Any Make"
    @Published var locationRadius: Double = 25
} 