import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: DailyEntryViewModel
    @State private var selectedDate = Date()
    @State private var showingDateDetail = false
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 8) {
                        Text("Your Journey")
                            .font(AppFonts.playfairBold(size: 28))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Reflect on your progress")
                            .font(AppFonts.playfairRegular(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    CalendarView(
                        selectedDate: $selectedDate,
                        entries: viewModel.dailyEntries
                    ) { date in
                        selectedDate = date
                        showingDateDetail = true
                    }
                    
                    QuickStatsView(entries: viewModel.dailyEntries)
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(isPresented: $showingDateDetail) {
            DayDetailView(viewModel: viewModel, date: selectedDate)
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let entries: [DailyEntry]
    let onDateSelected: (Date) -> Void
    
    @State private var currentMonth = Date()
    private let calendar = Calendar.current
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let daysToSubtract = firstWeekday - 1
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstOfMonth) else {
            return []
        }
        
        var days: [Date] = []
        for i in 0..<42 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                days.append(date)
            }
        }
        
        return days
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                Text(monthYearFormatter.string(from: currentMonth))
                    .font(AppFonts.playfairSemiBold(size: 20))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
            }
            
            HStack(spacing: 0) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { weekday in
                    Text(weekday)
                        .font(AppFonts.playfairMedium(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        currentMonth: currentMonth,
                        selectedDate: selectedDate,
                        entry: getEntry(for: date)
                    ) {
                        selectedDate = date
                        onDateSelected(date)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
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
    
    private func getEntry(for date: Date) -> DailyEntry? {
        return entries.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
}

struct CalendarDayView: View {
    let date: Date
    let currentMonth: Date
    let selectedDate: Date
    let entry: DailyEntry?
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    private var isInCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var isSelected: Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var isToday: Bool {
        calendar.isDate(date, inSameDayAs: Date())
    }
    
    private var dayNumber: String {
        String(calendar.component(.day, from: date))
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(AppFonts.playfairMedium(size: 14))
                    .foregroundColor(textColor)
                
                HStack(spacing: 2) {
                    if let entry = entry {
                        if entry.mood != nil {
                            Circle()
                                .fill(AppColors.accentYellow)
                                .frame(width: 4, height: 4)
                        }
                        
                        if entry.progressPercentage > 0 {
                            Circle()
                                .fill(entry.progressPercentage == 1.0 ? AppColors.lightGreen : AppColors.softPink)
                                .frame(width: 4, height: 4)
                        }
                    }
                }
                .frame(height: 8)
            }
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
                    )
            )
        }
        .disabled(!isInCurrentMonth)
    }
    
    private var textColor: Color {
        if !isInCurrentMonth {
            return AppColors.secondaryText.opacity(0.3)
        } else if isToday {
            return AppColors.primaryBlue
        } else {
            return AppColors.primaryText
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppColors.accentYellow.opacity(0.3)
        } else if isToday {
            return AppColors.accentYellow.opacity(0.1)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return AppColors.accentYellow
        } else {
            return Color.clear
        }
    }
}

struct QuickStatsView: View {
    let entries: [DailyEntry]
    
    private var totalDaysTracked: Int {
        entries.count
    }
    
    private var averageCompletion: Double {
        guard !entries.isEmpty else { return 0 }
        let total = entries.reduce(0) { $0 + $1.progressPercentage }
        return total / Double(entries.count)
    }
    
    private var perfectDays: Int {
        entries.filter { $0.progressPercentage == 1.0 }.count
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Progress")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 20) {
                StatItemView(
                    title: "Days Tracked",
                    value: "\(totalDaysTracked)",
                    icon: "calendar"
                )
                
                StatItemView(
                    title: "Avg. Completion",
                    value: "\(Int(averageCompletion * 100))%",
                    icon: "chart.bar"
                )
                
                StatItemView(
                    title: "Perfect Days",
                    value: "\(perfectDays)",
                    icon: "star.fill"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct StatItemView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.accentYellow)
            
            Text(value)
                .font(AppFonts.playfairBold(size: 20))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(AppFonts.playfairRegular(size: 12))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DayDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DailyEntryViewModel
    let date: Date
    
    private var entry: DailyEntry? {
        viewModel.getEntry(for: date)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackgroundView()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Text(dateFormatter.string(from: date))
                            .font(AppFonts.playfairBold(size: 24))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        
                        if let entry = entry {
                            if let mood = entry.mood {
                                MoodDisplayView(mood: mood)
                            }
                            
                            if !entry.tasks.isEmpty {
                                TasksDisplayView(tasks: entry.tasks)
                            }
                            
                            if !entry.dailyAnswer.isEmpty {
                                ReflectionDisplayView(
                                    question: entry.dailyQuestion,
                                    answer: entry.dailyAnswer
                                )
                            }
                            
                            ProgressDisplayView(progress: entry.progressPercentage)
                        } else {
                            NoDataView()
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Day Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

struct MoodDisplayView: View {
    let mood: Mood
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Mood")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 8) {
                Image(systemName: mood.rawValue)
                    .font(.system(size: 30))
                    .foregroundColor(AppColors.accentYellow)
                
                Text(mood.displayName)
                    .font(AppFonts.playfairRegular(size: 16))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct TasksDisplayView: View {
    let tasks: [TaskG]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Tasks")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(tasks) { task in
                    HStack(spacing: 12) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 16))
                            .foregroundColor(task.isCompleted ? AppColors.lightGreen : AppColors.secondaryText)
                        
                        Text(task.title)
                            .font(AppFonts.playfairRegular(size: 14))
                            .foregroundColor(task.isCompleted ? AppColors.secondaryText : AppColors.primaryText)
                            .strikethrough(task.isCompleted)
                        
                        Spacer()
                        
                        Image(systemName: task.icon)
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.accentYellow)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct ReflectionDisplayView: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Daily Reflection")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(question)
                    .font(AppFonts.playfairRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(answer)
                    .font(AppFonts.playfairRegular(size: 16))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct ProgressDisplayView: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Completion Rate")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 8) {
                Text("\(Int(progress * 100))%")
                    .font(AppFonts.playfairBold(size: 24))
                    .foregroundColor(AppColors.accentYellow)
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accentYellow))
                    .scaleEffect(y: 2)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct NoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No data for this day")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            Text("Start tracking your daily activities to see your progress here.")
                .font(AppFonts.playfairRegular(size: 14))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}
