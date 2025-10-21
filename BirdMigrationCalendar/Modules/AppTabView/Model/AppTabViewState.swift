enum AppTabViewState: Identifiable, CaseIterable {
    var id: Self { self }
    
    case calendar
    case logbook
    case statistics
    case settings
    
    var icon: ImageResource {
        switch self {
            case .calendar:
                    .Icons.calendar
            case .logbook:
                    .Icons.logbook
            case .statistics:
                    .Icons.statistics
            case .settings:
                    .Icons.settings
        }
    }
}
