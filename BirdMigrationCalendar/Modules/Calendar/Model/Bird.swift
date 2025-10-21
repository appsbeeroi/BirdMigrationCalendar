import Foundation

struct Bird: Identifiable, Hashable {
    let id: UUID
    let name: String
    let image: String
    let status: BirdStatus
    let description: String
    
    init(
        name: String,
        image: String,
        status: BirdStatus,
        description: String
    ) {
        self.id = UUID()
        self.name = name
        self.image = image
        self.status = status
        self.description = description
    }
}
