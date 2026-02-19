import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerView
                    
                    statsOverview
                    
                    calendarView
                    
                    DayDetailView(date: selectedDate, viewModel: viewModel)
                }
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            viewModel.refresh()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("History")
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Track your progress over time")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(viewModel.getStreakCount())")
                    .font(AppFonts.title3())
                    .foregroundColor(AppColors.iconAccent)
                
                Text("day streak")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
    }
    
    private var statsOverview: some View {
        HStack(spacing: AppSpacing.md) {
            StatCard(
                title: "This Week",
                value: "\(getWeeklyCompletionDays())/7",
                subtitle: "days completed",
                color: AppColors.lightGreen
            )
            
            StatCard(
                title: "This Month",
                value: "\(getMonthlyCompletionDays())",
                subtitle: "active days",
                color: AppColors.primaryYellow
            )
            
            StatCard(
                title: "Best Streak",
                value: "\(getBestStreak())",
                subtitle: "days in a row",
                color: AppColors.softPink
            )
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
    }
    
    private var calendarView: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.textPrimary)
                }
                
                Spacer()
                
                Text(viewModel.selectedMonth.formatted(.dateTime.month(.wide).year()))
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.textPrimary)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: AppSpacing.xs) {
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.textTertiary)
                        .frame(height: 30)
                }
                
                ForEach(identifiableCalendarDays()) { item in
                    CalendarDayView(
                        date: item.date,
                        isSelected: Calendar.current.isDate(item.date, inSameDayAs: selectedDate),
                        completionPercentage: viewModel.getCompletionPercentageForDate(item.date),
                        isCurrentMonth: Calendar.current.isDate(item.date, equalTo: viewModel.selectedMonth, toGranularity: .month)
                    ) {
                        selectedDate = item.date
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .padding(.horizontal, AppSpacing.md)
    }
    
    private func changeMonth(_ direction: Int) {
        DispatchQueue.main.async {
            if let newDate = Calendar.current.date(byAdding: .month, value: direction, to: viewModel.selectedMonth) {
                viewModel.selectedMonth = newDate
            }
        }
    }
    
    private struct CalendarDayItem: Identifiable {
        let id: String
        let date: Date
    }
    
    private func identifiableCalendarDays() -> [CalendarDayItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let calendarDays = getCalendarDays()
        return calendarDays.map { date in
            CalendarDayItem(id: formatter.string(from: date), date: date)
        }
    }
    
    private func getCalendarDays() -> [Date] {
        let calendar = Calendar.current
        
        let selectedMonth = viewModel.selectedMonth
        
        guard let startOfMonth = calendar.dateInterval(of: .month, for: selectedMonth)?.start else {
            return Array(0..<42).compactMap { i in
                calendar.date(byAdding: .day, value: i, to: Date())
            }
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return Array(0..<42).compactMap { i in
                calendar.date(byAdding: .day, value: i, to: startOfMonth)
            }
        }
        
        var days: [Date] = []
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysFromPreviousMonth = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        for i in (1...daysFromPreviousMonth).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: startOfMonth) {
                days.append(date)
            }
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        let totalCells = 42
        let remainingCells = totalCells - days.count
        if remainingCells > 0, let lastDayOfMonth = days.last {
            for i in 1...remainingCells {
                if let date = calendar.date(byAdding: .day, value: i, to: lastDayOfMonth) {
                    days.append(date)
                }
            }
        }
        
        while days.count < 42 {
            if let lastDate = days.last,
               let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) {
                days.append(nextDate)
            } else {
                break
            }
        }
        
        return days
    }
    
    private func getWeeklyCompletionDays() -> Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        var count = 0
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                if viewModel.getCompletionPercentageForDate(date) > 0.5 {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    private func getMonthlyCompletionDays() -> Int {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: Date())?.start ?? Date()
        let range = calendar.range(of: .day, in: .month, for: startOfMonth) ?? 1..<32
        var count = 0
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                if viewModel.getCompletionPercentageForDate(date) > 0.5 {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    private func getBestStreak() -> Int {
        return max(viewModel.getStreakCount(), 7)
    }
}

struct DayDetailView: View {
    let date: Date
    @ObservedObject var viewModel: HistoryViewModel
    
    private var progress: DailyProgress? {
        viewModel.getProgressForDate(date)
    }
    
    var body: some View {
        Group {
            if let progress = progress {
                dayDetailsContent(progress: progress)
            } else {
                emptyDayView
            }
        }
        .padding(.top, 20)
    }
    
    private var emptyDayView: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "calendar")
                .font(.system(size: 32))
                .foregroundColor(AppColors.textTertiary)
            
            Text("No data for this day")
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
            
            Text("Start tracking your habits to see progress here")
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .padding(.horizontal, AppSpacing.md)
    }
    
    private func dayDetailsContent(progress: DailyProgress) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    Text(date.formatted(.dateTime.weekday(.wide).month().day().year()))
                        .font(AppFonts.headline())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(Int(progress.completionPercentage * 100))% complete")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.iconAccent)
                }
                
                if let sleep = progress.sleepEntry {
                    ProgressSectionView(
                        title: "Sleep",
                        icon: "bed.double",
                        content: "\(String(format: "%.1f", sleep.durationHours)) hours, Quality: \(sleep.quality)/5"
                    )
                }
                
                if !progress.mealEntries.isEmpty {
                    ProgressSectionView(
                        title: "Nutrition",
                        icon: "leaf",
                        content: "\(progress.mealEntries.count) meals logged"
                    )
                }
                
                if !progress.activityEntries.isEmpty {
                    ProgressSectionView(
                        title: "Activity",
                        icon: "figure.run",
                        content: "\(progress.activityEntries.count) activities"
                    )
                }
                
                if !progress.completedChallenges.isEmpty {
                    ProgressSectionView(
                        title: "Challenges",
                        icon: "target",
                        content: "\(progress.completedChallenges.count) completed"
                    )
                }
                
                if let mood = progress.moodRating, let energy = progress.energyLevel {
                    HStack(spacing: AppSpacing.md) {
                        MoodEnergyView(title: "Mood", rating: mood, color: AppColors.softPink)
                        MoodEnergyView(title: "Energy", rating: energy, color: AppColors.primaryYellow)
                    }
                }
                
                if !progress.notes.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Notes")
                            .font(AppFonts.headline())
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(progress.notes)
                            .font(AppFonts.body())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(AppSpacing.md)
                    .background(AppColors.cardBackground)
                    .cornerRadius(AppCornerRadius.sm)
                }
            }
            .padding(AppSpacing.md)
        }
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .padding(.horizontal, AppSpacing.md)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let completionPercentage: Double
    let isCurrentMonth: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(
                        completionPercentage > 0.8 ? AppColors.lightGreen.opacity(0.3) :
                        completionPercentage > 0.5 ? AppColors.iconAccent.opacity(0.3) :
                        completionPercentage > 0.2 ? AppColors.softPink.opacity(0.3) :
                        Color.clear
                    )
                    .frame(width: 32, height: 32)
                
                if isSelected {
                    Circle()
                        .stroke(AppColors.iconAccent, lineWidth: 2)
                        .frame(width: 36, height: 36)
                }
                
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(AppFonts.callout())
                    .foregroundColor(
                        isCurrentMonth ? AppColors.textPrimary : AppColors.textTertiary.opacity(0.5)
                    )
            }
        }
        .frame(height: 40)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(AppFonts.title3())
                .foregroundColor(color)
            
            Text(subtitle)
                .font(AppFonts.caption2())
                .foregroundColor(AppColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.sm)
    }
}

struct ProgressSectionView: View {
    let title: String
    let icon: String
    let content: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.iconAccent)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textPrimary)
                
                Text(content)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.sm)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(AppCornerRadius.sm)
    }
}

struct MoodEnergyView: View {
    let title: String
    let rating: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textSecondary)
            
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Circle()
                        .fill(index <= rating ? color : AppColors.textTertiary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(AppCornerRadius.sm)
    }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel())
}
