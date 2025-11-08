import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var showingFontTest = false
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    settingsContent
                }
            }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                appInfoSection
                
                legalSection
                
                supportSection
                
                appVersionSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(AppTheme.primaryBlue)
                
                Text("Childhood Places")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Your personal archive of memories")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 20)
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Legal")
            
            VStack(spacing: 1) {
                SettingsRow(
                    title: "Terms of Use",
                    icon: "doc.text",
                    action: { openEmail(s: "https://docs.google.com/document/d/1FFRWxjFMHFmG_cUQcCMuby6BOiQZf7vaoWGT5fOd0tg/edit?usp=sharing")  }
                )
                
                Divider()
                    .frame(maxWidth: .infinity)
                
                SettingsRow(
                    title: "Privacy Policy",
                    icon: "hand.raised",
                    action: { openEmail(s: "https://docs.google.com/document/d/1eTQeHLkS8e5r6m0Hir9CG6b6uY9vVvuOUX8ehmjkCqI/edit?usp=sharing")  }
                )
            }
            .cardStyle()
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Support")
            
            VStack(spacing: 1) {
                SettingsRow(
                    title: "Contact Us",
                    icon: "envelope",
                    action: { openEmail(s: "https://forms.gle/5uFWoCY6auPucXs29") }
                )
                
                Divider()
                    .frame(maxWidth: .infinity)
                
                SettingsRow(
                    title: "Rate App",
                    icon: "star",
                    action: { requestReview() }
                )
            }
            .cardStyle()
        }
    }
    
    private var appVersionSection: some View {
        VStack(spacing: 8) {
            Text("Made with ❤️ for preserving memories")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 30)
    }
    
    private func openEmail(s: String) {
        if let url = URL(string: s) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
        }
        .padding(.bottom, 8)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryBlue.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.primaryBlue)
                }
                
                Text(title)
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WebView: View {
    let url: String
    let title: String
    @Environment(\.presentationMode) var presentationMode
    
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "globe")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppTheme.primaryBlue)
                    
                    Text("Opening External Link")
                        .font(AppTheme.headlineFont)
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("This will open in your default browser")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Open Link") {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .primaryButtonStyle()
                }
                .padding(40)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
