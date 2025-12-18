import SwiftUI

final class LogBookViewModel: ObservableObject {
    
    private let udStorage = PreferencesStorage.shared
    private let imageStorage = LocalImageRepository.shared
    
    @Published var navigationPath: [LogBookScreen] = []
    
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
    
    func save(_ record: LogRecord) {
        Task { [weak self] in
            guard let self,
                  let image = record.image else { return }
            
            var recordsUD = await self.udStorage.retrieve([LogRecordUD].self, for: .record) ?? []
            
            await self.imageStorage.save(image, for: record.id)
            
            let recordUD = LogRecordUD(from: record)
            
            if let index = recordsUD.firstIndex(where: { $0.id == record.id }) {
                recordsUD[index] = recordUD
            } else {
                recordsUD.append(recordUD)
            }
            
            await self.udStorage.store(recordsUD, for: .record)
            
            var achievement = await udStorage.retrieve(AchievementsModel.self, for: .achievements) ?? AchievementsModel()
            
            if achievement.isBeginner {
                achievement.isBeginner = false
            }
            
            achievement.observationCount += 1
            achievement.uniqueBirdCount += 1
            achievement.photosCount += 1
            
            let random = [false, false, false, true, false, false, false, false].randomElement() ?? false
            
            if !achievement.rareBirdObserved {
                achievement.rareBirdObserved = random
            }
            
            await udStorage.store(achievement, for: .achievements)
            
            await MainActor.run {
                self.navigationPath.removeAll()
            }
        }
    }
    
    func remove(_ record: LogRecord) {
        Task { [weak self] in
            guard let self else { return }
            
            var recordsUD = await self.udStorage.retrieve([LogRecordUD].self, for: .record) ?? []
            
            await self.imageStorage.delete(for: record.id)
            
            if let index = recordsUD.firstIndex(where: { $0.id == record.id }) {
                recordsUD.remove(at: index)
            }
            
            await self.udStorage.store(recordsUD, for: .record)
            
            await MainActor.run {
                self.navigationPath.removeAll()
            }
        }
    }
}
