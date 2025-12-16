import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var showingContact = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Image(systemName: "gearshape.2")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Settings")
                            .font(.appTitle(28))
                            .foregroundColor(AppColors.primaryText)
                    }
                    .padding(.vertical, 30)
                    
                    VStack(spacing: 24) {
                        SettingsSectionView(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    icon: "star.circle",
                                    title: "Rate App",
                                    subtitle: "Share your feedback",
                                    action: { requestReview() }
                                )
                            }
                        }
                        
                        SettingsSectionView(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    icon: "doc.text",
                                    title: "Terms of Use",
                                    subtitle: "User agreement",
                                    action: {
                                        if let url = URL(string: "https://www.privacypolicies.com/live/29cced7c-17de-479e-9367-204e014b3cb0") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                                
                                Divider()
                                    .background(AppColors.secondaryText.opacity(0.2))
                                    .padding(.leading, 50)
                                
                                SettingsRowView(
                                    icon: "hand.raised",
                                    title: "Privacy Policy",
                                    subtitle: "Data protection policy",
                                    action: {
                                        if let url = URL(string: "https://www.privacypolicies.com/live/09129a3c-2c05-4f79-bbe8-4ec13dd8028d") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                            }
                        }
                        
                        SettingsSectionView(title: "Support") {
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    icon: "envelope.circle",
                                    title: "Contact Us",
                                    subtitle: "Get in touch",
                                    action: {
                                        if let url = URL(string: "https://www.privacypolicies.com/live/09129a3c-2c05-4f79-bbe8-4ec13dd8028d") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("Gift Ideas")
                                .font(.appHeadline(16))
                                .foregroundColor(AppColors.primaryText.opacity(0.8))
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
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
                .font(.appHeadline(18))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.appHeadline(16))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(subtitle)
                        .font(.appCaption(14))
                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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
                
                VStack(spacing: 24) {
                    Image(systemName: "globe")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.primaryText)
                    
                    VStack(spacing: 12) {
                        Text("Opening External Link")
                            .font(.appTitle(24))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("This will open in your default browser")
                            .font(.appBody(16))
                            .foregroundColor(AppColors.primaryText.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Open Link")
                            .font(.appHeadline(18))
                            .foregroundColor(AppColors.primaryBlue)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(AppColors.primaryText)
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}
