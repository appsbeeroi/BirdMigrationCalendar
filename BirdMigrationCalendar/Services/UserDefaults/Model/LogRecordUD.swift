import Foundation

struct LogRecordUD: Codable {
    var id: UUID
    var species: String
    var date: Date
    var note: String
    var rarity: BirdStatus
    var isFavorite: Bool
    
    init(from model: LogRecord) {
        self.id = model.id
        self.species = model.species
        self.date = model.date
        self.note = model.note
        self.rarity = model.rarity ?? .common
        self.isFavorite = model.isFavorite
    }
}
