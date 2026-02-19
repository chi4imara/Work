import SwiftUI
import Combine

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("History")
                    .font(FontManager.playfairBold(size: 26))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    monthNavigationHeader
                    
                    calendarGrid
                    
                    selectedDateDetails
                }
            }
        }
        .primaryBackground()
        .onAppear {
            viewModel.loadHistoryData()
        }
    }
    
    private var monthNavigationHeader: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryAccent)
                    .frame(width: 44, height: 44)
                    .background(ColorTheme.primaryAccent.opacity(0.1))
                    .cornerRadius(12)
            }
            
            Spacer()
            
            Button(action: { showingDatePicker = true }) {
                Text(viewModel.currentMonth, style: .date)
                    .font(FontManager.playfairBold(size: 20))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryAccent)
                    .frame(width: 44, height: 44)
                    .background(ColorTheme.primaryAccent.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(FontManager.playfairSemiBold(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(viewModel.calendarDays, id: \.date) { day in
                    CalendarDayView(
                        day: day,
                        isSelected: Calendar.current.isDate(day.date, inSameDayAs: selectedDate),
                        onTap: { selectedDate = day.date }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .cardBackground()
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    private var selectedDateDetails: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Details for \(selectedDate, style: .date)")
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if let progress = viewModel.getProgress(for: selectedDate) {
                    Text("\(Int(progress.totalProgress * 100))% Complete")
                        .font(FontManager.playfairMedium(size: 14))
                        .foregroundColor(ColorTheme.primaryAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                        .background(ColorTheme.primaryAccent.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            if let progress = viewModel.getProgress(for: selectedDate) {
                VStack(spacing: 12) {
                    ProgressDetailRow(
                        icon: "dumbbell.fill",
                        title: "Workouts",
                        completed: progress.workoutsCompleted,
                        color: ColorTheme.primaryAccent
                    )
                    
                    ProgressDetailRow(
                        icon: "leaf.fill",
                        title: "Nutrition",
                        completed: progress.nutritionItemsCompleted,
                        color: ColorTheme.success
                    )
                    
                    ProgressDetailRow(
                        icon: "checkmark.circle.fill",
                        title: "Tasks",
                        completed: progress.tasksCompleted,
                        color: ColorTheme.warning
                    )
                    
                    ProgressDetailRow(
                        icon: "trophy.fill",
                        title: "Challenges",
                        completed: progress.challengesCompleted,
                        color: ColorTheme.error
                    )
                    
                    HStack {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryAccent)
                            .frame(width: 24)
                        
                        Text("Water Intake")
                            .font(FontManager.playfairMedium(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        Text("\(progress.waterIntake.currentAmount) / \(progress.waterIntake.targetAmount) ml")
                            .font(FontManager.playfairRegular(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(ColorTheme.primaryAccent.opacity(0.2))
                                .frame(width: 60, height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(ColorTheme.primaryAccent)
                                .frame(width: 60 * progress.waterIntake.progress, height: 6)
                                .cornerRadius(3)
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .cardBackground()
                .cornerRadius(16)
                .padding(.horizontal, 20)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 32))
                        .foregroundColor(ColorTheme.primaryAccent.opacity(0.6))
                    
                    Text("No activity recorded")
                        .font(FontManager.playfairMedium(size: 16))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Start tracking your daily activities to see your progress here")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .cardBackground()
                .cornerRadius(16)
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            viewModel.previousMonth()
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            viewModel.nextMonth()
        }
    }
}

struct CalendarDayView: View {
    let day: CalendarDay
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: day.date))")
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(dayTextColor)
                
                if day.hasActivity {
                    HStack(spacing: 2) {
                        ForEach(0..<4, id: \.self) { index in
                            Circle()
                                .fill(progressColor(for: index))
                                .frame(width: 4, height: 4)
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 4)
                }
            }
            .frame(width: 40, height: 50)
            .background(dayBackgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorTheme.primaryAccent : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var dayTextColor: Color {
        if day.isCurrentMonth {
            return isSelected ? ColorTheme.primaryText : ColorTheme.primaryText
        } else {
            return ColorTheme.secondaryText.opacity(0.5)
        }
    }
    
    private var dayBackgroundColor: Color {
        if isSelected {
            return ColorTheme.primaryAccent.opacity(0.2)
        } else if day.hasActivity {
            return ColorTheme.cardBackground
        } else {
            return Color.clear
        }
    }
    
    private func progressColor(for index: Int) -> Color {
        guard let progress = day.progress else { return ColorTheme.primaryAccent.opacity(0.3) }
        
        let colors = [ColorTheme.primaryAccent, ColorTheme.success, ColorTheme.warning, ColorTheme.error]
        let values = [
            progress.workoutsCompleted > 0,
            progress.nutritionItemsCompleted > 0,
            progress.tasksCompleted > 0,
            progress.challengesCompleted > 0
        ]
        
        return values[index] ? colors[index] : colors[index].opacity(0.3)
    }
}

struct ProgressDetailRow: View {
    let icon: String
    let title: String
    let completed: Int
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(FontManager.playfairMedium(size: 16))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text("\(completed)")
                .font(FontManager.playfairSemiBold(size: 16))
                .foregroundColor(color)
                .frame(minWidth: 30)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

class HistoryViewModel: ObservableObject {
    @Published var currentMonth = Date()
    @Published var calendarDays: [CalendarDay] = []
    @Published var progressData: [Date: DailyProgress] = [:]
    
    private let calendar = Calendar.current
    
    init() {
        generateCalendarDays()
    }
    
    private static var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone.current
        return f
    }()
    
    func loadHistoryData() {
        let dm = DataManager.shared
        var datesToConsider = Set<Date>()
        
        for w in dm.workouts {
            if let d = w.completedDate {
                datesToConsider.insert(calendar.startOfDay(for: d))
            }
        }
        for n in dm.nutritionItems {
            if let d = n.completedDate {
                datesToConsider.insert(calendar.startOfDay(for: d))
            }
        }
        for t in dm.tasks {
            if let d = t.completedDate {
                datesToConsider.insert(calendar.startOfDay(for: d))
            }
        }
        for (key, _) in dm.dailyProgress {
            if let date = Self.dateFormatter.date(from: key) {
                datesToConsider.insert(calendar.startOfDay(for: date))
            }
        }
        
        var result: [Date: DailyProgress] = [:]
        for date in datesToConsider {
            let workoutsCompleted = dm.workouts.filter { w in
                guard let d = w.completedDate else { return false }
                return calendar.isDate(d, inSameDayAs: date)
            }.count
            let nutritionItemsCompleted = dm.nutritionItems.filter { n in
                guard let d = n.completedDate else { return false }
                return calendar.isDate(d, inSameDayAs: date)
            }.count
            let tasksCompleted = dm.tasks.filter { t in
                guard let d = t.completedDate else { return false }
                return calendar.isDate(d, inSameDayAs: date)
            }.count
            let existing = dm.getDailyProgress(for: date)
            let challengesCompleted = existing?.challengesCompleted ?? 0
            let waterIntake = existing?.waterIntake ?? WaterIntake()
            
            var progress = DailyProgress(date: date)
            progress.workoutsCompleted = workoutsCompleted
            progress.nutritionItemsCompleted = nutritionItemsCompleted
            progress.tasksCompleted = tasksCompleted
            progress.challengesCompleted = challengesCompleted
            progress.waterIntake = waterIntake
            result[date] = progress
        }
        progressData = result
        generateCalendarDays()
    }
    
    func getProgress(for date: Date) -> DailyProgress? {
        return progressData.first { calendar.isDate($0.key, inSameDayAs: date) }?.value
    }
    
    func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        generateCalendarDays()
    }
    
    func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        generateCalendarDays()
    }
    
    private func generateCalendarDays() {
        calendarDays = []
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        
        for dayOffset in (1 - firstWeekday)..<0 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: firstOfMonth) {
                let day = CalendarDay(
                    date: date,
                    isCurrentMonth: false,
                    hasActivity: progressData.keys.contains { calendar.isDate($0, inSameDayAs: date) },
                    progress: getProgress(for: date)
                )
                calendarDays.append(day)
            }
        }
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                let calendarDay = CalendarDay(
                    date: date,
                    isCurrentMonth: true,
                    hasActivity: progressData.keys.contains { calendar.isDate($0, inSameDayAs: date) },
                    progress: getProgress(for: date)
                )
                calendarDays.append(calendarDay)
            }
        }
        
        let totalCells = 42
        let remainingCells = totalCells - calendarDays.count
        let lastOfMonth = monthInterval.end
        
        for dayOffset in 0..<remainingCells {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: lastOfMonth) {
                let day = CalendarDay(
                    date: date,
                    isCurrentMonth: false,
                    hasActivity: progressData.keys.contains { calendar.isDate($0, inSameDayAs: date) },
                    progress: getProgress(for: date)
                )
                calendarDays.append(day)
            }
        }
    }
}

struct CalendarDay {
    let date: Date
    let isCurrentMonth: Bool
    let hasActivity: Bool
    let progress: DailyProgress?
}

#Preview {
    HistoryView()
}
