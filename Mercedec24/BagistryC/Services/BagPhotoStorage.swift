import UIKit

enum BagPhotoStorage {
    private static let folderName = "bag_photos"
    
    private static var folderURL: URL? {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let url = docs.appendingPathComponent(folderName)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }
    
    static func saveImage(_ image: UIImage) -> String? {
        guard let folder = folderURL else { return nil }
        let filename = "\(UUID().uuidString).jpg"
        let url = folder.appendingPathComponent(filename)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try data.write(to: url)
            return filename
        } catch {
            return nil
        }
    }
    
    static func loadImage(filename: String) -> UIImage? {
        guard let folder = folderURL else { return nil }
        let url = folder.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    static func removeImage(filename: String) {
        guard let folder = folderURL else { return }
        let url = folder.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }
}
