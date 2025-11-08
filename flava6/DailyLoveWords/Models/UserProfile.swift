import Foundation
import SwiftUI

struct UserProfile: Codable {
    var name: String
    var avatarFileName: String?
    
    init(name: String = "Word Collector", avatarFileName: String? = nil) {
        self.name = name
        self.avatarFileName = avatarFileName
    }
    
    var avatar: UIImage? {
        get {
            guard let fileName = avatarFileName else { return nil }
            return FileStorageManager.shared.loadAvatar(fileName: fileName)
        }
        set {
            if let oldFileName = avatarFileName {
                FileStorageManager.shared.deleteAvatar(fileName: oldFileName)
            }
            
            if let newImage = newValue {
                avatarFileName = FileStorageManager.shared.saveAvatar(newImage)
            } else {
                avatarFileName = nil
            }
        }
    }
    
    var displayName: String {
        name.isEmpty ? "Word Collector" : name
    }
}
