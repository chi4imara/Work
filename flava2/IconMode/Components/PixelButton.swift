import SwiftUI

struct PixelButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case danger
        case success
        
        var backgroundColor: LinearGradient {
            switch self {
            case .primary:
                return AppColors.buttonGradient
            case .secondary:
                return LinearGradient(colors: [Color.white, AppColors.cardBackground], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .danger:
                return LinearGradient(colors: [AppColors.danger, Color(red: 1.0, green: 0.2, blue: 0.2, opacity: 0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .success:
                return LinearGradient(colors: [AppColors.success, Color(red: 0.2, green: 0.8, blue: 0.2, opacity: 0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary, .danger, .success:
                return AppColors.textLight
            case .secondary:
                return AppColors.textPrimary
            }
        }
        
        var borderColor: Color {
            switch self {
            case .primary:
                return AppColors.primary
            case .secondary:
                return AppColors.primary
            case .danger:
                return AppColors.danger
            case .success:
                return AppColors.success
            }
        }
    }
    
    init(_ title: String, icon: String? = nil, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
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
                    .font(AppFonts.pixelButton)
            }
            .foregroundColor(style.textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(style.backgroundColor)
            .cornerRadius(0)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(style.borderColor, lineWidth: 2)
            )
        }
        .buttonStyle(PixelButtonStyle())
    }
}

struct PixelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 16) {
        PixelButton("Primary Button", icon: "checkmark", style: .primary) { }
        PixelButton("Secondary Button", style: .secondary) { }
        PixelButton("Danger Button", icon: "trash", style: .danger) { }
        PixelButton("Success Button", icon: "star.fill", style: .success) { }
    }
    .padding()
}
