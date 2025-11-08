import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        rateAppSection
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "music.note")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.appPrimaryBlue)
                
                Text("TrackSoul")
                    .font(.appTitle2)
                    .foregroundColor(.appPrimaryText)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appBackgroundWhite)
                    .shadow(color: .appShadow, radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
        }
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(.appTitle3)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    action: {
                        openURL("https://docs.google.com/document/d/1mxa2tV-1XojGrQKArpoWIvQOMYYg2r8SC_8fWNY06bQ/edit?usp=sharing")
                    }
                )
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    action: {
                        openURL("https://docs.google.com/document/d/1rU3kiQ9WHKRm40YxAhfzSNA5wyRkD-y1yTPiY-eQaZs/edit?usp=sharing")
                    }
                )
            }
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(.appTitle3)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    action: {
                        openURL("https://forms.gle/5HuNMfRfoAXp6yZa7")
                    }
                )
            }
        }
    }
    
    private var rateAppSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Feedback")
                .font(.appTitle3)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "star",
                    title: "Rate the App",
                    action: {
                        requestReview()
                    }
                )
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.appPrimaryBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.appCallout)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.appSecondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appBackgroundWhite)
                    .shadow(color: .appShadow, radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appGridBlue, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

#Preview {
    SettingsView()
        .background(BackgroundView())
}
