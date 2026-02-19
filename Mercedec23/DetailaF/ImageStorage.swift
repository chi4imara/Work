import UIKit

enum ImageStorage {
    private static let directoryName = "AccessoryImages"
    
    private static var directoryURL: URL? {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let dir = documents.appendingPathComponent(directoryName)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }
    
    private static func fileURL(for accessoryId: UUID) -> URL? {
        directoryURL?.appendingPathComponent("\(accessoryId.uuidString).jpg")
    }
    
    static func save(_ image: UIImage, for accessoryId: UUID) {
        guard let url = fileURL(for: accessoryId),
              let data = image.jpegData(compressionQuality: 0.8) else { return }
        try? data.write(to: url)
    }
    
    static func load(for accessoryId: UUID) -> UIImage? {
        guard let url = fileURL(for: accessoryId),
              FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    static func remove(for accessoryId: UUID) {
        guard let url = fileURL(for: accessoryId) else { return }
        try? FileManager.default.removeItem(at: url)
    }
}
