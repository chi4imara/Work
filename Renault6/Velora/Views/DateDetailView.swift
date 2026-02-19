import SwiftUI

struct DateDetailView: View {
    let dateId: Date
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var progress: DailyProgress? {
        viewModel.progress(for: dateId)
    }
    
    private var habits: [Habit] {
        viewModel.habits
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(dateFormatter.string(from: dateId))
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.center)
                            
                            if let progress = progress {
                                Text("\(Int(progress.completionPercentage * 100))% completed")
                                    .font(.ubuntu(14, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                            } else {
                                Text("No activity recorded")
                                    .font(.ubuntu(14, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        .padding(.top, 20)
                        
                        if let progress = progress {
                            if !progress.selectedMoods.isEmpty {
                                DetailSectionView(title: "Mood", icon: "heart.fill") {
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                                        ForEach(progress.selectedMoods, id: \.id) { mood in
                                            VStack(spacing: 4) {
                                                Text(mood.emoji)
                                                    .font(.system(size: 30))
                                                
                                                Text(mood.name)
                                                    .font(.ubuntu(10, weight: .light))
                                                    .foregroundColor(AppColors.secondaryText)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            let completedHabits = habits.filter { progress.completedHabits.contains($0.id) }
                            if !completedHabits.isEmpty {
                                DetailSectionView(title: "Completed Habits", icon: "checkmark.circle.fill") {
                                    VStack(spacing: 12) {
                                        ForEach(completedHabits, id: \.id) { habit in
                                            HStack {
                                                Image(systemName: habit.category.iconName)
                                                    .font(.system(size: 16))
                                                    .foregroundColor(AppColors.success)
                                                
                                                Text(habit.name)
                                                    .font(.ubuntu(16, weight: .medium))
                                                    .foregroundColor(AppColors.primaryText)
                                                
                                                Spacer()
                                                
                                                Text(habit.category.rawValue)
                                                    .font(.ubuntu(12, weight: .light))
                                                    .foregroundColor(AppColors.secondaryText)
                                            }
                                            .padding(12)
                                            .background(AppColors.success.opacity(0.1))
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                            
                            if progress.meditationCompleted {
                                DetailSectionView(title: "Meditation", icon: "leaf.fill") {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(AppColors.success)
                                        
                                        Text("Mini-meditation completed")
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(AppColors.success.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                            
                            if !progress.completedChallenges.isEmpty {
                                DetailSectionView(title: "Daily Challenges", icon: "target") {
                                    VStack(spacing: 12) {
                                        ForEach(progress.completedChallenges, id: \.self) { challengeId in
                                            if let challenge = Challenge.dailyChallenges.first(where: { $0.id == challengeId }) {
                                                HStack {
                                                    Image(systemName: challenge.category.iconName)
                                                        .font(.system(size: 16))
                                                        .foregroundColor(AppColors.success)
                                                    
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text(challenge.title)
                                                            .font(.ubuntu(16, weight: .medium))
                                                            .foregroundColor(AppColors.primaryText)
                                                        
                                                        Text(challenge.description)
                                                            .font(.ubuntu(12, weight: .light))
                                                            .foregroundColor(AppColors.secondaryText)
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                .padding(12)
                                                .background(AppColors.success.opacity(0.1))
                                                .cornerRadius(12)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            let dayStreak = calculateStreakForDate(dateId)
                            if dayStreak > 0 {
                                DetailSectionView(title: "Streak", icon: "flame.fill") {
                                    HStack {
                                        Image(systemName: "flame.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(AppColors.warning)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(dayStreak) days")
                                                .font(.ubuntu(20, weight: .bold))
                                                .foregroundColor(AppColors.primaryText)
                                            
                                            Text("Consecutive days of activity")
                                                .font(.ubuntu(12, weight: .light))
                                                .foregroundColor(AppColors.secondaryText)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(16)
                                    .background(AppColors.warning.opacity(0.1))
                                    .cornerRadius(16)
                                }
                            }
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 60))
                                    .foregroundColor(AppColors.primaryText.opacity(0.6))
                                
                                Text("No activity recorded")
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Start tracking your daily habits and moods to see your progress here.")
                                    .font(.ubuntu(14, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 40)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Day Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
    
    private func calculateStreakForDate(_ date: Date) -> Int {
        return progress?.completionPercentage ?? 0 > 0 ? 1 : 0
    }
}

struct DetailSectionView<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
    }
}

#Preview {
    DateDetailView(dateId: Date(), viewModel: AppViewModel())
}
