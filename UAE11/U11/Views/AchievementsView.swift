import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var viewModel: ExerciseViewModel
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Achievements")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        WorkoutCalendarSection(viewModel: viewModel)
                        
                        AchievementsSection(viewModel: viewModel)
                        
                        ActivityStatsSection(viewModel: viewModel)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct WorkoutCalendarSection: View {
    @ObservedObject var viewModel: ExerciseViewModel
    
    private var workoutDates: Set<String> {
        let allDates = viewModel.exercises.flatMap { $0.results.map { $0.date } }
        let calendar = Calendar.current
        return Set(allDates.map { date in
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            return "\(components.year ?? 0)-\(components.month ?? 0)-\(components.day ?? 0)"
        })
    }
    
    private var currentMonthDates: [Date] {
        let calendar = Calendar.current
        let now = Date()
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }
        let numDays = range.count
        
        return (1...numDays).compactMap { day in
            calendar.date(bySetting: .day, value: day, of: startOfMonth)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout Calendar")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                HStack {
                    Text(currentMonthName)
                        .font(.playfairDisplay(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                    Text("\(workoutDates.count) workout days")
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                HStack(spacing: 0) {
                    ForEach(Array(["S", "M", "T", "W", "T", "F", "S"].enumerated()), id: \.offset) { index, day in
                        Text(day)
                            .font(.playfairDisplay(size: 12, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(calendarDays, id: \.self) { day in
                        CalendarDayView(
                            day: day,
                            hasWorkout: workoutDates.contains(dayKey(for: day))
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
            )
        }
    }
    
    private var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    private var calendarDays: [Int] {
        let calendar = Calendar.current
        let now = Date()
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
              let numDays = calendar.range(of: .day, in: .month, for: startOfMonth)?.count else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        var days: [Int] = []
        
        for _ in 1..<firstWeekday {
            days.append(0)
        }
        
        for day in 1...numDays {
            days.append(day)
        }
        
        return days
    }
    
    private func dayKey(for day: Int) -> String {
        guard day > 0 else { return "" }
        let calendar = Calendar.current
        let now = Date()
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
              let date = calendar.date(bySetting: .day, value: day, of: startOfMonth) else {
            return ""
        }
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return "\(components.year ?? 0)-\(components.month ?? 0)-\(components.day ?? 0)"
    }
}

struct CalendarDayView: View {
    let day: Int
    let hasWorkout: Bool
    
    var body: some View {
        ZStack {
            if day > 0 {
                Circle()
                    .fill(hasWorkout ? AppColors.lightBlue : AppColors.secondaryBackground.opacity(0.3))
                    .frame(width: 32, height: 32)
                
                Text("\(day)")
                    .font(.playfairDisplay(size: 14, weight: hasWorkout ? .bold : .regular))
                    .foregroundColor(hasWorkout ? AppColors.primaryText : AppColors.secondaryText)
            }
        }
        .frame(height: 32)
    }
}

struct AchievementsSection: View {
    @ObservedObject var viewModel: ExerciseViewModel
    
    private var achievements: [Achievement] {
        var achievements: [Achievement] = []
        let totalRecords = viewModel.totalRecords
        let totalExercises = viewModel.totalExercises
        
        if totalRecords >= 1 {
            achievements.append(Achievement(
                title: "First Workout",
                description: "Completed your first workout",
                icon: "star.fill",
                color: AppColors.orange,
                isUnlocked: true
            ))
        }
        if totalRecords >= 10 {
            achievements.append(Achievement(
                title: "10 Workouts",
                description: "Completed 10 workouts",
                icon: "star.fill",
                color: AppColors.lightBlue,
                isUnlocked: true
            ))
        }
        if totalRecords >= 25 {
            achievements.append(Achievement(
                title: "25 Workouts",
                description: "Completed 25 workouts",
                icon: "star.fill",
                color: AppColors.purple,
                isUnlocked: true
            ))
        }
        if totalRecords >= 50 {
            achievements.append(Achievement(
                title: "50 Workouts",
                description: "Completed 50 workouts",
                icon: "star.fill",
                color: AppColors.green,
                isUnlocked: true
            ))
        }
        if totalRecords >= 100 {
            achievements.append(Achievement(
                title: "100 Workouts",
                description: "Completed 100 workouts",
                icon: "star.fill",
                color: AppColors.pink,
                isUnlocked: true
            ))
        }
        
        if totalExercises >= 5 {
            achievements.append(Achievement(
                title: "5 Exercises",
                description: "Tracking 5 different exercises",
                icon: "dumbbell.fill",
                color: AppColors.orange,
                isUnlocked: true
            ))
        }
        if totalExercises >= 10 {
            achievements.append(Achievement(
                title: "10 Exercises",
                description: "Tracking 10 different exercises",
                icon: "dumbbell.fill",
                color: AppColors.lightBlue,
                isUnlocked: true
            ))
        }
        
        if totalRecords < 10 {
            achievements.append(Achievement(
                title: "10 Workouts",
                description: "Complete 10 workouts",
                icon: "star",
                color: AppColors.secondaryText,
                isUnlocked: false
            ))
        }
        if totalRecords < 50 {
            achievements.append(Achievement(
                title: "50 Workouts",
                description: "Complete 50 workouts",
                icon: "star",
                color: AppColors.secondaryText,
                isUnlocked: false
            ))
        }
        
        return achievements
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            if achievements.isEmpty {
                Text("Complete workouts to unlock achievements")
                    .font(.playfairDisplay(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(achievements, id: \.title) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
        )
    }
}

struct Achievement {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: achievement.icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(achievement.isUnlocked ? achievement.color : AppColors.secondaryText.opacity(0.5))
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.playfairDisplay(size: 14, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? AppColors.primaryText : AppColors.secondaryText.opacity(0.7))
                
                Text(achievement.description)
                    .font(.playfairDisplay(size: 11, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(achievement.isUnlocked ? achievement.color.opacity(0.2) : AppColors.secondaryBackground.opacity(0.3))
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

struct ActivityStatsSection: View {
    @ObservedObject var viewModel: ExerciseViewModel
    
    private var workoutStreak: Int {
        let allDates = viewModel.exercises.flatMap { $0.results.map { $0.date } }
        guard !allDates.isEmpty else { return 0 }
        
        let uniqueDates = Set(allDates.map { Calendar.current.startOfDay(for: $0) })
        let sortedDates = uniqueDates.sorted(by: >)
        
        guard !sortedDates.isEmpty else { return 0 }
        
        var streak = 0
        let calendar = Calendar.current
        var expectedDate = calendar.startOfDay(for: Date())
        
        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: expectedDate) {
                streak += 1
                expectedDate = calendar.date(byAdding: .day, value: -1, to: expectedDate) ?? expectedDate
            } else if date < expectedDate {
                break
            }
        }
        
        return streak
    }
    
    private var thisWeekWorkouts: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
        
        let allDates = viewModel.exercises.flatMap { $0.results.map { $0.date } }
        return allDates.filter { $0 >= weekAgo }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 16) {
                ActivityStatCard(
                    title: "This Week",
                    value: "\(thisWeekWorkouts)",
                    icon: "calendar",
                    color: AppColors.lightBlue
                )
                
                ActivityStatCard(
                    title: "Streak",
                    value: "\(workoutStreak) days",
                    icon: "flame.fill",
                    color: AppColors.orange
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
        )
    }
}

struct ActivityStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.playfairDisplay(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.secondaryBackground.opacity(0.5))
        )
    }
}

#Preview {
    AchievementsView()
        .environmentObject(ExerciseViewModel())
}
