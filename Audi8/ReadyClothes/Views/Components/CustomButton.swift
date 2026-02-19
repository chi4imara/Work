import SwiftUI

struct CustomButton: View {
    let title: String
    let icon: String?
    let backgroundColor: Color
    let textColor: Color
    let action: () -> Void
    let isEnabled: Bool
    
    init(
        title: String,
        icon: String? = nil,
        backgroundColor: Color = .primaryYellow,
        textColor: Color = .textDark,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                }
                
                Text(title)
                    .font(.lumierepolis(16, weight: .bold))
            }
            .foregroundColor(isEnabled ? textColor : textColor.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isEnabled ? backgroundColor : backgroundColor.opacity(0.3))
            )
        }
        .disabled(!isEnabled)
    }
}

struct CustomIconButton: View {
    let icon: String
    let backgroundColor: Color
    let iconColor: Color
    let size: CGFloat
    let action: () -> Void
    
    init(
        icon: String,
        backgroundColor: Color = .primaryYellow,
        iconColor: Color = .textDark,
        size: CGFloat = 50,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.iconColor = iconColor
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(iconColor)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(backgroundColor)
                        .shadow(color: .shadowColor, radius: 5, x: 0, y: 2)
                )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(title: "Save Outfit", icon: "checkmark") {
            print("Button tapped")
        }
        
        CustomButton(
            title: "Disabled Button",
            backgroundColor: .red,
            textColor: .white,
            isEnabled: false
        ) {
            print("Button tapped")
        }
        
        CustomIconButton(icon: "plus") {
            print("Icon button tapped")
        }
    }
    .padding()
    .background(AppColors.backgroundGradient)
}