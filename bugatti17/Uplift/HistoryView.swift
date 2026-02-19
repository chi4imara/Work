import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedDate = Date()
    @State private var showingDateDetail = false
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(DesignConstants.Colors.white)
                    
                    Spacer()
                }
                .padding(.horizontal, DesignConstants.Spacing.lg)
                .padding(.vertical, DesignConstants.Spacing.md)
                
                ScrollView {
                    VStack(spacing: DesignConstants.Spacing.lg) {
                        HistoryCalendarView(
                            selectedDate: $selectedDate,
                            appViewModel: appViewModel
                        ) { date in
                            selectedDate = date
                            showingDateDetail = true
                        }
                        
                        StatsOverviewView(appViewModel: appViewModel)
                        
                        RecentActivityView(appViewModel: appViewModel)
                    }
                    .padding(.horizontal, DesignConstants.Spacing.lg)
                    .padding(.top, DesignConstants.Spacing.lg)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingDateDetail) {
            DateDetailView(date: selectedDate, appViewModel: appViewModel)
        }
    }
}

private let weekdayLabels = ["S", "M", "T", "W", "T", "F", "S"]

struct HistoryCalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var appViewModel: AppViewModel
    let onDateTap: (Date) -> Void
    
    @State private var currentMonth = Date()
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.md) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(DesignConstants.Colors.white)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20))
                        .foregroundColor(DesignConstants.Colors.white)
                }
            }
            
            HStack {
                ForEach(Array(weekdayLabels.enumerated()), id: \.offset) { _, label in
                    Text(label)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { _, date in
                    if let date = date {
                        HistoryCalendarDayView(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            hasActivity: appViewModel.hasActivity(on: date),
                            completionRate: appViewModel.getCompletionRate(for: date),
                            isToday: Calendar.current.isDateInToday(date)
                        ) {
                            selectedDate = date
                            onDateTap(date)
                        }
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding(DesignConstants.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                .fill(DesignConstants.Colors.white.opacity(0.1))
        )
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let range = calendar.range(of: .day, in: .month, for: currentMonth) ?? 1..<32
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let numberOfDays = range.count
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
}

struct HistoryCalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasActivity: Bool
    let completionRate: Double
    let isToday: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        isSelected ? DesignConstants.Colors.primaryYellow :
                        isToday ? DesignConstants.Colors.primaryYellow.opacity(0.3) :
                        hasActivity ? DesignConstants.Colors.white.opacity(0.1) :
                        Color.clear
                    )
                
                if hasActivity && !isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(DesignConstants.Colors.primaryYellow.opacity(completionRate), lineWidth: 2)
                }
                
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.ubuntu(16, weight: isToday ? .bold : .regular))
                    .foregroundColor(
                        isSelected ? DesignConstants.Colors.primaryBlue :
                        isToday ? DesignConstants.Colors.primaryYellow :
                        hasActivity ? DesignConstants.Colors.white :
                        DesignConstants.Colors.white.opacity(0.5)
                    )
                
                if hasActivity && !isSelected {
                    VStack {
                        Spacer()
                        HStack(spacing: 2) {
                            ForEach(0..<min(3, Int(completionRate * 3) + 1), id: \.self) { _ in
                                Circle()
                                    .fill(DesignConstants.Colors.primaryYellow)
                                    .frame(width: 3, height: 3)
                            }
                        }
                        .padding(.bottom, 4)
                    }
                }
            }
            .frame(height: 40)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatsOverviewView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.md) {
            Text("This Week")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(DesignConstants.Colors.white)
            
            HStack(spacing: DesignConstants.Spacing.md) {
                StatCardView(
                    title: "Active Days",
                    value: "\(getActiveDaysThisWeek())",
                    subtitle: "out of 7",
                    color: DesignConstants.Colors.lightGreen
                )
                
                StatCardView(
                    title: "Completion",
                    value: "\(Int(getAverageCompletionThisWeek() * 100))%",
                    subtitle: "average",
                    color: DesignConstants.Colors.primaryYellow
                )
            }
            
            HStack(spacing: DesignConstants.Spacing.md) {
                StatCardView(
                    title: "Best Day",
                    value: getBestDayThisWeek(),
                    subtitle: "",
                    color: DesignConstants.Colors.softPink
                )
                
                StatCardView(
                    title: "Streak",
                    value: "\(getCurrentStreak())",
                    subtitle: "days",
                    color: DesignConstants.Colors.softPurple
                )
            }
        }
    }
    
    private func getActiveDaysThisWeek() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        var activeDays = 0
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: weekStart),
               date <= today,
               appViewModel.hasActivity(on: date) {
                activeDays += 1
            }
        }
        return activeDays
    }
    
    private func getAverageCompletionThisWeek() -> Double {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        var totalCompletion = 0.0
        var daysWithActivity = 0
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: weekStart),
               date <= today,
               appViewModel.hasActivity(on: date) {
                totalCompletion += appViewModel.getCompletionRate(for: date)
                daysWithActivity += 1
            }
        }
        
        return daysWithActivity > 0 ? totalCompletion / Double(daysWithActivity) : 0
    }
    
    private func getBestDayThisWeek() -> String {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        var bestDate: Date?
        var bestCompletion = 0.0
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: weekStart),
               date <= today {
                let completion = appViewModel.getCompletionRate(for: date)
                if completion > bestCompletion {
                    bestCompletion = completion
                    bestDate = date
                }
            }
        }
        
        if let bestDate = bestDate, bestCompletion > 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            return formatter.string(from: bestDate)
        }
        
        return "None"
    }
    
    private func getCurrentStreak() -> Int {
        let calendar = Calendar.current
        var currentDate = Date()
        var streak = 0
        
        while appViewModel.hasActivity(on: currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return streak
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.ubuntu(12))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
            
            Text(value)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(color)
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.ubuntu(10))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(DesignConstants.Colors.white.opacity(0.1))
        .cornerRadius(DesignConstants.CornerRadius.medium)
    }
}

struct RecentActivityView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.md) {
            Text("Recent Activity")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(DesignConstants.Colors.white)
            
            if appViewModel.appState.dailyEntries.isEmpty {
                EmptyStateView(
                    icon: "calendar",
                    title: "No activity yet",
                    description: "Start completing habits and challenges to see your history here!"
                )
            } else {
                ForEach(recentEntries, id: \.id) { entry in
                    RecentActivityItemView(entry: entry)
                }
            }
        }
    }
    
    private var recentEntries: [DailyEntry] {
        appViewModel.appState.dailyEntries
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { $0 }
    }
}

struct RecentActivityItemView: View {
    let entry: DailyEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
            HStack {
                Text(dateString)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Spacer()
                
                if !entry.selectedMoods.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(entry.selectedMoods.prefix(3), id: \.self) { moodId in
                            if let mood = AppConstants.moodOptions.first(where: { $0.id == moodId }) {
                                Image(systemName: mood.icon)
                                    .font(.system(size: 14))
                                    .foregroundColor(DesignConstants.Colors.primaryYellow)
                            }
                        }
                    }
                }
            }
            
            HStack {
                Text("\(entry.completedHabits.count) habits")
                    .font(.ubuntu(12))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
                
                Text("•")
                    .font(.ubuntu(12))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
                
                Text("\(entry.completedChallenges.count) challenges")
                    .font(.ubuntu(12))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
                
                if !entry.dailyQuestionAnswer.isEmpty {
                    Text("• answered question")
                        .font(.ubuntu(12))
                        .foregroundColor(DesignConstants.Colors.primaryYellow.opacity(0.8))
                }
            }
        }
        .padding()
        .background(DesignConstants.Colors.white.opacity(0.1))
        .cornerRadius(DesignConstants.CornerRadius.medium)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(entry.date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(entry.date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "MMM d"
            return formatter.string(from: entry.date)
        }
    }
}

struct DateDetailView: View {
    let date: Date
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: DesignConstants.Spacing.lg) {
                        if let entry = appViewModel.getEntry(for: date) {
                            Text(dateString)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            if !entry.selectedMoods.isEmpty {
                                VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                                    Text("Mood")
                                        .font(.ubuntu(18, weight: .medium))
                                        .foregroundColor(DesignConstants.Colors.white)
                                    
                                    HStack {
                                        ForEach(entry.selectedMoods, id: \.self) { moodId in
                                            if let mood = AppConstants.moodOptions.first(where: { $0.id == moodId }) {
                                                HStack(spacing: 4) {
                                                    Image(systemName: mood.icon)
                                                        .font(.system(size: 16))
                                                        .foregroundColor(DesignConstants.Colors.primaryYellow)
                                                    
                                                    Text(mood.name)
                                                        .font(.ubuntu(14))
                                                        .foregroundColor(DesignConstants.Colors.white)
                                                }
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(DesignConstants.Colors.white.opacity(0.1))
                                                .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                                Text("Completed Activities")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(DesignConstants.Colors.white)
                                
                                Text("\(entry.completedHabits.count) habits completed")
                                    .font(.ubuntu(16))
                                    .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                                
                                Text("\(entry.completedChallenges.count) challenges completed")
                                    .font(.ubuntu(16))
                                    .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                            }
                            
                            if !entry.dailyQuestionAnswer.isEmpty {
                                VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                                    Text("Daily Question")
                                        .font(.ubuntu(18, weight: .medium))
                                        .foregroundColor(DesignConstants.Colors.white)
                                    
                                    Text(entry.dailyQuestion)
                                        .font(.ubuntu(14))
                                        .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
                                    
                                    Text(entry.dailyQuestionAnswer)
                                        .font(.ubuntu(16))
                                        .foregroundColor(DesignConstants.Colors.white)
                                        .padding()
                                        .background(DesignConstants.Colors.white.opacity(0.1))
                                        .cornerRadius(DesignConstants.CornerRadius.medium)
                                }
                            }
                        } else {
                            VStack(spacing: DesignConstants.Spacing.lg) {
                                Text(dateString)
                                    .font(.ubuntu(24, weight: .bold))
                                    .foregroundColor(DesignConstants.Colors.white)
                                
                                EmptyStateView(
                                    icon: "calendar.badge.exclamationmark",
                                    title: "No activity",
                                    description: "No habits or challenges were completed on this day."
                                )
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(DesignConstants.Spacing.lg)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Day Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignConstants.Colors.white)
                }
            }
        }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "EEEE, MMMM d, yyyy"
            return formatter.string(from: date)
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(AppViewModel())
}
