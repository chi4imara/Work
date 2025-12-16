import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                VStack(spacing: 16) {
                    legalSection
                    
                    supportSection
                    
                    appInfoSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 80)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Settings")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            Text("App preferences and information")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "doc.text",
                title: "Terms and Conditions",
                action: {
                    if let url = URL(string: "https://www.privacypolicies.com/live/9c1b1f8f-ce1c-4236-9a7c-10d992959f49") {
                        UIApplication.shared.open(url)
                    }
                }
            )
            
            Divider()
                .background(Color.appCardBorder)
            
            SettingsRow(
                icon: "hand.raised",
                title: "Privacy Policy",
                action: {
                    if let url = URL(string: "https://www.privacypolicies.com/live/3115d0c1-8aed-4e3d-8b64-f5fb390b9cf1") {
                        UIApplication.shared.open(url)
                    }
                }
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "envelope",
                title: "Contact Us",
                action: {
                    if let url = URL(string: "https://www.privacypolicies.com/live/3115d0c1-8aed-4e3d-8b64-f5fb390b9cf1") {
                        UIApplication.shared.open(url)
                    }
                }
            )
            
            Divider()
                .background(Color.appCardBorder)
            
            SettingsRow(
                icon: "star",
                title: "Rate the App",
                action: requestAppReview
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            Text("UrbanScent")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            Text("Capture the scent of your city, one day at a time.")
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private func requestAppReview() {
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
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.appPrimaryYellow)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.appTextTertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct WebViewSheet: View {
    let url: String
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    Image(systemName: "globe")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(.appTextTertiary)
                    
                    Text("Opening \(title)")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.appTextPrimary)
                    
                    Text("This would normally open a web view to \(url)")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                    
                    CustomButton(title: "Close", action: { dismiss() })
                }
                .padding(40)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.appPrimaryYellow)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        SettingsView()
    }
}
