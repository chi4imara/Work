import Foundation
import UIKit

class DataMigrationManager {
    static let shared = DataMigrationManager()
    
    private let userDefaults = UserDefaults.standard
    private let fileStorage = FileStorageManager.shared
    
    private let migrationKey = "hasMigratedToFileStorage"
    
    private init() {}
    
    func migrateIfNeeded() {
        guard !userDefaults.bool(forKey: migrationKey) else {
            print("✅ Data already migrated to file storage")
            return
        }
        
        print("🔄 Starting data migration from UserDefaults to file storage...")
        
        migrateProfile()
        
        migrateWords()
        
        cleanupUserDefaults()
        
        userDefaults.set(true, forKey: migrationKey)
        
        print("✅ Data migration completed successfully")
    }
    
    private func migrateProfile() {
        let profileKey = "UserProfile"
        
        if let data = userDefaults.data(forKey: profileKey),
           let oldProfile = try? JSONDecoder().decode(OldUserProfile.self, from: data) {
            
            print("🔄 Migrating profile...")
            
            var newProfile = UserProfile(name: oldProfile.name)
            
            if let avatarData = oldProfile.avatarData,
               let image = UIImage(data: avatarData) {
                newProfile.avatar = image
            }
            
            fileStorage.saveProfile(newProfile)
            
            print("✅ Profile migrated successfully")
        }
    }
    
    private func migrateWords() {
        let wordsKey = "SavedWords"
        
        if let data = userDefaults.data(forKey: wordsKey),
           let words = try? JSONDecoder().decode([Word].self, from: data) {
            
            print("🔄 Migrating \(words.count) words...")
            
            fileStorage.saveWords(words)
            
            print("✅ Words migrated successfully")
        }
    }
    
    private func cleanupUserDefaults() {
        print("🧹 Cleaning up UserDefaults...")
        
        userDefaults.removeObject(forKey: "UserProfile")
        userDefaults.removeObject(forKey: "SavedWords")
        
        
        print("✅ UserDefaults cleaned up")
    }
}

private struct OldUserProfile: Codable {
    var name: String
    var avatarData: Data?
}
