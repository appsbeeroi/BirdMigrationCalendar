import Foundation
import CoreLocation

struct LogRecordUD: Codable {
    var id: UUID
    var species: String
    var date: Date
    var note: String
    var longitude: Double?
    var latitude: Double?
    var rarity: BirdStatus
    var isFavorite: Bool
    
    init(from model: LogRecord) {
        self.id = model.id
        self.species = model.species
        self.date = model.date
        self.note = model.note
        self.rarity = model.rarity ?? .common
        self.isFavorite = model.isFavorite
        self.longitude = model.longitude ?? 0
        self.latitude = model.latitude ?? 0
    }
}
