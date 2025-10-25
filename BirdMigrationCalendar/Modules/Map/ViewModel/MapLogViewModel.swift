import Foundation
import MapKit

enum MapLogScreen: Hashable {
    case detail(LogRecord)
}

final class MapLogViewModel: ObservableObject {
    
    private let udStorage = PreferencesStorage.shared
    private let imageStorage = LocalImageRepository.shared
    
    @Published var navigationPath: [MapLogScreen] = []
    
    @Published var isFilterOn = false
    @Published var selectedDate = Date()
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var filteredRecords: [LogRecord] {
        guard isFilterOn else { return records }
        
        let calendar = Calendar.current
        return records.filter { record in
            calendar.isDate(record.date, inSameDayAs: selectedDate)
        }
    }

    
    @Published private(set) var records: [LogRecord] = [LogRecord(isMock: true), LogRecord(isMock: true)]
    
    func loadRecords() {
        Task { [weak self] in
            guard let self else { return }
            
            let recordsUD = await self.udStorage.retrieve([LogRecordUD].self, for: .record) ?? []
            
            let result = await withTaskGroup(of: LogRecord?.self) { group in
                for recordUD in recordsUD {
                    group.addTask {
                        guard let image = await self.imageStorage.load(for: recordUD.id) else { return nil }
                        let record = LogRecord(from: recordUD, image: image)
                        
                        return record
                    }
                }
                
                var records: [LogRecord?] = []
                
                for await record in group {
                    records.append(record)
                }
                
                return records.compactMap { $0 }
            }
            
            await MainActor.run {
                self.records = result
            }
        }
    }
}

