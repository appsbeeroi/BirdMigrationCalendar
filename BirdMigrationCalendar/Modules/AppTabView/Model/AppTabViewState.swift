import UIKit

enum AppTabViewState: Identifiable, CaseIterable {
    var id: Self { self }
    
    case calendar
    case logbook
    case statistics
    case map
    case achievements
    
    var icon: ImageResource {
        switch self {
            case .calendar:
                    .Icons.calendar
            case .logbook:
                    .Icons.logbook
            case .statistics:
                    .Icons.statistics
            case .map:
                    .Icons.map
            case .achievements:
                    .Icons.achievementsIcon
        }
    }
}
