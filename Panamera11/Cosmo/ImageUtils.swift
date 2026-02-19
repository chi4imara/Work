import UIKit
import SwiftUI

extension UIImage {
    func compressedForStorage() -> Data? {
        let maxSize: CGFloat = 800
        let resizedImage: UIImage
        
        if size.width > maxSize || size.height > maxSize {
            let ratio = min(maxSize / size.width, maxSize / size.height)
            let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            draw(in: CGRect(origin: .zero, size: newSize))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
        } else {
            resizedImage = self
        }
        
        return resizedImage.jpegData(compressionQuality: 0.7)
    }
}

struct AsyncImageView: View {
    let imageData: Data?
    let placeholder: String
    let size: CGSize
    
    var body: some View {
        Group {
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: placeholder)
                    .font(.system(size: min(size.width, size.height) * 0.4))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .frame(width: size.width, height: size.height)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
