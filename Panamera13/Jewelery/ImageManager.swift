import SwiftUI
import PhotosUI
import UIKit
import Combine

class ImageManager: ObservableObject {
    static let shared = ImageManager()
    
    private let fileManager = FileManager.default
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private init() {}
    
    func saveImage(_ image: UIImage, withName name: String) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        let fileURL = documentsDirectory.appendingPathComponent("\(name).jpg")
        
        do {
            try imageData.write(to: fileURL)
            return name
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadImage(named name: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent("\(name).jpg")
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let imageData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: imageData) else {
            return nil
        }
        
        return image
    }
    
    func deleteImage(named name: String) {
        let fileURL = documentsDirectory.appendingPathComponent("\(name).jpg")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            try? fileManager.removeItem(at: fileURL)
        }
    }
    
    func processImageThroughTinyPNG(_ image: UIImage, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let compressedData = image.jpegData(compressionQuality: 0.7),
               let compressedImage = UIImage(data: compressedData) {
                DispatchQueue.main.async {
                    completion(compressedImage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

struct AsyncJewelryImage: View {
    let imageName: String?
    let placeholder: String
    let size: CGSize
    
    @State private var image: UIImage?
    
    init(imageName: String?, placeholder: String = "photo", size: CGSize = CGSize(width: 60, height: 60)) {
        self.imageName = imageName
        self.placeholder = placeholder
        self.size = size
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
            } else {
                Image(systemName: placeholder)
                    .font(.system(size: min(size.width, size.height) * 0.4))
                    .foregroundColor(ColorTheme.secondaryText)
                    .frame(width: size.width, height: size.height)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let imageName = imageName else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedImage = ImageManager.shared.loadImage(named: imageName)
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
    }
}
