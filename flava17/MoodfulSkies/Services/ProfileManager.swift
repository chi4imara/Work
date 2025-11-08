import Foundation
import UIKit
import Combine

class ProfileManager: ObservableObject {
    static let shared = ProfileManager()
    
    @Published var userName: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.saveProfile()
            }
        }
    }
    @Published var avatarImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.saveProfile()
            }
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let userNameKey = "user_name"
    private let avatarImageKey = "avatar_image"
    
    private init() {
        loadProfile()
    }
    
    private func loadProfile() {
        userName = userDefaults.string(forKey: userNameKey) ?? ""
        
        if let imageData = userDefaults.data(forKey: avatarImageKey),
           let image = UIImage(data: imageData) {
            avatarImage = image
        }
    }
    
    func saveProfile() {
        userDefaults.set(userName, forKey: userNameKey)
        
        if let image = avatarImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            userDefaults.set(imageData, forKey: avatarImageKey)
        }
    }
    
    func clearProfile() {
        userName = ""
        avatarImage = nil
        userDefaults.removeObject(forKey: userNameKey)
        userDefaults.removeObject(forKey: avatarImageKey)
    }
    
    var displayName: String {
        return userName.isEmpty ? "Your Name" : userName
    }
    
    var hasAvatar: Bool {
        return avatarImage != nil
    }
    
    var initials: String {
        let components = userName.components(separatedBy: " ")
        if components.count >= 2 {
            let first = String(components[0].prefix(1))
            let last = String(components[1].prefix(1))
            return (first + last).uppercased()
        } else if !userName.isEmpty {
            return String(userName.prefix(2)).uppercased()
        } else {
            return "U"
        }
    }
}
