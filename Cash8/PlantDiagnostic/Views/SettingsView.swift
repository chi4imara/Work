import SwiftUI
import UIKit
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    settingsContent
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("If you enjoy using our plant care app, please take a moment to rate it. Your feedback helps us improve!")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.titleLarge)
                .foregroundColor(.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var settingsContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                settingsSection(title: "App") {
                    SettingsRowView(
                        icon: "star.fill",
                        title: "Rate App",
                        iconColor: .yellow
                    ) {
                        showingRateAlert = true
                    }
                }
                
                settingsSection(title: "Legal & Privacy") {
                    SettingsRowView(
                        icon: "doc.text.fill",
                        title: "Terms of Use",
                        iconColor: .accentBlue
                    ) {
                        openURL("https://google.com")
                    }
                    
                    SettingsRowView(
                        icon: "hand.raised.fill",
                        title: "Privacy Policy",
                        iconColor: .accentPurple
                    ) {
                        openURL("https://google.com")
                    }
                }
                
                settingsSection(title: "Support") {
                    SettingsRowView(
                        icon: "envelope.fill",
                        title: "Contact Us",
                        iconColor: .accentOrange
                    ) {
                        openURL("https://google.com")
                    }
                }
                
                appInfoSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.titleSmall)
                .foregroundColor(.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content()
            }
            .background(Color.cardBackground)
            .cornerRadius(12)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 40))
                .foregroundColor(.accentGreen)
            
            Text("Plant Care Assistant")
                .font(.titleMedium)
                .foregroundColor(.primaryText)
            
            Text("Your personal guide to plant care")
                .font(.bodySmall)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 20)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}


