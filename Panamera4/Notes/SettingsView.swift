import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.bellGothic(28, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSectionView(title: "App Information") {
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    icon: "info.circle.fill",
                                    title: "Privacy Policy",
                                    hasArrow: true
                                ) {
                                    if let url = URL(string: "https://doc-hosting.flycricket.io/hairstrand-notes-privacy-policy/7506dd6c-d3ee-42b9-a739-3fb13bf3f5e2/privacy") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                
                                Divider()
                                    .background(AppColors.darkGray.opacity(0.2))
                                    .padding(.horizontal, 16)
                                
                                SettingsRowView(
                                    icon: "envelope.fill",
                                    title: "Contact Us",
                                    hasArrow: true
                                ) {
                                    if let url = URL(string: "https://forms.gle/wHWhCTaMQAzqb4vB7") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }
                        }
                        
                        SettingsSectionView(title: "Support Us") {
                            SettingsRowView(
                                icon: "star.fill",
                                title: "Rate the App",
                                hasArrow: true
                            ) {
                                requestAppReview()
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("Hair Care Tracker")
                                .font(.bellGothic(16, weight: .bold))
                                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                        }
                        .padding(.top, 30)
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 120)
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
                .font(.bellGothic(18, weight: .bold))
                .foregroundColor(AppColors.primaryWhite)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let hasArrow: Bool
    let action: () -> Void
    
    init(icon: String, title: String, hasArrow: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.hasArrow = hasArrow
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 24)
                
                Text(title)
                    .font(.bellGothic(16, weight: .regular))
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                if hasArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.darkGray.opacity(0.4))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
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
                    Image(systemName: "globe")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                    
                    Text("This would open:")
                        .font(.bellGothic(18, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Text(url)
                        .font(.bellGothic(16, weight: .bold))
                        .foregroundColor(AppColors.accentYellow)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                    
                    Text("In a real app, this would be a web view or Safari.")
                        .font(.bellGothic(14, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    SettingsView()
        .primaryBackground()
}
