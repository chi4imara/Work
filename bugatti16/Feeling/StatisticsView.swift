import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    
    private var moodCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for entry in viewModel.dailyEntries {
            if let mood = entry.selectedMood {
                counts[mood.emotion.displayName, default: 0] += 1
            }
        }
        return counts
    }
    
    private var totalEntries: Int { viewModel.dailyEntries.count }
    
    private var totalRitualCompletions: Int {
        viewModel.rituals.reduce(0) { $0 + $1.completionDates.count }
    }
    
    private var currentStreakDays: Int {
        let calendar = Calendar.current
        let sorted = viewModel.dailyEntries
            .filter { $0.selectedMood != nil || !$0.completedRituals.isEmpty || $0.completedChallenge != nil }
            .sorted { $0.date > $1.date }
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        for entry in sorted {
            if calendar.isDate(entry.date, inSameDayAs: checkDate) {
                streak += 1
                guard let next = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = next
            } else if entry.date < checkDate {
                break
            }
        }
        return streak
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    overviewCards
                    moodDistributionSection
                    ritualsSection
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Statistics")
                .font(AppFonts.playfairBold(size: 28))
                .foregroundColor(AppColors.textPrimary)
            Text("Your wellness at a glance")
                .font(AppFonts.playfairRegular(size: 16))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, AppSpacing.lg)
        .padding(.bottom, AppSpacing.sm)
    }
    
    private var overviewCards: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                StatOverviewCard(
                    title: "Days Tracked",
                    value: "\(totalEntries)",
                    icon: "calendar"
                )
                StatOverviewCard(
                    title: "Ritual Completions",
                    value: "\(totalRitualCompletions)",
                    icon: "checkmark.circle"
                )
            }
            HStack(spacing: AppSpacing.md) {
                StatOverviewCard(
                    title: "Current Streak",
                    value: "\(currentStreakDays) days",
                    icon: "flame"
                )
                StatOverviewCard(
                    title: "Challenges Done",
                    value: "\(viewModel.userProgress.completedChallenges)",
                    icon: "star"
                )
            }
        }
    }
    
    private var moodDistributionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Mood Distribution")
                .font(AppFonts.playfairSemiBold(size: 20))
                .foregroundColor(AppColors.textPrimary)
            
            if moodCounts.isEmpty {
                emptyStatPlaceholder(message: "No mood data yet. Start tracking on the Today tab.")
            } else {
                let total = moodCounts.values.reduce(0, +)
                VStack(spacing: AppSpacing.sm) {
                    ForEach(Array(moodCounts.sorted { $0.value > $1.value }), id: \.key) { name, count in
                        let mood = Mood.allMoods.first { $0.emotion.displayName == name }
                        HStack {
                            if let mood = mood {
                                Image(systemName: mood.emotion.systemImage)
                                    .font(.system(size: 16))
                                    .foregroundColor(mood.emotion.color)
                                    .frame(width: 24, alignment: .leading)
                            }
                            Text(name)
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Text("\(count)")
                                .font(AppFonts.playfairSemiBold(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            if total > 0 {
                                Text("(\(Int(Double(count) / Double(total) * 100))%)")
                                    .font(AppFonts.playfairRegular(size: 14))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        .padding(.vertical, AppSpacing.sm)
                        .padding(.horizontal, AppSpacing.md)
                        .background(AppColors.cardBackground)
                        .cornerRadius(AppRadius.md)
                    }
                }
            }
        }
    }
    
    private var ritualsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Ritual Streaks")
                .font(AppFonts.playfairSemiBold(size: 20))
                .foregroundColor(AppColors.textPrimary)
            
            if viewModel.rituals.isEmpty {
                emptyStatPlaceholder(message: "No rituals yet. Add some in My Rituals.")
            } else {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(viewModel.rituals) { ritual in
                        HStack {
                            Image(systemName: ritual.category.systemImage)
                                .font(.system(size: 16))
                                .foregroundColor(ritual.category.color)
                                .frame(width: 24, alignment: .leading)
                            Text(ritual.name)
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                                .lineLimit(1)
                            Spacer()
                            Text("\(ritual.streak) day streak")
                                .font(AppFonts.playfairRegular(size: 14))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.vertical, AppSpacing.sm)
                        .padding(.horizontal, AppSpacing.md)
                        .background(AppColors.cardBackground)
                        .cornerRadius(AppRadius.md)
                    }
                }
            }
        }
    }
    
    private func emptyStatPlaceholder(message: String) -> some View {
        Text(message)
            .font(AppFonts.playfairRegular(size: 14))
            .foregroundColor(AppColors.textSecondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.xl)
            .background(AppColors.cardBackground)
            .cornerRadius(AppRadius.md)
    }
}

struct StatOverviewCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primary)
            Text(value)
                .font(AppFonts.playfairBold(size: 22))
                .foregroundColor(AppColors.textPrimary)
            Text(title)
                .font(AppFonts.playfairRegular(size: 12))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.lg)
        .background(AppColors.cardBackground)
        .cornerRadius(AppRadius.md)
        .shadow(color: AppColors.primary.opacity(0.08), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(MoodViewModel())
}
