import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var appState: AppStateViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        ratingSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.bottom, 8)
                
                Text("Style Diary")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Capture your daily style")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
        }
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                SettingsRowView(
                    title: "Terms of Use",
                    icon: "doc.text",
                    action: {
                        openURL("https://www.privacypolicies.com/live/026f586e-9e0a-4e8b-a009-dadc482ad524")
                    }
                )
                
                SettingsRowView(
                    title: "Privacy Policy",
                    icon: "hand.raised",
                    action: {
                        openURL("https://www.privacypolicies.com/live/04eee6bd-fab1-4544-940a-c8f721f62529")
                    }
                )
            }
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                SettingsRowView(
                    title: "Contact Us",
                    icon: "envelope",
                    action: {
                        openURL("https://www.privacypolicies.com/live/04eee6bd-fab1-4544-940a-c8f721f62529")
                    }
                )
            }
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Feedback")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                SettingsRowView(
                    title: "Rate the App",
                    icon: "star",
                    action: {
                        appState.requestAppReview()
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
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(ColorManager.cardGradient)
            .cornerRadius(12)
        }
    }
}

#Preview {
    SettingsView(appState: AppStateViewModel())
}

