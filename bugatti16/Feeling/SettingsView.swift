import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var showSampleDataAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    SettingsHeaderSection()
                    
                    VStack(spacing: AppSpacing.lg) {
                        HStack(spacing: AppSpacing.md) {
                            SettingsCard(
                                title: "Privacy Policy",
                                icon: "shield.checkered",
                                color: AppColors.primary,
                                action: {
                                    if let url = URL(string: "https://doc-hosting.flycricket.io/moodpetals-feeling-privacy-policy/a35a267c-65ea-4047-90db-64a09bc903fd/privacy") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            )
                            
                            SettingsCard(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                color: AppColors.secondary,
                                action: {
                                    if let url = URL(string: "https://forms.gle/kE4JtLskzRBPrGwh8") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            )
                        }
                        
                        HStack(spacing: AppSpacing.md) {
                            SettingsCard(
                                title: "Rate App",
                                icon: "star.fill",
                                color: AppColors.accent,
                                action: {
                                    requestAppReview()
                                }
                            )
                            
                           Spacer()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    AppInfoSection()
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
        .alert("Load Sample Data", isPresented: $showSampleDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load") {
                viewModel.loadSampleData()
            }
        } message: {
            Text("This will replace your current data with sample entries, rituals and progress for testing. Continue?")
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsHeaderSection: View {
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 35, weight: .light))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: AppSpacing.xs) {
                Text("Mood Bloom")
                    .font(AppFonts.playfairBold(size: 24))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Your wellness companion")
                    .font(AppFonts.playfairRegular(size: 16))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.top, AppSpacing.xl)
    }
}

struct SettingsCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(AppAnimations.quick) {
                isPressed = true
            }
            
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }) {
            VStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                        .scaleEffect(isPressed ? 1.1 : 1.0)
                }
                
                Text(title)
                    .font(AppFonts.playfairSemiBold(size: 16))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
            .cornerRadius(AppRadius.lg)
            .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(AppAnimations.bouncy, value: isPressed)
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            VStack(spacing: AppSpacing.sm) {
                Text("\"Taking care of yourself is the most important investment you can make.\"")
                    .font(AppFonts.playfairRegular(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .italic()
                
                Text("Keep growing, keep blooming 🌸")
                    .font(AppFonts.playfairMedium(size: 14))
                    .foregroundColor(AppColors.primary)
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [AppColors.primary.opacity(0.05), AppColors.accent.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppRadius.md)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.playfairMedium(size: 14))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(AppFonts.playfairRegular(size: 14))
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

struct ContactSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingMailComposer = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: AppSpacing.xl) {
                    VStack(spacing: AppSpacing.md) {
                        Image(systemName: "envelope.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.secondary)
                        
                        Text("Get in Touch")
                            .font(AppFonts.playfairBold(size: 24))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("We'd love to hear from you! Send us your feedback, questions, or suggestions.")
                            .font(AppFonts.playfairRegular(size: 16))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppSpacing.md)
                    }
                    .padding(.top, AppSpacing.xl)
                    
                    VStack(spacing: AppSpacing.md) {
                        ContactButton(
                            title: "Send Email",
                            subtitle: "support@moodbloom.com",
                            icon: "envelope.fill",
                            color: AppColors.primary,
                            action: {
                                openEmail()
                            }
                        )
                        
                        ContactButton(
                            title: "Visit Website",
                            subtitle: "Learn more about us",
                            icon: "globe",
                            color: AppColors.secondary,
                            action: {
                                openWebsite()
                            }
                        )
                        
                        ContactButton(
                            title: "Follow Updates",
                            subtitle: "Stay connected with us",
                            icon: "heart.circle.fill",
                            color: AppColors.accent,
                            action: {
                                openSocial()
                            }
                        )
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                            .font(AppFonts.playfairMedium(size: 16))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openWebsite() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openSocial() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct ContactButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(title)
                        .font(AppFonts.playfairSemiBold(size: 16))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.playfairRegular(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
            .cornerRadius(AppRadius.md)
            .shadow(color: color.opacity(0.1), radius: 3, x: 0, y: 1)
        }
    }
}

struct WebView: View {
    let url: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: AppSpacing.lg) {
                    Text("Privacy Policy")
                        .font(AppFonts.playfairBold(size: 24))
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.top, AppSpacing.xl)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Your Privacy Matters")
                                .font(AppFonts.playfairSemiBold(size: 18))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("At Mood Bloom, we are committed to protecting your privacy and ensuring the security of your personal information.")
                                .font(AppFonts.playfairRegular(size: 16))
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text("Data Collection")
                                .font(AppFonts.playfairSemiBold(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.top, AppSpacing.md)
                            
                            Text("• All mood tracking data is stored locally on your device\n• We do not collect or transmit personal wellness information\n• App usage analytics may be collected to improve user experience\n• No personal identification is required or stored")
                                .font(AppFonts.playfairRegular(size: 14))
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text("Data Security")
                                .font(AppFonts.playfairSemiBold(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.top, AppSpacing.md)
                            
                            Text("Your wellness journey is personal. All mood entries, rituals, and progress data remain private and secure on your device.")
                                .font(AppFonts.playfairRegular(size: 14))
                                .foregroundColor(AppColors.textSecondary)
                            
                            Button(action: {
                                if let url = URL(string: url) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Text("View Full Privacy Policy")
                                    .font(AppFonts.playfairSemiBold(size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.primary)
                                    .cornerRadius(AppRadius.md)
                            }
                            .padding(.top, AppSpacing.lg)
                        }
                        .padding(.horizontal, AppSpacing.md)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                            .font(AppFonts.playfairMedium(size: 16))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SettingsView()
}
