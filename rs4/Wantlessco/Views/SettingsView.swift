import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Customize your experience")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.leading, 60)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    VStack(spacing: 16) {
                        SettingsCard(
                            icon: "shield.fill",
                            title: "Privacy Policy",
                            subtitle: "Read our privacy policy",
                            color: AppColors.primaryPurple
                        ) {
                            if let url = URL(string: "https://www.freeprivacypolicy.com/live/ff815c86-c3c9-41bd-aef0-0d047c918d28") {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                        SettingsCard(
                            icon: "envelope.fill",
                            title: "Contact Us",
                            subtitle: "Get in touch with us",
                            color: AppColors.wantColor
                        ) {
                            if let url = URL(string: "https://forms.gle/cSzVJ38JRyxJS2PY8") {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                        SettingsCard(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Share your feedback",
                            color: AppColors.dontWantColor
                        ) {
                            requestReview()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
    }
}

struct WebView: View {
    let url: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    Text("Opening External Link")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("This would open: \(url)")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button("Open in Safari") {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.buttonText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(AppColors.buttonBackground)
                    .cornerRadius(8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}
