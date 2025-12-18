enum ChallengeType: String, Identifiable, CaseIterable {
    var id: Self {
        self
    }
    
    case weekly = "Weekly"
    case seasonal = "Seasonal"
}

