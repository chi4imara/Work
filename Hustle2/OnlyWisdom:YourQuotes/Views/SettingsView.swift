import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
            ZStack {
                Color.clear
                    .backgroundGradient()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: DesignSystem.Spacing.xl) {
                            settingsSection(title: "App") {
                                VStack(spacing: DesignSystem.Spacing.sm) {
                                    SettingsRow(
                                        icon: "star.fill",
                                        title: "Rate App",
                                        iconColor: DesignSystem.Colors.warning
                                    ) {
                                        requestReview()
                                    }
                                }
                            }
                            
                            settingsSection(title: "Legal") {
                                VStack(spacing: DesignSystem.Spacing.sm) {
                                    SettingsRow(
                                        icon: "doc.text",
                                        title: "Terms of Use",
                                        iconColor: DesignSystem.Colors.primaryBlue
                                    ) {
                                        openURL("https://docs.google.com/document/d/1MDa9nYNfiFMiHKzlaZvMBcHF6w6rVo8nvDyJ_3fpfQ0/edit?usp=sharing")
                                    }
                                    
                                    SettingsRow(
                                        icon: "hand.raised.fill",
                                        title: "Privacy Policy",
                                        iconColor: DesignSystem.Colors.success
                                    ) {
                                        openURL("https://docs.google.com/document/d/1bphCNcWrASPlj9DdOuh-W7rDSiu_lnZ0YI8eHJwpj48/edit?usp=sharing")
                                    }
                                }
                            }
                            
                            settingsSection(title: "Support") {
                                VStack(spacing: DesignSystem.Spacing.sm) {
                                    SettingsRow(
                                        icon: "envelope.fill",
                                        title: "Contact Us",
                                        iconColor: DesignSystem.Colors.primaryBlue
                                    ) {
                                        openURL("https://forms.gle/m82uejC7Ry8cqFvH8")
                                    }
                                }
                            }
                            
                            appInfoSection
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.bottom, DesignSystem.Spacing.xxl)
                    }
                    .padding(.bottom, 40)
                }
            }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.poppinsBold(size: 28))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.top, DesignSystem.Spacing.md)
        .padding(.bottom, 5)
    }
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(title)
                .font(FontManager.poppinsSemiBold(size: 18))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .padding(.horizontal, DesignSystem.Spacing.md)
            
            VStack(spacing: 1) {
                content()
            }
            .cardStyle()
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            VStack(spacing: DesignSystem.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [
                                    DesignSystem.Colors.primaryBlue,
                                    DesignSystem.Colors.darkBlue
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "quote.bubble.fill")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: DesignSystem.Spacing.xs) {
                    Text("Quotes & Thoughts")
                        .font(FontManager.poppinsSemiBold(size: 20))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }
            }
            
            Text("Your personal archive of inspiring quotes and meaningful thoughts. Capture, organize, and revisit your ideas whenever inspiration strikes.")
                .font(FontManager.poppinsRegular(size: 14))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, DesignSystem.Spacing.md)
        }
        .padding(DesignSystem.Spacing.xl)
        .cardStyle()
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(FontManager.poppinsRegular(size: 16))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CreativeSettingsLayout: View {
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl) {
            ZStack {
                Circle()
                    .stroke(DesignSystem.Colors.lightBlue.opacity(0.3), lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                ForEach(0..<6) { index in
                    let angle = Double(index) * .pi / 3
                    let x = cos(angle) * 80
                    let y = sin(angle) * 80
                    
                    SettingsCircleButton(
                        icon: settingsIcons[index],
                        color: settingsColors[index]
                    ) {
                        handleSettingsAction(index)
                    }
                    .offset(x: x, y: y)
                }
                
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(DesignSystem.Colors.primaryBlue)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(DesignSystem.Spacing.xl)
            
            HexagonalGrid()
        }
    }
    
    private let settingsIcons = ["star.fill", "doc.text", "hand.raised.fill", "envelope.fill", "info.circle.fill", "questionmark.circle.fill"]
    private let settingsColors = [DesignSystem.Colors.warning, DesignSystem.Colors.primaryBlue, DesignSystem.Colors.success, DesignSystem.Colors.primaryBlue, DesignSystem.Colors.textSecondary, DesignSystem.Colors.lightBlue]
    
    private func handleSettingsAction(_ index: Int) {
        switch index {
        case 0: 
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        default:
            if let url = URL(string: "https://google.com") {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct SettingsCircleButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HexagonalGrid: View {
    var body: some View {
        VStack(spacing: -10) {
            HStack(spacing: -5) {
                HexagonButton(icon: "star.fill", title: "Rate", color: DesignSystem.Colors.warning)
                HexagonButton(icon: "doc.text", title: "Terms", color: DesignSystem.Colors.primaryBlue)
            }
            
            HStack(spacing: -5) {
                HexagonButton(icon: "hand.raised.fill", title: "Privacy", color: DesignSystem.Colors.success)
                HexagonButton(icon: "envelope.fill", title: "Contact", color: DesignSystem.Colors.primaryBlue)
            }
        }
    }
}

struct HexagonButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {
            if let url = URL(string: "https://google.com") {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(spacing: DesignSystem.Spacing.sm) {
                ZStack {
                    HexagonShape()
                        .fill(color.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(
                            HexagonShape()
                                .stroke(color.opacity(0.3), lineWidth: 2)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(FontManager.poppinsRegular(size: 12))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        var path = Path()
        
        for i in 0..<6 {
            let angle = Double(i) * .pi / 3
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    SettingsView()
}
