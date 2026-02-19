import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedDate: Date = Date()
    @State private var showingDateDetail = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text(currentMonthYear)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        CalendarView(
                            selectedDate: $selectedDate,
                            dailyProgress: viewModel.dailyProgress,
                            onDateSelected: { date in
                                selectedDate = date
                                showingDateDetail = true
                            }
                        )
                        
                        StatsView(dailyProgress: viewModel.dailyProgress)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingDateDetail) {
            DateDetailView(dateId: selectedDate, viewModel: viewModel)
        }
    }
    
    private var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let dailyProgress: [DailyProgress]
    let onDateSelected: (Date) -> Void
    
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
            }
            
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isToday: calendar.isDate(date, inSameDayAs: Date()),
                        progress: progressForDate(date),
                        onTap: {
                            selectedDate = date
                            onDateSelected(date)
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
    }
    
    private var monthYearString: String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentMonth)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        
        var days: [Date] = []
        
        for i in 1..<firstWeekday {
            if let date = calendar.date(byAdding: .day, value: -(firstWeekday - i), to: firstOfMonth) {
                days.append(date)
            }
        }
        
        for i in 0..<numberOfDaysInMonth {
            if let date = calendar.date(byAdding: .day, value: i, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        let remainingDays = 42 - days.count
        for i in 0..<remainingDays {
            if let lastDay = days.last,
               let date = calendar.date(byAdding: .day, value: i + 1, to: lastDay) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func progressForDate(_ date: Date) -> DailyProgress? {
        return dailyProgress.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let progress: DailyProgress?
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.ubuntu(16, weight: isToday ? .bold : .medium))
                    .foregroundColor(textColor)
                
                Circle()
                    .fill(progressColor)
                    .frame(width: 6, height: 6)
                    .opacity(progress != nil ? 1.0 : 0.0)
            }
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? AppColors.primaryAccent : Color.clear, lineWidth: 2)
            )
        }
    }
    
    private var textColor: Color {
        if isCurrentMonth {
            return isToday ? AppColors.accentText : AppColors.primaryText
        } else {
            return AppColors.primaryText.opacity(0.3)
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppColors.primaryAccent.opacity(0.3)
        } else if isToday {
            return AppColors.primaryAccent
        } else {
            return Color.clear
        }
    }
    
    private var progressColor: Color {
        guard let progress = progress else { return Color.clear }
        
        let percentage = progress.completionPercentage
        if percentage >= 0.8 {
            return AppColors.success
        } else if percentage >= 0.5 {
            return AppColors.warning
        } else if percentage > 0 {
            return AppColors.info
        } else {
            return Color.clear
        }
    }
    
    private var isCurrentMonth: Bool {
        calendar.isDate(date, equalTo: Date(), toGranularity: .month)
    }
}

struct StatsView: View {
    let dailyProgress: [DailyProgress]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Progress")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCardView(
                    title: "Total Days",
                    value: "\(dailyProgress.count)",
                    icon: "calendar"
                )
                
                StatCardView(
                    title: "Current Streak",
                    value: "\(currentStreak)",
                    icon: "flame.fill"
                )
                
                StatCardView(
                    title: "Best Month",
                    value: bestMonth,
                    icon: "star.fill"
                )
                
                StatCardView(
                    title: "Completion Rate",
                    value: "\(Int(averageCompletion * 100))%",
                    icon: "chart.line.uptrend.xyaxis"
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
    }
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        
        for i in 0..<dailyProgress.count {
            let date = calendar.startOfDay(for: today.addingTimeInterval(-Double(i) * 24 * 60 * 60))
            if let progress = dailyProgress.first(where: { calendar.isDate($0.date, inSameDayAs: date) }),
               progress.completionPercentage > 0 {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }
    
    private var averageCompletion: Double {
        guard !dailyProgress.isEmpty else { return 0 }
        let total = dailyProgress.reduce(0) { $0 + $1.completionPercentage }
        return total / Double(dailyProgress.count)
    }
    
    private var bestMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: Date())
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primaryText)
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(.ubuntu(12, weight: .light))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.softGradient)
        .cornerRadius(16)
    }
}

#Preview {
    HistoryView(viewModel: AppViewModel())
}
