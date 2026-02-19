import UIKit

enum AvatarPhotoStorage {
    static let fileName = "profile_avatar.jpg"
    
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func fileURL(for fileName: String) -> URL {
        documentsDirectory.appendingPathComponent(fileName)
    }
    
    static func saveImage(_ image: UIImage, fileName: String = fileName) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let url = fileURL(for: fileName)
        do {
            try data.write(to: url)
            return fileName
        } catch {
            return nil
        }
    }
    
    static func loadImage(fileName: String) -> UIImage? {
        let url = fileURL(for: fileName)
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    static func removeImage(fileName: String) {
        let url = fileURL(for: fileName)
        try? FileManager.default.removeItem(at: url)
    }
}
