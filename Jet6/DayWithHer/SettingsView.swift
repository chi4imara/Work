import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    VStack(spacing: 16) {
                        legalSection
                        
                        supportSection
                        
                        appSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.purpleGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
                .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 4) {
                Text("Day With Her")
                    .font(.playfair(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.bottom, 20)
    }
    
    private var legalSection: some View {
        SettingsSectionView(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRowView(
                    icon: "doc.text",
                    title: "Terms of Use",
                    action: {
                        if let url = URL(string: "https://www.termsfeed.com/live/af8b67b1-1052-43da-b37d-8594ebd61148") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                Divider()
                    .background(AppColors.lightPurple)
                    .padding(.leading, 50)
                
                SettingsRowView(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    action: {
                        if let url = URL(string: "https://www.termsfeed.com/live/c3f54f29-c1e1-4c7d-97b5-236472fb2d53") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSectionView(title: "Support") {
            VStack(spacing: 0) {
                SettingsRowView(
                    icon: "envelope",
                    title: "Contact Us",
                    action: {
                        if let url = URL(string: "https://www.termsfeed.com/live/c3f54f29-c1e1-4c7d-97b5-236472fb2d53") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                Divider()
                    .background(AppColors.lightPurple)
                    .padding(.leading, 50)
                
                SettingsRowView(
                    icon: "star",
                    title: "Rate App",
                    action: { requestReview() }
                )
            }
        }
    }
    
    private var appSection: some View {
        SettingsSectionView(title: "About") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Day With Her helps you keep track of all the wonderful moments and ideas you want to share with your friends. Plan activities, create memories, and cherish every moment together.")
                    .font(.playfair(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineSpacing(2)
                
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.yellowAccent)
                    
                    Text("Made with love for friendship")
                        .font(.playfair(size: 12, weight: .medium))
                        .foregroundColor(AppColors.blueText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
    
    private func requestReview() {
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
                .font(.playfair(size: 18, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.blueText)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfair(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.lightText)
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
                        .foregroundColor(AppColors.blueText)
                    
                    VStack(spacing: 12) {
                        Text("Opening \(title)")
                            .font(.playfair(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("This will redirect you to our website")
                            .font(.playfair(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Continue")
                            .font(.playfair(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.purpleGradient)
                            .cornerRadius(25)
                            .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    SettingsView()
}
