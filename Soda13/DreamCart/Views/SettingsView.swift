import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    
                    VStack(spacing: 24) {
                        legalSection
                        supportSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    .padding(.bottom, 70)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.purpleGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
            
            Text("Beauty Diary")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
        }
        .padding(.top, 40)
    }
    
    private var legalSection: some View {
        SettingsSectionView(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Terms of Use",
                    icon: "doc.text",
                    action: { openURL("https://www.termsfeed.com/live/ea86127f-b157-4c80-a0b2-8c9ef9d733d8") }
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRowView(
                    title: "Privacy Policy",
                    icon: "lock.shield",
                    action: { openURL("https://www.termsfeed.com/live/3d5077a2-b497-46ac-8afe-0d0e2d53a943") }
                )
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSectionView(title: "Support") {
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Contact Us",
                    icon: "envelope",
                    action: { openURL("https://www.termsfeed.com/live/3d5077a2-b497-46ac-8afe-0d0e2d53a943") }
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRowView(
                    title: "Rate App",
                    icon: "star",
                    action: { requestReview() }
                )
            }
        }
    }
    
    private var aboutSection: some View {
        SettingsSectionView(title: "About") {
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "License Agreement",
                    icon: "doc.badge.gearshape",
                    action: { openURL("https://google.com") }
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRowView(
                    title: "Data Protection Policy",
                    icon: "shield.checkerboard",
                    action: { openURL("https://google.com") }
                )
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
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 4)
            
            content
                .background(Color.theme.cardBackground)
                .cornerRadius(16)
                .shadow(color: Color.theme.cardShadow, radius: 2, x: 0, y: 1)
        }
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.primaryBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
