import Foundation
import SwiftUI
import Combine

class ProfileStore: ObservableObject {
    @Published var profile: UserProfile
    
    private let fileStorage = FileStorageManager.shared
    
    init() {
        if let loadedProfile = fileStorage.loadProfile() {
            self.profile = loadedProfile
        } else {
            self.profile = UserProfile()
            saveProfile()
        }
    }
    
    func updateName(_ name: String) {
        profile.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        saveProfile()
    }
    
    func updateAvatar(_ image: UIImage?) {
        profile.avatar = image
        saveProfile()
    }
    
    func resetProfile() {
        if let oldFileName = profile.avatarFileName {
            fileStorage.deleteAvatar(fileName: oldFileName)
        }
        
        profile = UserProfile()
        saveProfile()
    }
    
    private func saveProfile() {
        fileStorage.saveProfile(profile)
        fileStorage.cleanupOldFiles()
    }
}
