enum SettingsRow: Identifiable, CaseIterable {
    var id: Self { self }
    
    case about
    case notification
    case history
    
    var title: String {
        switch self {
            case .about:
                "About the application"
            case .notification:
                "Notification"
            case .history:
                "Clear history"
        }
    }
}
