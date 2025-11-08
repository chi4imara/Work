import Foundation
import UIKit

class PhotoManager: ObservableObject {
    static let shared = PhotoManager()
    
    private let documentsDirectory: URL
    private let photosDirectory: URL
    
    private init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        photosDirectory = documentsDirectory.appendingPathComponent("MoodPhotos")
        
        if !FileManager.default.fileExists(atPath: photosDirectory.path) {
            try? FileManager.default.createDirectory(at: photosDirectory, withIntermediateDirectories: true)
        }
    }
    
    func savePhoto(_ image: UIImage) -> String? {
        let photoId = UUID().uuidString
        let photoURL = photosDirectory.appendingPathComponent("\(photoId).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        do {
            try imageData.write(to: photoURL)
            return photoId
        } catch {
            print("Error saving photo: \(error)")
            return nil
        }
    }
    
    func loadPhoto(with id: String) -> UIImage? {
        let photoURL = photosDirectory.appendingPathComponent("\(id).jpg")
        
        guard FileManager.default.fileExists(atPath: photoURL.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    func deletePhoto(with id: String) {
        let photoURL = photosDirectory.appendingPathComponent("\(id).jpg")
        
        try? FileManager.default.removeItem(at: photoURL)
    }
    
    func deletePhotos(with ids: [String]) {
        for id in ids {
            deletePhoto(with: id)
        }
    }
    
    func getPhotoURL(for id: String) -> URL {
        return photosDirectory.appendingPathComponent("\(id).jpg")
    }
    
    func photoExists(with id: String) -> Bool {
        let photoURL = photosDirectory.appendingPathComponent("\(id).jpg")
        return FileManager.default.fileExists(atPath: photoURL.path)
    }
    
    func getAllPhotoIds() -> [String] {
        guard let contents = try? FileManager.default.contentsOfDirectory(at: photosDirectory, includingPropertiesForKeys: nil) else {
            return []
        }
        
        return contents.compactMap { url in
            let filename = url.lastPathComponent
            return filename.hasSuffix(".jpg") ? String(filename.dropLast(4)) : nil
        }
    }
    
    func cleanupUnusedPhotos(usedPhotoIds: Set<String>) {
        let allPhotoIds = Set(getAllPhotoIds())
        let unusedPhotoIds = allPhotoIds.subtracting(usedPhotoIds)
        
        for photoId in unusedPhotoIds {
            deletePhoto(with: photoId)
        }
    }
}
