import SwiftUI

struct ProfileAvatarView: View {
    let avatarImage: UIImage?
    let size: CGFloat
    let showEditOverlay: Bool
    
    init(avatarImage: UIImage?, size: CGFloat = 120, showEditOverlay: Bool = true) {
        self.avatarImage = avatarImage
        self.size = size
        self.showEditOverlay = showEditOverlay
    }
    
    var body: some View {
        ZStack {
            if let avatar = avatarImage {
                Image(uiImage: avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(ColorManager.primaryYellow, lineWidth: 4)
                    )
            } else {
                Circle()
                    .fill(ColorManager.primaryYellow.opacity(0.3))
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: size * 0.4))
                            .foregroundColor(ColorManager.primaryBlue)
                    )
                    .overlay(
                        Circle()
                            .stroke(ColorManager.primaryYellow, lineWidth: 4)
                    )
            }
            
            if showEditOverlay {
                Circle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: size * 0.2))
                            .foregroundColor(.white)
                    )
                    .opacity(0.8)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProfileAvatarView(avatarImage: nil, size: 120)
        ProfileAvatarView(avatarImage: nil, size: 80, showEditOverlay: false)
    }
    .padding()
    .background(ColorManager.backgroundGradientStart)
}
