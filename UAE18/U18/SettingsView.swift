import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContent
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(.bold, size: 32))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                appSection
                
                supportSection
                
                legalSection
                
                statisticsSection
                
                aboutSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 120)
        }
    }
    
    private var appSection: some View {
        SettingsSection(title: "App") {
            SettingsRow(
                icon: "star.fill",
                title: "Rate App",
                iconColor: AppColors.orange
            ) {
                requestAppReview()
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Us",
                iconColor: AppColors.lightBlue
            ) {
                openURL("https://forms.gle/8qqnCie2fUwRKCRP9")
            }
        }
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            SettingsRow(
                icon: "doc.text.fill",
                title: "Privacy Policy",
                iconColor: AppColors.accent
            ) {
                openURL("https://doc-hosting.flycricket.io/sets-coreline-privacy-policy/e39e314e-95e5-46b4-ba9c-2063d276ec1d/privacy")
            }
        }
    }
    
    private var statisticsSection: some View {
        SettingsSection(title: "Statistics") {
            VStack(spacing: 0) {
                StatisticsRow(
                    title: "Total Workouts",
                    value: "\(workoutManager.workouts.count)",
                    icon: "list.clipboard",
                    iconColor: AppColors.lightBlue
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                StatisticsRow(
                    title: "Total Exercises",
                    value: "\(totalExercises)",
                    icon: "figure.strengthtraining.traditional",
                    iconColor: AppColors.orange
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                StatisticsRow(
                    title: "Personal Bests",
                    value: "\(personalBestsCount)",
                    icon: "crown.fill",
                    iconColor: AppColors.accent
                )
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About")
                .font(.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                    
                    Text("Friends Fitness")
                        .font(.ubuntu(.bold, size: 20))
                        .foregroundColor(AppColors.primaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                
                Text("Track your bodyweight exercises and monitor your fitness progress with ease.")
                    .font(.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    private var totalExercises: Int {
        workoutManager.workouts.reduce(0) { $0 + $1.exercises.count }
    }
    
    private var personalBestsCount: Int {
        workoutManager.workouts.filter { workoutManager.hasPersonalBest($0) }.count
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
                .font(.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
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
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.ubuntu(.medium, size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct StatisticsRow: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            Text(title)
                .font(.ubuntu(.medium, size: 16))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(.bold, size: 16))
                .foregroundColor(iconColor)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    SettingsView()
        .environmentObject(WorkoutManager())
}
