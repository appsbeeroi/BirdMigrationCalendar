import UserNotifications

enum NotificationAuthStatus {
    case granted
    case denied
    case notDetermined
}

final class NotificationAuthService {
    
    static let shared = NotificationAuthService()
    
    private init() {}
        
    var status: NotificationAuthStatus {
        get async {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                return .granted
            case .denied:
                return .denied
            case .notDetermined:
                return .notDetermined
            default:
                return .denied
            }
        }
    }
        
    @discardableResult
    func requestAccess() async -> Bool {
        let center = UNUserNotificationCenter.current()
        
        do {
            let isGranted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return isGranted
        } catch {
            print("⚠️ Notification permission request failed:", error.localizedDescription)
            return false
        }
    }
}
