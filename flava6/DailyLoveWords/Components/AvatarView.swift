import SwiftUI

struct AvatarView: View {
    let image: UIImage?
    let size: CGFloat
    let showBorder: Bool
    
    init(image: UIImage?, size: CGFloat = 80, showBorder: Bool = true) {
        self.image = image
        self.size = size
        self.showBorder = showBorder
    }
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(showBorder ? AppColors.primaryBlue : Color.clear, lineWidth: showBorder ? 2 : 0)
                    )
            } else {
                Circle()
                    .fill(AppColors.blueGradient)
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: size * 0.4))
                            .foregroundColor(.white)
                    )
                    .overlay(
                        Circle()
                            .stroke(showBorder ? AppColors.primaryBlue : Color.clear, lineWidth: showBorder ? 2 : 0)
                    )
            }
        }
    }
}

struct EditableAvatarView: View {
    let image: UIImage?
    let size: CGFloat
    let onTap: () -> Void
    
    init(image: UIImage?, size: CGFloat = 80, onTap: @escaping () -> Void) {
        self.image = image
        self.size = size
        self.onTap = onTap
    }
    
    var body: some View {
        ZStack {
            AvatarView(image: image, size: size)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: onTap) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: size * 0.15))
                            .foregroundColor(.white)
                            .padding(size * 0.08)
                            .background(
                                Circle()
                                    .fill(AppColors.primaryBlue)
                            )
                    }
                }
            }
            .frame(width: size, height: size)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AvatarView(image: nil, size: 80)
        AvatarView(image: nil, size: 60, showBorder: false)
        EditableAvatarView(image: nil, size: 100) {
            print("Edit tapped")
        }
    }
    .padding()
}
