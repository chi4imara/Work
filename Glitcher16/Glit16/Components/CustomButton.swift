import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    let isEnabled: Bool
    
    enum ButtonStyle {
        case primary
        case secondary
        case danger
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .primaryYellow
            case .secondary:
                return .buttonSecondary
            case .danger:
                return .buttonDanger
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return .primaryPink
            case .secondary:
                return .textPrimary
            case .danger:
                return .textPrimary
            }
        }
    }
    
    init(title: String, style: ButtonStyle = .primary, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(isEnabled ? style.foregroundColor : .textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isEnabled ? style.backgroundColor : Color.buttonSecondary)
                .cornerRadius(25)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(title: "Primary Button", style: .primary) { }
        CustomButton(title: "Secondary Button", style: .secondary) { }
        CustomButton(title: "Danger Button", style: .danger) { }
        CustomButton(title: "Disabled Button", style: .primary, isEnabled: false) { }
    }
    .padding()
    .background(Color.black)
}