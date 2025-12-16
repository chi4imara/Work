import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var style: ButtonStyle = .primary
    var isEnabled: Bool = true
    
    enum ButtonStyle {
        case primary
        case secondary
        case destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color.appPrimaryYellow
            case .secondary:
                return Color.appCardBackground
            case .destructive:
                return Color.appAccentRed
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary:
                return Color.black
            case .secondary, .destructive:
                return Color.appTextPrimary
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(style.textColor)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(style.backgroundColor.opacity(isEnabled ? 1.0 : 0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        }
        .disabled(!isEnabled)
        .scaleEffect(isEnabled ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        
        VStack(spacing: 20) {
            CustomButton(title: "Primary Button", action: {})
            CustomButton(title: "Secondary Button", action: {}, style: .secondary)
            CustomButton(title: "Destructive Button", action: {}, style: .destructive)
            CustomButton(title: "Disabled Button", action: {}, isEnabled: false)
        }
        .padding()
    }
}
