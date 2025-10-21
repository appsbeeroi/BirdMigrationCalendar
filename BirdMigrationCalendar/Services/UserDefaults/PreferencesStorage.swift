import Foundation

final class PreferencesStorage {

    static let shared = PreferencesStorage()
    
    private let storage = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {}
        
    func retrieve<T: Codable>(_ type: T.Type, for key: PreferencesKey) async -> T? {
        guard let data = storage.data(forKey: key.rawValue) else { return nil }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("⚠️ Failed to decode \(T.self): \(error.localizedDescription)")
            return nil
        }
    }
    
    func store<T: Codable>(_ value: T, for key: PreferencesKey) async {
        do {
            let data = try encoder.encode(value)
            storage.set(data, forKey: key.rawValue)
        } catch {
            print("⚠️ Failed to encode \(T.self): \(error.localizedDescription)")
        }
    }
    
    func removeValue(for key: PreferencesKey) {
        storage.removeObject(forKey: key.rawValue)
    }
}
