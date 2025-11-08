import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.dreamTitle)
                        .foregroundColor(.dreamWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 8)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSectionView(title: "About") {
                            VStack(spacing: 16) {
                                AppInfoView()
                            }
                        }
                        
                        SettingsSectionView(title: "Legal") {
                            VStack(spacing: 12) {
                                SettingsRowView(
                                    title: "Terms of Use",
                                    icon: "doc.text",
                                    action: { openURL("https://docs.google.com/document/d/1w-qCI17H42D1BSF52YGJ2D-vrsqRhyGIpkF1jq-c2Xw/edit?usp=sharing") }
                                )
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                
                                SettingsRowView(
                                    title: "Privacy Policy",
                                    icon: "hand.raised",
                                    action: { openURL("https://docs.google.com/document/d/1HITSE7Fy_c4l88jNb8kdqwkpetwXfVV2oliV2Iax2ZU/edit?usp=sharing") }
                                )
                            }
                        }
                        
                        SettingsSectionView(title: "Support") {
                            VStack(spacing: 12) {
                                SettingsRowView(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    action: { openURL("https://forms.gle/Nm2Ut4Bxr9WnQJ8p6") }
                                )
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                
                                SettingsRowView(
                                    title: "Rate App",
                                    icon: "star",
                                    action: { requestReview() }
                                )
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
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

struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.dreamHeadline)
                .foregroundColor(.dreamWhite)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.dreamWhite.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.dreamYellow)
                    .font(.title3)
                    .frame(width: 24)
                
                Text(title)
                    .font(.dreamBody)
                    .foregroundColor(.dreamWhite)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.dreamWhite.opacity(0.5))
                    .font(.caption)
            }
            .padding(16)
        }
    }
}

struct AppInfoView: View {
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.dreamYellow, Color.dreamPink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text("DreamBloom")
                    .font(.dreamHeadline)
                    .foregroundColor(.dreamWhite)
            }
            
            Text("Your personal dream journal for capturing and understanding your sleep experiences")
                .font(.dreamBody)
                .foregroundColor(.dreamWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    SettingsView()
}
