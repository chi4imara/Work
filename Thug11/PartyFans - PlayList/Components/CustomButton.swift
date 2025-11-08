import SwiftUI

struct CustomButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color.theme.buttonPrimary
            case .secondary:
                return Color.theme.buttonSecondary
            case .destructive:
                return Color.red.opacity(0.8)
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary, .destructive:
                return Color.theme.buttonText
            case .secondary:
                return Color.theme.primaryText
            }
        }
    }
    
    init(title: String, icon: String? = nil, style: ButtonStyle = .primary, action: @escaping () -> Void) {
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
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .font(.nunitoSemiBold(size: 16))
            }
            .foregroundColor(style.textColor)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(style.backgroundColor)
            .cornerRadius(24)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomButton(title: "Primary Button", icon: "star.fill", style: .primary) { }
        CustomButton(title: "Secondary Button", style: .secondary) { }
        CustomButton(title: "Destructive Button", style: .destructive) { }
    }
    .padding()
    .background(Color.theme.backgroundGradientStart)
}
