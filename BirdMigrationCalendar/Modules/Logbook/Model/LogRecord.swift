import UIKit
import CoreLocation

struct LogRecord: Identifiable, Hashable {
    var id: UUID
    var image: UIImage?
    var species: String
    var date: Date
    var longitude: Double?
    var latitude: Double?
    var note: String
    var rarity: BirdStatus?
    var isFavorite: Bool
    
    var isLock: Bool {
        image == nil || species.isEmpty || note.isEmpty || rarity == nil || longitude == nil || latitude == nil
    }
    
    init(isMock: Bool) {
        self.id = UUID()
        self.image = isMock ? UIImage(resource: .img1) : nil
        self.species = isMock ? "Mock Bird" : ""
        self.date = Date()
        self.longitude = isMock ? 21.22 : nil
        self.latitude = isMock ? 21.22 : nil
        self.note = isMock ? "Mock Note" : ""
        self.rarity = nil
        self.isFavorite = false
    }
    
    init(from ud: LogRecordUD, image: UIImage) {
        self.id = ud.id
        self.image = image
        self.species = ud.species
        self.date = ud.date
        self.latitude = ud.latitude
        self.longitude = ud.longitude
        self.note = ud.note
        self.rarity = ud.rarity
        self.isFavorite = ud.isFavorite
    }
}

extension LogRecord {
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

struct MapAnnotationItem: Identifiable {
    let id: UUID
    let record: LogRecord
    let coordinate: CLLocationCoordinate2D
}
