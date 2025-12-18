import Foundation

final class AchievementsViewModel: ObservableObject {
    
    private let storage = PreferencesStorage.shared
    
    @Published var navigationPath: [AchievementsScreen] = []
    @Published var selectedPeriodType: ChallengeType = .weekly
    @Published private(set) var achievements = AchievementsModel()
    
    func load() {
        Task {
            if let achievement = await storage.retrieve(AchievementsModel.self, for: .achievements) {
                
                await MainActor.run {
                    self.achievements = achievement
                }
            }
        }
    }
}
