import SwiftUI

@main
struct BirdMigrationCalendarApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        await NotificationAuthService.shared.requestAccess()
                    }
                }
        }
    }
}
