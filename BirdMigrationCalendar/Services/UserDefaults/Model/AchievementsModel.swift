struct AchievementsModel: Codable {
    var isBeginner: Bool
    var observationCount: Int
    var uniqueBirdCount: Int
    var rareBirdObserved: Bool
    var photosCount: Int
    
    init() {
        isBeginner = true
        observationCount = 0
        uniqueBirdCount = 0
        rareBirdObserved = false
        photosCount = 0
    }
}
