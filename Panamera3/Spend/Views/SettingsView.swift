import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.lumierepolis(32, weight: .bold))
                        .foregroundColor(Color.theme.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            SettingsButton(
                                title: "Privacy Policy",
                                icon: "shield.checkered",
                                action: { openURL("https://www.privacypolicies.com/live/5e7a4da4-9a2d-491f-99dd-decee7b8989e") }
                            )
                            
                            HStack(spacing: 15) {
                                SettingsButton(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    isCompact: true,
                                    action: { openURL("https://www.privacypolicies.com/live/5e7a4da4-9a2d-491f-99dd-decee7b8989e") }
                                )
                                
                                SettingsButton(
                                    title: "Rate App",
                                    icon: "star",
                                    isCompact: true,
                                    action: { requestReview() }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let style: ButtonStyle
    let isCompact: Bool
    let isSmall: Bool
    let action: () -> Void
    
    enum ButtonStyle {
        case primary, secondary, accent
    }
    
    init(title: String, icon: String, style: ButtonStyle = .primary, isCompact: Bool = false, isSmall: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isCompact = isCompact
        self.isSmall = isSmall
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: isSmall ? 8 : 12) {
                Image(systemName: icon)
                    .font(.system(size: isSmall ? 16 : 20, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: isSmall ? 20 : 24, height: isSmall ? 20 : 24)
                
                if !isSmall {
                    Text(title)
                        .font(.lumierepolis(isCompact ? 14 : 16, weight: .bold))
                        .foregroundColor(textColor)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(backgroundGradient)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
        }
    }
    
    private var buttonHeight: CGFloat {
        if isSmall { return 50 }
        if isCompact { return 60 }
        return 70
    }
    
    private var cornerRadius: CGFloat {
        if isSmall { return 25 }
        if isCompact { return 30 }
        return 35
    }
    
    private var shadowRadius: CGFloat {
        isSmall ? 5 : 8
    }
    
    private var shadowOffset: CGFloat {
        isSmall ? 2 : 3
    }
    
    private var iconColor: Color {
        switch style {
        case .primary:
            return Color.theme.textBlack
        case .secondary:
            return Color.theme.primaryPink
        case .accent:
            return Color.theme.textWhite
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return Color.theme.textBlack
        case .secondary:
            return Color.theme.textBlack
        case .accent:
            return Color.theme.textWhite
        }
    }
    
    private var backgroundGradient: LinearGradient {
        switch style {
        case .primary:
            return Color.theme.cardGradient
        case .secondary:
            return LinearGradient(
                gradient: Gradient(colors: [Color.theme.lightPink.opacity(0.8), Color.theme.lightPink.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .accent:
            return LinearGradient(
                gradient: Gradient(colors: [Color.theme.primaryPink, Color.theme.darkPink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return Color.black.opacity(0.1)
        case .secondary:
            return Color.theme.primaryPink.opacity(0.2)
        case .accent:
            return Color.theme.primaryPink.opacity(0.3)
        }
    }
}

#Preview {
    SettingsView()
}
