import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        if viewModel.workouts.isEmpty {
                            emptyStateView
                            
                            Spacer()
                        } else {
                            overviewStats
                            achievementsSection
                            workoutCalendar
                            streakInfo
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Achievements")
                .font(.ubuntu(size: 32, weight: .bold))
                .foregroundColor(AppColors.white)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.gray)
            
            Text("Start your fitness journey")
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.gray)
            
            Spacer()
        }
        .padding(.top, 60)
    }
    
    private var overviewStats: some View {
        VStack(spacing: 16) {
            Text("Overview")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                StatCardView(
                    title: "Total Workouts",
                    value: "\(viewModel.workouts.count)",
                    icon: "figure.strengthtraining.traditional",
                    color: AppColors.lightBlue
                )
                
                StatCardView(
                    title: "This Month",
                    value: "\(workoutsThisMonth)",
                    icon: "calendar",
                    color: AppColors.orange
                )
            }
            
            HStack(spacing: 12) {
                StatCardView(
                    title: "Muscle Groups",
                    value: "\(uniqueMuscleGroups)",
                    icon: "list.bullet",
                    color: AppColors.green
                )
                
                StatCardView(
                    title: "Current Streak",
                    value: "\(currentStreak) days",
                    icon: "flame.fill",
                    color: AppColors.red
                )
            }
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                AchievementBadge(
                    title: "First Workout",
                    icon: "star.fill",
                    isUnlocked: viewModel.workouts.count >= 1,
                    color: AppColors.lightBlue
                )
                
                AchievementBadge(
                    title: "10 Workouts",
                    icon: "star.circle.fill",
                    isUnlocked: viewModel.workouts.count >= 10,
                    color: AppColors.orange
                )
                
                AchievementBadge(
                    title: "50 Workouts",
                    icon: "crown.fill",
                    isUnlocked: viewModel.workouts.count >= 50,
                    color: AppColors.green
                )
                
                AchievementBadge(
                    title: "100 Workouts",
                    icon: "medal.fill",
                    isUnlocked: viewModel.workouts.count >= 100,
                    color: AppColors.red
                )
                
                AchievementBadge(
                    title: "Week Streak",
                    icon: "calendar.badge.clock",
                    isUnlocked: currentStreak >= 7,
                    color: AppColors.lightBlue
                )
                
                AchievementBadge(
                    title: "All Groups",
                    icon: "checkmark.seal.fill",
                    isUnlocked: uniqueMuscleGroups >= 6,
                    color: AppColors.orange
                )
            }
        }
    }
    
    private var workoutCalendar: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Month Calendar")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            calendarGridView
        }
    }
    
    private var calendarGridView: some View {
        CalendarGridContent(viewModel: viewModel)
    }
    
    private var streakInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Streak")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Streak")
                        .font(.ubuntu(size: 14, weight: .regular))
                        .foregroundColor(AppColors.gray)
                    
                    Text("\(currentStreak) days")
                        .font(.ubuntu(size: 24, weight: .bold))
                        .foregroundColor(AppColors.orange)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Longest Streak")
                        .font(.ubuntu(size: 14, weight: .regular))
                        .foregroundColor(AppColors.gray)
                    
                    Text("\(longestStreak) days")
                        .font(.ubuntu(size: 24, weight: .bold))
                        .foregroundColor(AppColors.lightBlue)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
    }
    
    private var workoutsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.workouts.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }.count
    }
    
    private var uniqueMuscleGroups: Int {
        Set(viewModel.workouts.flatMap { $0.muscleGroups }).count
    }
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        let sortedWorkouts = viewModel.workouts.sorted { $0.date > $1.date }
        guard let lastWorkout = sortedWorkouts.first else { return 0 }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        let lastWorkoutDate = calendar.startOfDay(for: lastWorkout.date)
        
        if calendar.isDate(currentDate, equalTo: lastWorkoutDate, toGranularity: .day) {
            streak = 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        for workout in sortedWorkouts {
            let workoutDate = calendar.startOfDay(for: workout.date)
            if calendar.isDate(workoutDate, equalTo: currentDate, toGranularity: .day) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if workoutDate < currentDate {
                break
            }
        }
        
        return streak
    }
    
    private var longestStreak: Int {
        let calendar = Calendar.current
        let sortedWorkouts = viewModel.workouts.sorted { $0.date < $1.date }
        guard !sortedWorkouts.isEmpty else { return 0 }
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 1..<sortedWorkouts.count {
            let prevDate = calendar.startOfDay(for: sortedWorkouts[i-1].date)
            let currDate = calendar.startOfDay(for: sortedWorkouts[i].date)
            
            if let daysBetween = calendar.dateComponents([.day], from: prevDate, to: currDate).day, daysBetween == 1 {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return maxStreak
    }
}

struct CalendarGridContent: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        let firstDayWeekday = calendar.component(.weekday, from: startOfMonth)
        let weekdayOffset = (firstDayWeekday - 1) % 7
        let workoutsThisMonth = viewModel.workouts.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
        let workoutDates = Set(workoutsThisMonth.map { calendar.startOfDay(for: $0.date) })
        let daysInMonth = calendar.range(of: .day, in: .month, for: now)?.count ?? 30
        let totalDays = 42
        let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
        
        let dayIndices: [Int] = [0, 1, 2, 3, 4, 5, 6]
        let calendarIndices: [Int] = {
            var result: [Int] = []
            for i in 0..<totalDays {
                result.append(i)
            }
            return result
        }()
        
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(dayIndices, id: \.self) { index in
                Text(weekDays[index])
                    .font(.ubuntu(size: 12, weight: .medium))
                    .foregroundColor(AppColors.gray)
                    .frame(maxWidth: .infinity)
            }
            
            ForEach(calendarIndices, id: \.self) { index in
                CalendarDayView(
                    index: index,
                    weekdayOffset: weekdayOffset,
                    startOfMonth: startOfMonth,
                    now: now,
                    daysInMonth: daysInMonth,
                    workoutDates: workoutDates,
                    calendar: calendar
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct CalendarDayView: View {
    let index: Int
    let weekdayOffset: Int
    let startOfMonth: Date
    let now: Date
    let daysInMonth: Int
    let workoutDates: Set<Date>
    let calendar: Calendar
    
    var body: some View {
        let dayOffset = index - weekdayOffset
        let date: Date
        let isCurrentMonth: Bool
        
        if dayOffset < 0 {
            date = calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth) ?? now
            isCurrentMonth = false
        } else if dayOffset >= daysInMonth {
            date = calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth) ?? now
            isCurrentMonth = false
        } else {
            date = calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth) ?? now
            isCurrentMonth = true
        }
        
        let isWorkoutDay = workoutDates.contains(calendar.startOfDay(for: date))
        let dayNumber = calendar.component(.day, from: date)
        let dateString = formatDateForCalendar(date)
        
        return ZStack {
            Circle()
                .fill(isWorkoutDay ? AppColors.lightBlue : Color.clear)
                .frame(width: 32, height: 32)
            
            Text("\(dayNumber)")
                .font(.ubuntu(size: 12, weight: .medium))
                .foregroundColor(isCurrentMonth ? (isWorkoutDay ? AppColors.white : AppColors.white) : AppColors.gray)
        }
        .frame(maxWidth: .infinity)
        .id("\(dateString)-\(index)")
    }
    
    private func formatDateForCalendar(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.ubuntu(size: 24, weight: .bold))
                .foregroundColor(AppColors.white)
            
            Text(title)
                .font(.ubuntu(size: 12, weight: .regular))
                .foregroundColor(AppColors.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct AchievementBadge: View {
    let title: String
    let icon: String
    let isUnlocked: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color.opacity(0.2) : AppColors.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isUnlocked ? color : AppColors.gray)
            }
            
            Text(title)
                .font(.ubuntu(size: 12, weight: .medium))
                .foregroundColor(isUnlocked ? AppColors.white : AppColors.gray)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

#Preview {
    AchievementsView(viewModel: WorkoutViewModel())
}
