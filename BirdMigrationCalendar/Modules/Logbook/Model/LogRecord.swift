import UIKit

struct LogRecord: Identifiable, Hashable {
    var id: UUID
    var image: UIImage?
    var species: String
    var date: Date
    var note: String
    var rarity: BirdStatus?
    var isFavorite: Bool
    
    var isLock: Bool {
        image == nil || species == "" || note == "" || rarity == nil
    }
    
    init(isMock: Bool) {
        self.id = UUID()
        self.image = isMock ? UIImage(resource: .img1) : nil
        self.species = isMock ? "Mock Bird" : ""
        self.date = Date()
        self.note = isMock ? "Mock Note" : ""
        self.isFavorite = false
    }
    
    init(from ud: LogRecordUD, image: UIImage) {
        self.id = ud.id
        self.image = image
        self.species = ud.species
        self.date = ud.date
        self.note = ud.note
        self.rarity = ud.rarity
        self.isFavorite = ud.isFavorite
    }
}
