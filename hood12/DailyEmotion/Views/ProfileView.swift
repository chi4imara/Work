import SwiftUI
import StoreKit

struct ProfileView: View {
    @ObservedObject var dataManager: EmotionDataManager
    @State private var userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State private var showEditName = false
    @State private var showExportOptions = false
    @State private var showDeleteAllAlert = false
    @State private var showResetOnboardingAlert = false
    @State private var enableNotifications = UserDefaults.standard.bool(forKey: "NotificationsEnabled")
    @State private var reminderTime = Date()
    
    private var userStats: UserStats {
        calculateUserStats()
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Profile")
                        .font(.poppinsBold(size: 24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        ProfileHeaderView(
                            userName: userName.isEmpty ? "Emotion Tracker" : userName,
                            stats: userStats
                        ) {
                            showEditName = true
                        }
                        
                        QuickStatsView(stats: userStats)
                        
                        PreferencesSection(
                            enableNotifications: $enableNotifications,
                            reminderTime: $reminderTime
                        )
                        
                        DataManagementSection(
                            onExport: { showExportOptions = true },
                            onDeleteAll: { showDeleteAllAlert = true }
                        )
                        
                        AppSettingsSection(
                            onResetOnboarding: { showResetOnboardingAlert = true },
                            onRateApp: { requestReview() }
                        )
                        
                        AboutSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showEditName) {
            EditNameSheet(userName: $userName)
        }
        .actionSheet(isPresented: $showExportOptions) {
            ActionSheet(
                title: Text("Export Data"),
                message: Text("Choose export format"),
                buttons: [
                    .default(Text("Export as Text")) {
                        exportDataAsText()
                    },
                    .default(Text("Share Summary")) {
                        shareSummary()
                    },
                    .cancel()
                ]
            )
        }
        .alert("Delete All Data", isPresented: $showDeleteAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("This will permanently delete all your emotion entries. This action cannot be undone.")
        }
        .alert("Reset Onboarding", isPresented: $showResetOnboardingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset") {
                resetOnboarding()
            }
        } message: {
            Text("The onboarding screens will appear immediately.")
        }
        .onChange(of: userName) { newValue in
            UserDefaults.standard.set(newValue, forKey: "UserName")
        }
        .onChange(of: enableNotifications) { newValue in
            UserDefaults.standard.set(newValue, forKey: "NotificationsEnabled")
        }
    }
    
    private func calculateUserStats() -> UserStats {
        let totalEntries = dataManager.entries.count
        let uniqueDays = Set(dataManager.entries.map { 
            Calendar.current.startOfDay(for: $0.date) 
        }).count
        
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentEntries = dataManager.entries.filter { $0.date >= thirtyDaysAgo }
        
        let emotionCounts = Dictionary(grouping: dataManager.entries, by: { $0.emotion })
            .mapValues { $0.count }
        let favoriteEmotion = emotionCounts.max(by: { $0.value < $1.value })?.key
        
        let joinDate = UserDefaults.standard.object(forKey: "JoinDate") as? Date ?? {
            let date = Date()
            UserDefaults.standard.set(date, forKey: "JoinDate")
            return date
        }()
        let daysSinceJoin = Calendar.current.dateComponents([.day], from: joinDate, to: Date()).day ?? 0
        
        return UserStats(
            totalEntries: totalEntries,
            uniqueDays: uniqueDays,
            recentEntries: recentEntries.count,
            favoriteEmotion: favoriteEmotion,
            daysSinceJoin: daysSinceJoin,
            currentStreak: calculateCurrentStreak()
        )
    }
    
    private func calculateCurrentStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sortedDates = Set(dataManager.entries.map { 
            calendar.startOfDay(for: $0.date) 
        }).sorted(by: >)
        
        guard let mostRecent = sortedDates.first else { return 0 }
        
        let daysDiff = calendar.dateComponents([.day], from: mostRecent, to: today).day ?? 0
        if daysDiff > 1 { return 0 }
        
        var streak = 0
        var currentDate = mostRecent
        
        for date in sortedDates {
            let diff = calendar.dateComponents([.day], from: date, to: currentDate).day ?? 0
            if diff <= 1 {
                streak += 1
                currentDate = date
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func exportDataAsText() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        var exportText = "Daily Emotion Journal Export\n"
        exportText += "Generated on: \(formatter.string(from: Date()))\n\n"
        
        let sortedEntries = dataManager.entries.sorted { $0.date > $1.date }
        
        for entry in sortedEntries {
            exportText += "Date: \(formatter.string(from: entry.date))\n"
            exportText += "Emotion: \(entry.emotion.title)\n"
            exportText += "Reason: \(entry.reason)\n\n"
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [exportText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func shareSummary() {
        let stats = userStats
        let summary = """
        My Emotion Journey Summary 📊
        
        📝 Total Entries: \(stats.totalEntries)
        📅 Days Tracked: \(stats.uniqueDays)
        🔥 Current Streak: \(stats.currentStreak) days
        💫 Most Common Emotion: \(stats.favoriteEmotion?.title ?? "None")
        📱 Tracking for \(stats.daysSinceJoin) days
        
        #EmotionTracking #SelfAwareness #MentalHealth
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [summary],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func deleteAllData() {
        dataManager.entries.removeAll()
        UserDefaults.standard.removeObject(forKey: "EmotionEntries")
    }
    
    private func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "OnboardingCompleted")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Notification.Name("resetOnboarding"), object: nil)
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct UserStats {
    let totalEntries: Int
    let uniqueDays: Int
    let recentEntries: Int
    let favoriteEmotion: EmotionType?
    let daysSinceJoin: Int
    let currentStreak: Int
}

struct ProfileHeaderView: View {
    let userName: String
    let stats: UserStats
    let onEditName: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Button(action: onEditName) {
                    ZStack {
                        Circle()
                            .fill(AppColors.accentYellow.opacity(0.3))
                            .frame(width: 80, height: 80)
                        
                        Text(String(userName.prefix(1)).uppercased())
                            .font(.poppinsBold(size: 32))
                            .foregroundColor(AppColors.accentYellow)
                    }
                }
                
                Button(action: onEditName) {
                    HStack(spacing: 8) {
                        Text(userName)
                            .font(.poppinsBold(size: 20))
                            .foregroundColor(AppColors.primaryText)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            
            if stats.currentStreak > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(AppColors.warningOrange)
                    
                    Text("\(stats.currentStreak) day streak!")
                        .font(.poppinsMedium(size: 14))
                        .foregroundColor(AppColors.primaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppColors.cardBackground)
                .cornerRadius(20)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct QuickStatsView: View {
    let stats: UserStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Journey")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatItemView(
                    title: "Total Entries",
                    value: "\(stats.totalEntries)",
                    icon: "doc.text.fill"
                )
                
                StatItemView(
                    title: "Days Tracked",
                    value: "\(stats.uniqueDays)",
                    icon: "calendar.badge.checkmark"
                )
                
                StatItemView(
                    title: "This Month",
                    value: "\(stats.recentEntries)",
                    icon: "chart.line.uptrend.xyaxis"
                )
                
                StatItemView(
                    title: "Tracking Since",
                    value: "\(stats.daysSinceJoin) days",
                    icon: "clock.fill"
                )
            }
            
            if let emotion = stats.favoriteEmotion {
                HStack {
                    Image(systemName: emotion.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text("Your most common emotion is \(emotion.title.lowercased())")
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                }
                .padding(12)
                .background(AppColors.accentYellow.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct StatItemView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.accentYellow)
            
            Text(value)
                .font(.poppinsBold(size: 16))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(.poppinsRegular(size: 12))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(AppColors.primaryText.opacity(0.05))
        .cornerRadius(8)
    }
}

struct PreferencesSection: View {
    @Binding var enableNotifications: Bool
    @Binding var reminderTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preferences")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                        .frame(width: 24)
                    
                    Text("Daily Reminders")
                        .font(.poppinsRegular(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Toggle("", isOn: $enableNotifications)
                        .toggleStyle(SwitchToggleStyle(tint: AppColors.accentYellow))
                }
                
                if enableNotifications {
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.accentYellow)
                            .frame(width: 24)
                        
                        Text("Reminder Time")
                            .font(.poppinsRegular(size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct DataManagementSection: View {
    let onExport: () -> Void
    let onDeleteAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data Management")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ProfileActionButton(
                    icon: "square.and.arrow.up",
                    title: "Export Data",
                    subtitle: "Save your entries",
                    action: onExport
                )
                
                ProfileActionButton(
                    icon: "trash.fill",
                    title: "Delete All Data",
                    subtitle: "Permanently remove all entries",
                    isDestructive: true,
                    action: onDeleteAll
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct AppSettingsSection: View {
    let onResetOnboarding: () -> Void
    let onRateApp: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App Settings")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ProfileActionButton(
                    icon: "arrow.clockwise",
                    title: "Reset Onboarding",
                    subtitle: "Show welcome screens again",
                    action: onResetOnboarding
                )
                
                ProfileActionButton(
                    icon: "star.fill",
                    title: "Rate the App",
                    subtitle: "Share your feedback",
                    action: onRateApp
                )
                
                ProfileActionButton(
                    icon: "envelope.fill",
                    title: "Contact Support",
                    subtitle: "Get help or report issues"
                ) {
                    if let url = URL(string: "https://google.com") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct AboutSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About")
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ProfileActionButton(
                    icon: "doc.text.fill",
                    title: "Terms & Conditions",
                    subtitle: "Read our terms"
                ) {
                    if let url = URL(string: "https://google.com") {
                        UIApplication.shared.open(url)
                    }
                }
                
                ProfileActionButton(
                    icon: "hand.raised.fill",
                    title: "Privacy Policy",
                    subtitle: "Your data protection"
                ) {
                    if let url = URL(string: "https://google.com") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            
            HStack {
                Spacer()
                VStack(spacing: 4) {
                    Text("Daily Emotion")
                        .font(.poppinsMedium(size: 14))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Version 1.0.0")
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct ProfileActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDestructive ? AppColors.errorRed : AppColors.accentYellow)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.poppinsMedium(size: 16))
                        .foregroundColor(isDestructive ? AppColors.errorRed : AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditNameSheet: View {
    @Binding var userName: String
    @Environment(\.dismiss) private var dismiss
    @State private var tempName: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("What should we call you?")
                    .font(.poppinsBold(size: 20))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                
                TextField("Enter your name", text: $tempName)
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .padding(16)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(BackgroundView())
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        userName = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentYellow)
                    .disabled(tempName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            tempName = userName
        }
    }
}

#Preview {
    ProfileView(dataManager: EmotionDataManager())
}
