import UIKit

enum AvatarStorage {
    private static let fileName = "profile_avatar.jpg"
    
    static var avatarURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }
    
    static func saveAvatarImage(_ image: UIImage) -> Bool {
        guard let url = avatarURL,
              let data = image.jpegData(compressionQuality: 0.8) else { return false }
        do {
            try data.write(to: url)
            return true
        } catch {
            return false
        }
    }
    
    static func loadAvatarImage() -> UIImage? {
        guard let url = avatarURL,
              FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    static func removeAvatar() {
        guard let url = avatarURL, FileManager.default.fileExists(atPath: url.path) else { return }
        try? FileManager.default.removeItem(at: url)
    }
}
