import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var style: ButtonStyle = .primary
    var size: ButtonSize = .large
    var isEnabled: Bool = true
    
    enum ButtonStyle {
        case primary
        case secondary
        case destructive
        case outline
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color.theme.primaryBlue
            case .secondary:
                return Color.theme.cardBackground
            case .destructive:
                return Color.theme.errorRed
            case .outline:
                return Color.clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary, .destructive:
                return .white
            case .secondary:
                return Color.theme.primaryText
            case .outline:
                return Color.theme.primaryBlue
            }
        }
        
        var borderColor: Color? {
            switch self {
            case .outline:
                return Color.theme.primaryBlue
            default:
                return nil
            }
        }
    }
    
    enum ButtonSize {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small:
                return 36
            case .medium:
                return 44
            case .large:
                return 50
            }
        }
        
        var font: Font {
            switch self {
            case .small:
                return .theme.buttonSmall
            case .medium:
                return .theme.buttonMedium
            case .large:
                return .theme.buttonLarge
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(size.font)
                .foregroundColor(isEnabled ? style.foregroundColor : Color.theme.secondaryText)
                .frame(maxWidth: .infinity)
                .frame(height: size.height)
                .background(isEnabled ? style.backgroundColor : Color.theme.cardBackground)
                .cornerRadius(size.height / 2)
                .overlay(
                    RoundedRectangle(cornerRadius: size.height / 2)
                        .stroke(style.borderColor ?? Color.clear, lineWidth: 1)
                )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomButton(title: "Primary Button", action: {})
        CustomButton(title: "Secondary Button", action: {}, style: .secondary)
        CustomButton(title: "Destructive Button", action: {}, style: .destructive)
        CustomButton(title: "Outline Button", action: {}, style: .outline)
        CustomButton(title: "Disabled Button", action: {}, isEnabled: false)
        
        HStack(spacing: 12) {
            CustomButton(title: "Small", action: {}, size: .small)
            CustomButton(title: "Medium", action: {}, size: .medium)
            CustomButton(title: "Large", action: {}, size: .large)
        }
    }
    .padding()
}
