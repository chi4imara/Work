import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color.app.textPrimary)
                        
                        Text("Settings")
                            .font(.builderSans(.bold, size: 28))
                            .foregroundColor(Color.app.textPrimary)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 24) {
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Terms & Conditions",
                                    icon: "doc.text",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/1fb8133c-5207-4065-9b49-2e13c7df7606")
                                    }
                                )
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .frame(maxWidth: .infinity)
                                
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "hand.raised",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/e16a620c-64fe-4dfa-82ae-3ef6eead4a91")
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Support") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/e16a620c-64fe-4dfa-82ae-3ef6eead4a91")
                                    }
                                )
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .frame(maxWidth: .infinity)
                                
                                SettingsRow(
                                    title: "Rate App",
                                    icon: "star",
                                    action: {
                                        requestAppReview()
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.builderSans(.semiBold, size: 18))
                .foregroundColor(Color.app.textPrimary)
                .padding(.horizontal, 4)
            
            content
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.app.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.app.cardBorder, lineWidth: 1)
                        )
                )
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.yellow.opacity(0.1))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.yellow)
                    )
                
                Text(title)
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(Color.app.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.app.textTertiary)
            }
            .padding(16)
        }
    }
}

struct SettingsCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.builderSans(.semiBold, size: 16))
                        .foregroundColor(Color.app.textPrimary)
                    
                    Text(subtitle)
                        .font(.builderSans(.regular, size: 12))
                        .foregroundColor(Color.app.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.app.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DiagonalSettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let alignment: HorizontalAlignment
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if alignment == .trailing {
                    Spacer()
                }
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(Color.app.textPrimary)
                
                if alignment == .leading {
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(width: 250)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.app.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
