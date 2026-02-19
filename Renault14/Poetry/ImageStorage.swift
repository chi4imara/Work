import UIKit
import SwiftUI

enum ImageStorage {
    
    static var documentsURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    static func saveOutfitImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let dir = documentsURL else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let fileURL = dir.appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
            return filename
        } catch {
            return nil
        }
    }
    
    static func loadOutfitImage(named filename: String) -> UIImage? {
        guard let dir = documentsURL else { return nil }
        let fileURL = dir.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }
}

struct ItemPhotoView: View {
    let imageName: String?
    var placeholderIcon: String = "tshirt.fill"
    var placeholderSize: CGFloat = 30
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        Group {
            if let name = imageName, let uiImage = ImageStorage.loadOutfitImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .cornerRadius(cornerRadius)
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: placeholderIcon)
                    .font(.system(size: placeholderSize))
                    .foregroundColor(AppColors.primary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct OutfitPhotoView: View {
    let imageName: String?
    var placeholderSize: CGFloat = 30
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        ItemPhotoView(imageName: imageName, placeholderIcon: "heart.fill", placeholderSize: placeholderSize, cornerRadius: cornerRadius)
    }
}
