import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 32) {
                        AppInfoSection()
                        
                        CreativeSettingsLayout()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will permanently delete all your data. This action cannot be undone.")
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func resetAllData() {
        UserDefaults.standard.removeObject(forKey: "saved_rituals")
        UserDefaults.standard.removeObject(forKey: "daily_entries")
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        UserDefaults.standard.synchronize()
        
        appState.hasCompletedOnboarding = false
        appState.isFirstLaunch = true
        appState.isLoading = true
        
        print("All data reset successfully")
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("Mood Bloom")
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.text)
                
                Text("Take care of yourself every day")
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.text.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct CreativeSettingsLayout: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var store: AppDataStore
    @State private var showingResetAlert = false
    @State private var showingLoadSampleAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            SettingsButton(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Share your experience",
                color: AppColors.secondary,
                size: .large
            ) {
                requestAppReview()
            }
            
            HStack(spacing: 16) {
                SettingsButton(
                    icon: "envelope.fill",
                    title: "Contact",
                    subtitle: "Get in touch",
                    color: AppColors.primary,
                    size: .medium
                ) {
                    openEmail()
                }
                
                SettingsButton(
                    icon: "doc.text.fill",
                    title: "Privacy",
                    subtitle: "Read policy",
                    color: AppColors.accent,
                    size: .medium
                ) {
                    openPrivacyPolicy()
                }
            }
        }
        .alert("Load Sample Data", isPresented: $showingLoadSampleAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load") {
                store.loadSampleData()
            }
        } message: {
            Text("This will replace your current rituals and history with sample data for testing.")
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will permanently delete all your data. This action cannot be undone.")
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "https://www.termsfeed.com/live/7cfb3afc-d5f2-4b28-8066-ff08cb926fe7") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/7cfb3afc-d5f2-4b28-8066-ff08cb926fe7") {
            UIApplication.shared.open(url)
        }
    }
    
    private func resetAllData() {
        UserDefaults.standard.removeObject(forKey: "saved_rituals")
        UserDefaults.standard.removeObject(forKey: "daily_entries")
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        UserDefaults.standard.synchronize()
        
        appState.hasCompletedOnboarding = false
        appState.isFirstLaunch = true
        appState.isLoading = true
        
        print("All data reset successfully")
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let size: ButtonSize
    let action: () -> Void
    
    enum ButtonSize {
        case large, medium
        
        var height: CGFloat {
            switch self {
            case .large: return 120
            case .medium: return 120
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .large: return 28
            case .medium: return 24
            }
        }
        
        var titleSize: CGFloat {
            switch self {
            case .large: return 18
            case .medium: return 16
            }
        }
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(FontManager.playfairDisplay(size: size.titleSize, weight: .semibold))
                        .foregroundColor(AppColors.text)
                    
                    Text(subtitle)
                        .font(FontManager.playfairDisplay(size: 12))
                        .foregroundColor(AppColors.text.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
