import SwiftUI

struct AccessoryPhotoView: View {
    let accessory: Accessory
    var width: CGFloat? = nil
    var height: CGFloat = 120
    var cornerRadius: CGFloat = 12
    var iconSize: CGFloat = 40
    
    @State private var loadedImage: UIImage?
    
    var body: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .cornerRadius(cornerRadius)
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AppColors.lightGray)
                    .frame(width: width, height: height)
                    .overlay(
                        Image(systemName: accessory.category.icon)
                            .font(.system(size: iconSize))
                            .foregroundColor(AppColors.textBlue.opacity(0.6))
                    )
            }
        }
        .onAppear {
            loadedImage = ImageStorage.load(for: accessory.id)
        }
        .onChange(of: accessory.id) { _ in
            loadedImage = ImageStorage.load(for: accessory.id)
        }
    }
}
