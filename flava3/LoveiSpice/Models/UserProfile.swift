import Foundation
import SwiftUI
import Combine

class UserProfile: ObservableObject {
    @Published var name: String
    @Published var avatarImage: UIImage?
    @Published var bio: String
    
    private let userDefaults = UserDefaults.standard
    private let nameKey = "UserProfileName"
    private let bioKey = "UserProfileBio"
    private let avatarKey = "UserProfileAvatar"
    
    init() {
        self.name = userDefaults.string(forKey: nameKey) ?? "Recipe Master"
        self.bio = userDefaults.string(forKey: bioKey) ?? "Cooking enthusiast"
        
        if let data = userDefaults.data(forKey: avatarKey) {
            self.avatarImage = UIImage(data: data)
        }
    }
    
    func updateName(_ newName: String) {
        name = newName
        userDefaults.set(newName, forKey: nameKey)
    }
    
    func updateBio(_ newBio: String) {
        bio = newBio
        userDefaults.set(newBio, forKey: bioKey)
    }
    
    func updateAvatar(_ image: UIImage) {
        avatarImage = image
        if let data = image.jpegData(compressionQuality: 0.8) {
            userDefaults.set(data, forKey: avatarKey)
        }
    }
    
    func removeAvatar() {
        avatarImage = nil
        userDefaults.removeObject(forKey: avatarKey)
    }
}

