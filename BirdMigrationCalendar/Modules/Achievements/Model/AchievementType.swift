import UIKit

enum AchievementType: String, Identifiable, CaseIterable, Hashable {
    var id: Self {
        self
    }
    
    case beginner
    case observations
    case differentSpecies
    case rareGuest
    case photoprapher
    
    var title: String {
        switch self {
            case .beginner:
                "Beginner"
            case .observations:
                "10 Observations"
            case .differentSpecies:
                "5 Different Species"
            case .rareGuest:
                "Rare Guest"
            case .photoprapher:
                "Photographer"
        }
    }
    
    var description: String {
        switch self {
            case .beginner:
                "Logged your first observed bird"
            case .observations:
                "Added 10 entries to your journal"
            case .differentSpecies:
                "Recorded 5 unique bird species"
            case .rareGuest:
                "Observed a rare bird species"
            case .photoprapher:
                "Added 10 photos to your journal"
        }
    }
    
    var icon: ImageResource {
        switch self {
            case .beginner:
                    .Icons.Achievements.beginner
            case .observations:
                    .Icons.Achievements.observations
            case .differentSpecies:
                    .Icons.Achievements.differentSpecies
            case .rareGuest:
                    .Icons.Achievements.guest
            case .photoprapher:
                    .Icons.Achievements.photographer
        }
    }
}
