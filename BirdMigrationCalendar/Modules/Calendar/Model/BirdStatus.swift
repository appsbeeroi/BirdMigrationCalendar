enum BirdStatus:  String, Identifiable, CaseIterable, Codable {
    var id: Self { self }
    
    case common
    case rare
    
    var title: String {
        switch self {
            case .common:
                "Common"
            case .rare:
                "Rare"
        }
    }
}
