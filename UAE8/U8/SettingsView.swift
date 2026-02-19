import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                ScrollView {
                    VStack(spacing: 25) {
                        privacySection
                        contactSection
                        rateSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Privacy & Policy")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
                .padding(.bottom, 15)
            
            VStack(spacing: 12) {
                ModernSettingsButton(
                    icon: "lock.shield",
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    gradient: LinearGradient(
                        colors: [ColorManager.lightBlue, ColorManager.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                ) {
                    openURL("https://doc-hosting.flycricket.io/fitmode-plannow-privacy-policy/80f98ebe-9d55-4522-bd30-b2bccbd06c76/privacy")
                }
            }
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Contact & Support")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
                .padding(.bottom, 15)
            
            VStack(spacing: 12) {
                ModernSettingsButton(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    subtitle: "Get in touch with our team",
                    gradient: LinearGradient(
                        colors: [ColorManager.orange, ColorManager.red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                ) {
                    openURL("https://forms.gle/anCC5kVEf1GYGHWX6")
                }
            }
        }
    }
    
    private var rateSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Feedback")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
                .padding(.bottom, 15)
            
            ModernSettingsButton(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Share your experience",
                gradient: LinearGradient(
                    colors: [ColorManager.orange, ColorManager.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ) {
                requestReview()
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct ModernSettingsButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(ColorManager.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    Text(subtitle)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorManager.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.white.opacity(0.7))
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(gradient)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
    }
}

#Preview {
    SettingsView()
}
