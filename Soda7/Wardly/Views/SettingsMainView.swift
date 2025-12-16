import SwiftUI
import StoreKit

struct SettingsMainView: View {
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var showingContact = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        headerView
                        
                        VStack(spacing: 24) {
                            legalSection
                            supportSection
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 80)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.purpleGradient)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 4) {
                Text("Wardly")
                    .font(AppTypography.title1)
                    .foregroundColor(AppColors.primaryPurple)
                
                Text("Plan your wardrobe wisely")
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.neutralGray)
            }
        }
        .padding(.bottom, 32)
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms and Conditions",
                    iconColor: AppColors.blueText
                ) {
                    if let url = URL(string: "https://www.privacypolicies.com/live/b54f5f24-52b8-46dc-9342-fd5f45d8064e") {
                        UIApplication.shared.open(url)
                    }
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    iconColor: AppColors.successGreen
                ) {
                    if let url = URL(string: "https://www.privacypolicies.com/live/cbb06622-b4d1-4e9d-baa4-eae08269d9ae") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    iconColor: AppColors.warningOrange
                ) {
                    if let url = URL(string: "https://www.privacypolicies.com/live/cbb06622-b4d1-4e9d-baa4-eae08269d9ae") {
                        UIApplication.shared.open(url)
                    }
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "star",
                    title: "Rate App",
                    iconColor: AppColors.yellowAccent
                ) {
                    requestAppReview()
                }
            }
        }
    }
    
    private var appSection: some View {
        SettingsSection(title: "App Info") {
            VStack(spacing: 16) {
                HStack {
                    Text("Version")
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.neutralGray)
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.darkGray)
                }
                
                HStack {
                    Text("Build")
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.neutralGray)
                    
                    Spacer()
                    
                    Text("1")
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.darkGray)
                }
            }
            .padding(16)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.neutralGray)
                .padding(.horizontal, 4)
            
            content
                .cardStyle()
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.neutralGray)
            }
            .padding(16)
        }
    }
}

struct CreativeSettingsLayout: View {
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var showingContact = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerWithDiagonalLayout
                    
                    hexagonalButtonLayout
                    
                    floatingActionButtons
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
        }
    }
    
    private var headerWithDiagonalLayout: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.purpleGradient)
                .frame(height: 120)
                .rotationEffect(.degrees(-2))
            
            VStack(spacing: 8) {
                Text("Settings")
                    .font(AppTypography.title1)
                    .foregroundColor(.white)
                
                Text("Customize your experience")
                    .font(AppTypography.callout)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.vertical, 20)
    }
    
    private var hexagonalButtonLayout: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Spacer()
                
                HexagonButton(
                    icon: "doc.text",
                    title: "Terms",
                    color: AppColors.blueText
                ) {
                    showingTerms = true
                }
                
                HexagonButton(
                    icon: "hand.raised",
                    title: "Privacy",
                    color: AppColors.successGreen
                ) {
                    showingPrivacy = true
                }
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                HexagonButton(
                    icon: "envelope",
                    title: "Contact",
                    color: AppColors.warningOrange
                ) {
                    showingContact = true
                }
                
                HexagonButton(
                    icon: "star",
                    title: "Rate",
                    color: AppColors.yellowAccent
                ) {
                    requestAppReview()
                }
            }
            .offset(x: 60)
        }
    }
    
    private var floatingActionButtons: some View {
        HStack(spacing: 40) {
            FloatingButton(
                icon: "info.circle",
                title: "Version 1.0.0",
                color: AppColors.neutralGray
            ) { }
            
            FloatingButton(
                icon: "heart.circle",
                title: "Made with ♥",
                color: AppColors.primaryPurple
            ) { }
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct HexagonButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.3), lineWidth: 2)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.darkGray)
                    .fontWeight(.medium)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FloatingButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundColor(color)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsMainView()
}
