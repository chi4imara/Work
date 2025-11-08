import Foundation
import UIKit

class FileStorageManager {
    static let shared = FileStorageManager()
    
    private let documentsDirectory: URL
    private let appDirectory: URL
    
    private init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        appDirectory = documentsDirectory.appendingPathComponent("DailyLoveWords")
        
        createAppDirectoryIfNeeded()
    }
    
    private func createAppDirectoryIfNeeded() {
        if !FileManager.default.fileExists(atPath: appDirectory.path) {
            try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        }
    }
    
    func saveAvatar(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return nil }
        
        let fileName = "avatar_\(UUID().uuidString).jpg"
        let fileURL = appDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch {
            print("❌ Failed to save avatar: \(error)")
            return nil
        }
    }
    
    func loadAvatar(fileName: String) -> UIImage? {
        let fileURL = appDirectory.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("❌ Failed to load avatar: \(error)")
            return nil
        }
    }
    
    func deleteAvatar(fileName: String) {
        let fileURL = appDirectory.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    func saveWords(_ words: [Word]) -> Bool {
        let fileURL = appDirectory.appendingPathComponent("words.json")
        
        do {
            let encoded = try JSONEncoder().encode(words)
            try encoded.write(to: fileURL)
            print("✅ Words saved to file: \(words.count) words")
            return true
        } catch {
            print("❌ Failed to save words: \(error)")
            return false
        }
    }
    
    func loadWords() -> [Word] {
        let fileURL = appDirectory.appendingPathComponent("words.json")
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let words = try JSONDecoder().decode([Word].self, from: data)
            print("✅ Words loaded from file: \(words.count) words")
            return words
        } catch {
            print("❌ Failed to load words: \(error)")
            return []
        }
    }
    
    func deleteWordsFile() {
        let fileURL = appDirectory.appendingPathComponent("words.json")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    func saveProfile(_ profile: UserProfile) -> Bool {
        let fileURL = appDirectory.appendingPathComponent("profile.json")
        
        do {
            let encoded = try JSONEncoder().encode(profile)
            try encoded.write(to: fileURL)
            print("✅ Profile saved to file")
            return true
        } catch {
            print("❌ Failed to save profile: \(error)")
            return false
        }
    }
    
    func loadProfile() -> UserProfile? {
        let fileURL = appDirectory.appendingPathComponent("profile.json")
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let profile = try JSONDecoder().decode(UserProfile.self, from: data)
            print("✅ Profile loaded from file")
            return profile
        } catch {
            print("❌ Failed to load profile: \(error)")
            return nil
        }
    }
    
    func deleteProfileFile() {
        let fileURL = appDirectory.appendingPathComponent("profile.json")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    func cleanupOldFiles() {
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(at: appDirectory, includingPropertiesForKeys: [.creationDateKey])
            let avatarFiles = files.filter { $0.lastPathComponent.hasPrefix("avatar_") }
            
            if avatarFiles.count > 1 {
                let sortedFiles = avatarFiles.sorted { file1, file2 in
                    let date1 = (try? file1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                    let date2 = (try? file2.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                    return date1 < date2
                }
                
                for file in sortedFiles.dropLast() {
                    try? fileManager.removeItem(at: file)
                    print("🗑️ Cleaned up old avatar: \(file.lastPathComponent)")
                }
            }
        } catch {
            print("❌ Failed to cleanup files: \(error)")
        }
    }
    
    func getStorageInfo() -> (totalSize: Int64, fileCount: Int) {
        let fileManager = FileManager.default
        var totalSize: Int64 = 0
        var fileCount = 0
        
        do {
            let files = try fileManager.contentsOfDirectory(at: appDirectory, includingPropertiesForKeys: [.fileSizeKey])
            fileCount = files.count
            
            for file in files {
                let attributes = try file.resourceValues(forKeys: [.fileSizeKey])
                totalSize += Int64(attributes.fileSize ?? 0)
            }
        } catch {
            print("❌ Failed to get storage info: \(error)")
        }
        
        return (totalSize, fileCount)
    }
}
