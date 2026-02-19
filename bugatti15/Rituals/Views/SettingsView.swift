import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    @State private var showingSampleDataAlert = false
    @State private var showingSampleDataLoaded = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                SettingsHeaderView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        AppInfoSection()
                        
                        SupportSection(onRateApp: {
                            requestAppReview()
                        })
                        
                        LegalSection()
                        
                        AboutSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Not Now", role: .cancel) { }
            Button("Rate App") {
                requestAppReview()
            }
        } message: {
            Text("If you enjoy using our app, please take a moment to rate it. Thanks for your support!")
        }
        .alert("Load Sample Data", isPresented: $showingSampleDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load") {
                DataManager.shared.loadSampleData()
                showingSampleDataLoaded = true
            }
        } message: {
            Text("This will replace your current goals and history with sample data for testing. Continue?")
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataLoaded) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Switch to Today or My Pleasures to see the sample data.")
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Personalize your experience")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "gearshape.fill")
                .font(.system(size: 32))
                .foregroundColor(AppColors.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppColors.secondary.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 36))
                        .foregroundColor(AppColors.secondary)
                }
                
                VStack(spacing: 4) {
                    Text("Emotional Diary")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Your daily mood companion")
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct SupportSection: View {
    let onRateApp: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                SettingsRowView(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    subtitle: "Get help and support",
                    action: {
                        openURL("https://forms.gle/i7cUoLvL5DU8Lwm9A")
                    }
                )
                
                SettingsRowView(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Share your experience",
                    action: onRateApp
                )
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct SampleDataSection: View {
    let onLoadSampleData: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Testing")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                SettingsRowView(
                    icon: "doc.badge.plus",
                    title: "Load Sample Data",
                    subtitle: "Fill app with sample goals and history",
                    action: onLoadSampleData
                )
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct LegalSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                SettingsRowView(
                    icon: "doc.text.fill",
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    action: {
                        openURL("https://doc-hosting.flycricket.io/happypath-rituals-privacy-policy/95a95350-11a8-4512-8c2a-36ac50552de8/privacy")
                    }
                )
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct AboutSection: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("About")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                Text("Emotional Diary helps you track your daily mood, set meaningful goals, and create positive habits. Take small steps towards a happier, more mindful life.")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textSecondary)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                
                Text("Made with ❤️ for your wellbeing")
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.textSecondary)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.secondary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.vertical, 8)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

private func openURL(_ urlString: String) {
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}

#Preview {
    SettingsView()
}
