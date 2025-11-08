import SwiftUI

struct GoalsSettingsView: View {
    @StateObject private var goalsManager = GoalsManager.shared
    @StateObject private var appColors = AppColors.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            ZStack {
                appColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        goalsOverview
                        
                        dailyGoalsSection
                        
                        weeklyGoalsSection
                        
                        monthlyGoalsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(appColors.selectedScheme == .dark ? .dark : .light)
        }
    
    private var goalsOverview: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "target")
                    .font(.system(size: 24))
                    .foregroundColor(appColors.primaryOrange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Goals")
                        .font(.builderSans(.semiBold, size: 18))
                        .foregroundColor(appColors.textPrimary)
                    
                    Text("Track your mood and weather patterns")
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                }
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                GoalProgressCard(
                    title: "Daily Streak",
                    value: "\(goalsManager.currentStreak)",
                    subtitle: "days",
                    color: appColors.accentGreen
                )
                
                GoalProgressCard(
                    title: "This Week",
                    value: "\(goalsManager.weeklyEntries)",
                    subtitle: "entries",
                    color: appColors.primaryBlue
                )
                
                GoalProgressCard(
                    title: "This Month",
                    value: "\(goalsManager.monthlyEntries)",
                    subtitle: "entries",
                    color: appColors.accentPurple
                )
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var dailyGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Goals")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                GoalToggleRow(
                    title: "Log Daily Mood",
                    subtitle: "Track your mood every day",
                    isEnabled: $goalsManager.dailyMoodGoal
                )
                
                Divider()
                    .padding(.leading, 50)
                
                GoalToggleRow(
                    title: "Record Weather",
                    subtitle: "Note the weather conditions",
                    isEnabled: $goalsManager.dailyWeatherGoal
                )
                
                Divider()
                    .padding(.leading, 50)
                
                GoalToggleRow(
                    title: "Add Comments",
                    subtitle: "Write about your day",
                    isEnabled: $goalsManager.dailyCommentGoal
                )
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var weeklyGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Goals")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                GoalSliderRow(
                    title: "Minimum Entries",
                    subtitle: "Log at least \(goalsManager.minWeeklyEntries) entries per week",
                    value: $goalsManager.minWeeklyEntries,
                    range: 1...7
                )
                
                Divider()
                    .padding(.leading, 50)
                
                GoalToggleRow(
                    title: "Weekly Review",
                    subtitle: "Review your week's patterns",
                    isEnabled: $goalsManager.weeklyReviewGoal
                )
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var monthlyGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Goals")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                GoalSliderRow(
                    title: "Minimum Entries",
                    subtitle: "Log at least \(goalsManager.minMonthlyEntries) entries per month",
                    value: $goalsManager.minMonthlyEntries,
                    range: 10...31
                )
                
                Divider()
                    .padding(.leading, 50)
                
                GoalToggleRow(
                    title: "Monthly Analysis",
                    subtitle: "Analyze your monthly patterns",
                    isEnabled: $goalsManager.monthlyAnalysisGoal
                )
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
}

struct GoalProgressCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.builderSans(.bold, size: 24))
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.builderSans(.regular, size: 12))
                .foregroundColor(appColors.textSecondary)
            
            Text(title)
                .font(.builderSans(.medium, size: 10))
                .foregroundColor(appColors.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct GoalToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isEnabled: Bool
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(appColors.textPrimary)
                
                Text(subtitle)
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(appColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: appColors.primaryOrange))
        }
    }
}

struct GoalSliderRow: View {
    let title: String
    let subtitle: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textPrimary)
                    
                    Text(subtitle)
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                }
                
                Spacer()
                
                Text("\(value)")
                    .font(.builderSans(.bold, size: 18))
                    .foregroundColor(appColors.primaryOrange)
            }
            
            Slider(value: Binding(
                get: { Double(value) },
                set: { value = Int($0) }
            ), in: Double(range.lowerBound)...Double(range.upperBound), step: 1)
            .accentColor(appColors.primaryOrange)
        }
    }
}

#Preview {
    GoalsSettingsView()
}
