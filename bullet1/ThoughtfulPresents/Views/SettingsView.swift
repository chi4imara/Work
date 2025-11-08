import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage(Constants.UserDefaultsKeys.onboardingComplete) private var isOnboardingComplete = false
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Settings")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                    }
                    .padding(.top)
                    
                    SettingsSection {
                        VStack(spacing: 20) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.theme.primaryBlue)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "gift.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(spacing: 8) {
                                Text("Thoughtful Presents")
                                    .font(.theme.title2)
                                    .foregroundColor(Color.theme.primaryText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                    
                    SettingsSection {
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "doc.text",
                                title: "Terms of Use",
                                showChevron: true
                            ) {
                                openURL("https://www.termsfeed.com/live/901eacfc-357c-4ae5-b786-c830dd99a2a8")
                            }
                            
                            Divider()
                                .padding(.leading, 44)
                            
                            SettingsRow(
                                icon: "hand.raised",
                                title: "Privacy Policy",
                                showChevron: true
                            ) {
                                openURL("https://www.termsfeed.com/live/fb62390d-2e49-4d56-8dba-3405e4062673")
                            }
                        }
                    }
                    
                    SettingsSection {
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "envelope",
                                title: "Contact Us",
                                showChevron: true
                            ) {
                                openURL("https://www.termsfeed.com/live/fb62390d-2e49-4d56-8dba-3405e4062673")
                            }
                            
                            Divider()
                                .padding(.leading, 44)
                            
                            SettingsRow(
                                icon: "star",
                                title: "Rate App",
                                showChevron: true
                            ) {
                                requestReview()
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .alert("Reset Onboarding", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                isOnboardingComplete = false
            }
        } message: {
            Text("This will show the onboarding screens again on next app launch.")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let showChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Color.theme.primaryBlue)
                    .frame(width: 28, height: 28)
                
                Text(title)
                    .font(.theme.body)
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
