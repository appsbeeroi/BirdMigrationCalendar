import UIKit

final class StatisticsViewModel: ObservableObject {
    
    private let udStorage = PreferencesStorage.shared

    @Published private(set) var records: [LogRecord] = []
    
    var topSpeciesData: [ChartData] {
        let counts = Dictionary(grouping: records, by: { $0.species })
            .mapValues { Double($0.count) }
            .sorted { $0.value > $1.value }
            .prefix(10)
        
        return counts.map { ChartData(label: $0.key, value: $0.value) }
    }
    
    var monthlyMigrationData: [ChartData] {
        let calendar = Calendar.current
        let counts = Dictionary(grouping: records) {
            calendar.component(.month, from: $0.date)
        }
        .mapValues { Double($0.count) }
        .sorted { $0.key < $1.key }
        
        let formatter = DateFormatter()
        let monthSymbols = formatter.shortMonthSymbols
        
        return counts.map {
            ChartData(label: monthSymbols?[$0.key - 1] ?? "?", value: $0.value)
        }
    }
    
    func loadRecords() {
        Task { [weak self] in
            guard let self else { return }
            
            let recordsUD = await self.udStorage.retrieve([LogRecordUD].self, for: .record) ?? []
            
            let result = await withTaskGroup(of: LogRecord?.self) { group in
                for recordUD in recordsUD {
                    group.addTask {
                        LogRecord(from: recordUD, image: UIImage())
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
