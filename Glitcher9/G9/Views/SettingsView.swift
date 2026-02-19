import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingPrivacyPolicy = false
    @State private var showingContactEmail = false
    
    let settingsItems: [SettingsItem] = [
        SettingsItem(
            title: "Privacy Policy",
            icon: "shield.checkered",
            color: AppColors.lightBlue
        ),
        SettingsItem(
            title: "Contact Us",
            icon: "envelope.fill",
            color: AppColors.orange
        ),
        SettingsItem(
            title: "Rate App",
            icon: "star.fill",
            color: AppColors.lightPurple
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppColors.buttonGradient)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.appWhite)
                        }
                        
                        Text("Settings")
                            .font(.playfairDisplay(size: 32, weight: .bold))
                            .foregroundColor(.appWhite)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 16) {
                        ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
                            SettingsCard(
                                item: item,
                                index: index,
                                onPrivacyPolicy: {
                                    if let url = URL(string: "https://www.termsfeed.com/live/1a0bf151-c623-4890-b865-99920ff5976d") {
                                        UIApplication.shared.open(url)
                                    }
                                },
                                onContactUs: {
                                    if let url = URL(string: "https://www.termsfeed.com/live/1a0bf151-c623-4890-b865-99920ff5976d") {
                                        UIApplication.shared.open(url)
                                    }
                                },
                                onRateApp: { requestAppReview() }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsItem {
    let title: String
    let icon: String
    let color: Color
}

struct SettingsCard: View {
    let item: SettingsItem
    let index: Int
    let onPrivacyPolicy: () -> Void
    let onContactUs: () -> Void
    let onRateApp: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                
                switch item.title {
                case "Privacy Policy":
                    onPrivacyPolicy()
                case "Contact Us":
                    onContactUs()
                case "Rate App":
                    onRateApp()
                default:
                    break
                }
            }
        }) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [item.color, item.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.appWhite)
                }
                
                Text(item.title)
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(.appWhite)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.appMediumGray)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [item.color.opacity(0.2), item.color.opacity(0.1)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [item.color.opacity(0.4), item.color.opacity(0.2)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1.5
                            )
                    )
            )
            .shadow(color: item.color.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
    }
}

struct WebView: View {
    let url: String
    let title: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "safari")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundColor(.appLightBlue)
                    
                    VStack(spacing: 12) {
                        Text("Opening \(title)")
                            .font(.playfairDisplay(size: 24, weight: .bold))
                            .foregroundColor(.appWhite)
                        
                        Text("This will redirect you to our website")
                            .font(.playfairDisplay(size: 16, weight: .regular))
                            .foregroundColor(.appMediumGray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text("Open in Safari")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                            
                            Image(systemName: "arrow.up.right.square")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.appWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(16)
                        .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(.appLightBlue)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    SettingsView()
}
