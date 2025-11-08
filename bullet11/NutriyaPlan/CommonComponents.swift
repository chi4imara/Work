import SwiftUI

struct UniversalHeaderView: View {
    let title: String
    let onMenuTap: () -> Void
    let rightButton: AnyView?
    
    init(title: String, onMenuTap: @escaping () -> Void, rightButton: AnyView? = nil) {
        self.title = title
        self.onMenuTap = onMenuTap
        self.rightButton = rightButton
    }
    
    var body: some View {
        HStack {
            MenuButton(action: onMenuTap)
            
            Spacer()
            
            Text(title)
                .font(.screenTitle)
                .foregroundColor(AppTheme.primaryWhite)
            
            Spacer()
            
            if let rightButton = rightButton {
                rightButton
            } else {
                Spacer()
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}

struct MenuButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppTheme.primaryWhite)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(AppTheme.primaryYellow.opacity(0.2))
                )
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.buttonMedium)
            .foregroundColor(AppTheme.darkBlue)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppTheme.yellowGradient)
                    .shadow(color: AppTheme.shadowColor, radius: 4, x: 0, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.buttonMedium)
            .foregroundColor(AppTheme.primaryWhite)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.primaryWhite.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppTheme.primaryWhite.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct AppCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(AppTheme.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

extension View {
    func appCardStyle() -> some View {
        modifier(AppCardStyle())
    }
}
