import UIKit
import SwiftUI

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveImage(_ image: UIImage, for recipeId: UUID) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        let fileName = "\(recipeId.uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        guard !fileName.isEmpty else { return nil }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        return UIImage(data: imageData)
    }
    
    func deleteImage(fileName: String) {
        guard !fileName.isEmpty else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        try? FileManager.default.removeItem(at: fileURL)
    }
}

extension UIImage {
    func resized(to maxSize: CGSize) -> UIImage {
        let aspectRatio = size.width / size.height
        var newSize = size
        
        if size.width > maxSize.width {
            newSize.width = maxSize.width
            newSize.height = newSize.width / aspectRatio
        }
        
        if newSize.height > maxSize.height {
            newSize.height = maxSize.height
            newSize.width = newSize.height * aspectRatio
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
