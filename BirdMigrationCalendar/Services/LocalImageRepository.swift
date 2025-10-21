import UIKit

final class LocalImageRepository {
    
    static let shared = LocalImageRepository()
    
    private let directoryName = "CachedImages"
    private let manager = FileManager.default
    private let baseURL: URL
    
    private init() {
        let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        baseURL = documentsURL.appendingPathComponent(directoryName, isDirectory: true)
        ensureDirectoryExists()
    }
    
    private func ensureDirectoryExists() {
        var isDir: ObjCBool = false
        if !manager.fileExists(atPath: baseURL.path, isDirectory: &isDir) || !isDir.boolValue {
            do {
                try manager.createDirectory(at: baseURL, withIntermediateDirectories: true)
            } catch {
                print("📁❌ Failed to create directory: \(error.localizedDescription)")
            }
        }
    }
    
    private func makeFileURL(for id: UUID) -> URL {
        baseURL.appendingPathComponent("\(id.uuidString).png")
    }
}

extension LocalImageRepository {
    @discardableResult
    func save(_ image: UIImage, for id: UUID) async -> String? {
        let fileURL = makeFileURL(for: id)
        
        guard let data = image.pngData() else {
            print("🖼️❌ Failed to encode image as PNG")
            return nil
        }
        
        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL.lastPathComponent
        } catch {
            print("💾❌ Failed to save image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func load(for id: UUID) async -> UIImage? {
        let fileURL = makeFileURL(for: id)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func delete(for id: UUID) async {
        let fileURL = makeFileURL(for: id)
        
        guard manager.fileExists(atPath: fileURL.path) else { return }
        
        do {
            try manager.removeItem(at: fileURL)
        } catch {
            print("🗑️❌ Failed to delete image: \(error.localizedDescription)")
        }
    }
}
