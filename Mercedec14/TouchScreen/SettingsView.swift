import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject var bookingsViewModel: BookingsViewModel
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            Color.clear
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                                        
                    appSection
                    
                    supportSection
                    
                    legalSection
                    
                    appInfoSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .alert("Rate RelaxMe", isPresented: $viewModel.showingRateApp) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("Enjoying RelaxMe? Your rating helps us improve and reach more people seeking wellness.")
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
        }
    }
    
    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "arrow.down.circle.fill",
                    iconColor: ColorTheme.primaryBlue,
                    title: "Load Sample Data",
                    subtitle: "Load test masters, sessions, bookings and stress levels",
                    hasChevron: true
                ) {
                    appState.loadSampleData()
                    bookingsViewModel.reloadFromStorage()
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var appSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star.fill",
                    iconColor: ColorTheme.primaryYellow,
                    title: "Rate App",
                    subtitle: "Help us improve RelaxMe",
                    hasChevron: true
                ) {
                    viewModel.rateApp()
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "square.and.arrow.up",
                    iconColor: ColorTheme.primaryBlue,
                    title: "Share App",
                    subtitle: "Tell friends about RelaxMe",
                    hasChevron: true
                ) {
                    shareApp()
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "bell.fill",
                    iconColor: ColorTheme.warningOrange,
                    title: "Notifications",
                    subtitle: "Manage your notification preferences",
                    hasChevron: true
                ) {
                    openNotificationSettings()
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope.fill",
                    iconColor: ColorTheme.primaryBlue,
                    title: "Contact Email",
                    subtitle: "Get answers to common questions",
                    hasChevron: true
                ) {
                    viewModel.contactSupport()
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "hand.raised.fill",
                    iconColor: ColorTheme.textSecondary,
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    hasChevron: true
                ) {
                    viewModel.openPrivacyPolicy()
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [ColorTheme.primaryBlue, ColorTheme.primaryYellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text("RelaxMe")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("© 2026 RelaxMe. All rights reserved.")
                    .font(.ubuntu(10, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .padding(.top, 8)
            }
        }
        .padding(.top, 20)
    }
    
    private func shareApp() {
        let shareText = "Check out RelaxMe - the best app for booking massage and SPA sessions!"
        let activityController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
    
    private func openNotificationSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    private func openHelpCenter() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func reportIssue() {
        if let url = URL(string: "mailto:support@relaxme.com?subject=Issue%20Report") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfService() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let hasChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if hasChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary.opacity(0.6))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

struct CreativeSettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                
                ScrollView {
                    VStack(spacing: 30) {
                        ZStack {
                            ForEach(0..<5, id: \.self) { index in
                                Circle()
                                    .fill(ColorTheme.bubbleBlue.opacity(0.3))
                                    .frame(width: CGFloat.random(in: 20...40))
                                    .offset(
                                        x: CGFloat.random(in: -100...100),
                                        y: CGFloat.random(in: -50...50)
                                    )
                            }
                            
                            Text("Settings")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(ColorTheme.textPrimary)
                        }
                        .frame(height: 80)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            
                            HexagonButton(
                                icon: "star.fill",
                                title: "Rate App",
                                color: ColorTheme.primaryYellow,
                                size: .large
                            ) {
                                viewModel.rateApp()
                            }
                            
                            HexagonButton(
                                icon: "hand.raised.fill",
                                title: "Privacy",
                                color: ColorTheme.primaryBlue,
                                size: .medium
                            ) {
                                viewModel.openPrivacyPolicy()
                            }
                            
                            HexagonButton(
                                icon: "envelope.fill",
                                title: "Contact",
                                color: ColorTheme.successGreen,
                                size: .medium
                            ) {
                                viewModel.contactSupport()
                            }
                            
                            HexagonButton(
                                icon: "square.and.arrow.up",
                                title: "Share",
                                color: ColorTheme.warningOrange,
                                size: .large
                            ) {
                                shareApp()
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 20) {
                            FloatingActionButton(
                                icon: "bell.fill",
                                color: ColorTheme.primaryBlue
                            ) {
                                openNotificationSettings()
                            }
                            
                            FloatingActionButton(
                                icon: "questionmark.circle.fill",
                                color: ColorTheme.successGreen
                            ) {
                                openHelpCenter()
                            }
                            
                            FloatingActionButton(
                                icon: "doc.text.fill",
                                color: ColorTheme.textSecondary
                            ) {
                                openTermsOfService()
                            }
                        }
                        
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                ColorTheme.primaryBlue.opacity(0.2),
                                                ColorTheme.primaryYellow.opacity(0.1)
                                            ],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 50
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryBlue)
                            }
                            
                            VStack(spacing: 4) {
                                Text("RelaxMe v1.0.0")
                                    .font(.ubuntu(16, weight: .bold))
                                    .foregroundColor(ColorTheme.textPrimary)
                                
                                Text("Your wellness companion")
                                    .font(.ubuntu(12, weight: .regular))
                                    .foregroundColor(ColorTheme.textSecondary)
                            }
                        }
                        .padding(.top, 30)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Rate RelaxMe", isPresented: $viewModel.showingRateApp) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("Enjoying RelaxMe? Your rating helps us improve and reach more people seeking wellness.")
        }
    }
    
    private func shareApp() {
        let shareText = "Check out RelaxMe - the best app for booking massage and SPA sessions!"
        let activityController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
    
    private func openNotificationSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    private func openHelpCenter() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfService() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct HexagonButton: View {
    let icon: String
    let title: String
    let color: Color
    let size: ButtonSize
    let action: () -> Void
    
    enum ButtonSize {
        case medium, large
        
        var dimension: CGFloat {
            switch self {
            case .medium: return 80
            case .large: return 100
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .medium: return 20
            case .large: return 28
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: size.dimension * 0.2)
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size.dimension, height: size.dimension)
                        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
            }
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: 1.0)
    }
}

struct FloatingActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                )
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppStateManager())
        .environmentObject(BookingsViewModel())
}
