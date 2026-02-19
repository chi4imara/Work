import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingRateApp = false
    @State private var showingSampleDataLoaded = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsSection(title: "App Information") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "shield.fill",
                                    action: {
                                        openURL("https://www.freeprivacypolicy.com/live/33ff2b40-9ede-4c6a-b56a-aa484f126a88")
                                    }
                                )
                                
                                Divider()
                                    .background(AppColors.primaryAccent.opacity(0.25))
                                
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope.fill",
                                    action: {
                                        openURL("https://forms.gle/CStesUpTtp38SHm66")
                                    }
                                )
                                
                                Divider()
                                    .background(AppColors.primaryAccent.opacity(0.25))
                                
                                SettingsRow(
                                    title: "Rate the App",
                                    icon: "star.fill",
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "About") {
                            VStack(spacing: 16) {
                                VStack(spacing: 12) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(AppColors.softGradient)
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Image(systemName: "heart.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(AppColors.primaryText)
                                        )
                                    
                                    VStack(spacing: 4) {
                                        Text("Emotion & Harmony")
                                            .font(.ubuntu(20, weight: .bold))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                }
                                
                                Text("Your personal space for emotional wellness, mindfulness, and daily harmony.")
                                    .font(.ubuntu(14, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(2)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataLoaded) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sample habits and progress for the last 7 days have been loaded. You can now test the app with pre-filled data.")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
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
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            content
                .frame(maxWidth: .infinity)
                .background(AppColors.cardBackground)
                .cornerRadius(16)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 24)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct CreativeSettingsSection: View {
    @State private var animateIcons = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quick Actions")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(AppColors.cardBackground)
                    .frame(height: 200)
                
                VStack(spacing: 20) {
                    HStack(spacing: 40) {
                        CreativeActionButton(
                            icon: "envelope.fill",
                            title: "Email",
                            color: AppColors.info,
                            action: { openURL("https://google.com") }
                        )
                        .scaleEffect(animateIcons ? 1.1 : 1.0)
                        
                        CreativeActionButton(
                            icon: "star.fill",
                            title: "Rate",
                            color: AppColors.warning,
                            action: { requestReview() }
                        )
                        .scaleEffect(animateIcons ? 1.1 : 1.0)
                    }
                    
                    HStack(spacing: 60) {
                        CreativeActionButton(
                            icon: "shield.fill",
                            title: "Privacy",
                            color: AppColors.success,
                            action: { openURL("https://google.com") }
                        )
                        .scaleEffect(animateIcons ? 1.1 : 1.0)
                        
                        CreativeActionButton(
                            icon: "questionmark.circle.fill",
                            title: "Help",
                            color: AppColors.primaryAccent,
                            action: { openURL("https://google.com") }
                        )
                        .scaleEffect(animateIcons ? 1.1 : 1.0)
                    }
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    animateIcons = true
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct CreativeActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: AppViewModel())
}
