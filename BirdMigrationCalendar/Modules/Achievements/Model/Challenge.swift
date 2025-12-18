enum Challenge: Identifiable, CaseIterable, Hashable {
    var id: Self {
        self
    }
    
    case findAStarling
    case spotARobin
    case recordThreeDifferentBirds
    case takePhotoOfAnyBird
    case spotFirstSpringSwallows
    case observeReturningMigratoryBirds
    case identifyNestingBird
    case noticeEarlyBloomingFlowersAndBirds
    
    var type: ChallengeType {
        switch self {
            case .findAStarling, .spotARobin, .recordThreeDifferentBirds, .takePhotoOfAnyBird:
                return .weekly
            case .spotFirstSpringSwallows, .observeReturningMigratoryBirds, .identifyNestingBird, .noticeEarlyBloomingFlowersAndBirds:
                return .seasonal
        }
    }
    
    var title: String {
        switch self {
            case .findAStarling: return "Find a Starling this week"
            case .spotARobin: return "Spot a Robin"
            case .recordThreeDifferentBirds: return "Record 3 different birds"
            case .takePhotoOfAnyBird: return "Take a photo of any bird"
            case .spotFirstSpringSwallows: return "Spot the first spring Swallows"
            case .observeReturningMigratoryBirds: return "Observe returning migratory birds"
            case .identifyNestingBird: return "Identify a nesting bird"
            case .noticeEarlyBloomingFlowersAndBirds: return "Notice early blooming flowers and birds"
        }
    }
    
    var description: String {
        switch self {
            case .findAStarling: return "Look for a starling and log your observation during the week."
            case .spotARobin: return "Observe a robin and add it to your journal this week."
            case .recordThreeDifferentBirds: return "Log sightings of at least three different bird species this week."
            case .takePhotoOfAnyBird: return "Capture a photo of any bird you observe this week."
            case .spotFirstSpringSwallows: return "Mark the first swallows of spring in your journal."
            case .observeReturningMigratoryBirds: return "Note at least two migratory birds that return this season."
            case .identifyNestingBird: return "Find and record a bird that is building a nest this season."
            case .noticeEarlyBloomingFlowersAndBirds: return "Observe birds interacting with early blooming flowers this season."
        }
    }
}
