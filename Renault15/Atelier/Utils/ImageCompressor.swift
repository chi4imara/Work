import Foundation
import UIKit

enum ImageCompressor {
    private static let maxDimension: CGFloat = 1024
    private static let jpegQuality: CGFloat = 0.65
    private static let skipCompressionThreshold = 300_000
    
    static func compress(_ data: Data?) -> Data? {
        guard let data = data, !data.isEmpty else { return nil }
        if data.count < skipCompressionThreshold { return data }
        
        guard let image = UIImage(data: data) else { return data }
        
        let resized = resize(image, maxDimension: maxDimension)
        return resized.jpegData(compressionQuality: jpegQuality) ?? data
    }
    
    private static func resize(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let width = image.size.width
        let height = image.size.height
        guard width > maxDimension || height > maxDimension else { return image }
        
        let ratio = min(maxDimension / width, maxDimension / height)
        let newSize = CGSize(width: width * ratio, height: height * ratio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
