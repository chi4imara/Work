import SwiftUI

struct RecipeThumbnailView: View {
    let recipe: Recipe
    @State private var loadedImage: UIImage?
    
    var body: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                recipe.category.color.opacity(0.3),
                                recipe.category.color.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.textSecondary.opacity(0.5))
                    )
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let fileName = recipe.imageFileName, !fileName.isEmpty else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = ImageManager.shared.loadImage(fileName: fileName) {
                DispatchQueue.main.async {
                    self.loadedImage = image
                }
            }
        }
    }
}

