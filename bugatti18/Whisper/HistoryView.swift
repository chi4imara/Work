import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(Theme.Fonts.playfairBold(size: 24))
                        .foregroundColor(Theme.Colors.text)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.lg)
                
                if viewModel.dailyEntries.isEmpty {
                    EmptyHistoryView()
                } else {
                    HistoryContentView(viewModel: viewModel, selectedDate: $selectedDate)
                }
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate, viewModel: viewModel)
        }
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.Colors.primary.opacity(0.1),
                                Theme.Colors.primary.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(Theme.Colors.primary)
            }
            
            VStack(spacing: Theme.Spacing.md) {
                Text("No History Yet")
                    .font(Theme.Fonts.playfairSemiBold(size: 20))
                    .foregroundColor(Theme.Colors.text)
                
                Text("Start your journey today and watch your progress grow")
                    .font(Theme.Fonts.playfairRegular(size: 16))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
        }
    }
}

struct HistoryContentView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Binding var selectedDate: Date
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.lg) {
                CalendarView(
                    entries: viewModel.dailyEntries,
                    selectedDate: $selectedDate,
                    onDateSelected: { date in
                        viewModel.selectDate(date)
                    }
                )
                
                if let entry = viewModel.selectedEntry {
                    DayDetailView(entry: entry)
                } else if Calendar.current.isDate(selectedDate, inSameDayAs: Date()) {
                    TodayPromptView()
                } else {
                    EmptyDayView(date: selectedDate)
                }
                
                ProgressChartView(entries: viewModel.dailyEntries)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.top, Theme.Spacing.lg)
            .padding(.bottom, 120)
        }
    }
}

struct CalendarView: View {
    let entries: [DailyEntry]
    @Binding var selectedDate: Date
    let onDateSelected: (Date) -> Void
    
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Theme.Colors.primary)
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(Theme.Fonts.playfairSemiBold(size: 18))
                    .foregroundColor(Theme.Colors.text)
                
                Spacer()
                
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.Colors.primary)
                }
            }
            .padding(.horizontal, Theme.Spacing.sm)
            
            HStack {
                ForEach(Array(["S", "M", "T", "W", "T", "F", "S"].enumerated()), id: \.offset) { _, day in
                    Text(day)
                        .font(Theme.Fonts.playfairMedium(size: 12))
                        .foregroundColor(Theme.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let days = generateCalendarDays()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: Theme.Spacing.xs) {
                ForEach(days, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        hasEntry: entries.contains { calendar.isDate($0.date, inSameDayAs: date) },
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        onTap: {
                            selectedDate = date
                            onDateSelected(date)
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
    
    private func changeMonth(_ direction: Int) {
        withAnimation(Theme.Animation.medium) {
            currentMonth = calendar.date(byAdding: .month, value: direction, to: currentMonth) ?? currentMonth
        }
    }
    
    private func generateCalendarDays() -> [Date] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let numberOfDaysInMonth = monthRange.count
        
        var days: [Date] = []
        
        for i in 1..<firstWeekday {
            if let date = calendar.date(byAdding: .day, value: -(firstWeekday - i), to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        for day in 1...numberOfDaysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        let remainingDays = 42 - days.count
        for i in 1...remainingDays {
            if let lastDay = days.last,
               let date = calendar.date(byAdding: .day, value: i, to: lastDay) {
                days.append(date)
            }
        }
        
        return days
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEntry: Bool
    let isCurrentMonth: Bool
    let onTap: () -> Void
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.sm)
                    .fill(isSelected ? Theme.Colors.primary : Color.clear)
                    .frame(width: 32, height: 32)
                
                Text(dayFormatter.string(from: date))
                    .font(Theme.Fonts.playfairMedium(size: 14))
                    .foregroundColor(
                        isSelected ? .white :
                        isCurrentMonth ? Theme.Colors.text : Theme.Colors.textSecondary.opacity(0.5)
                    )
                
                if hasEntry && !isSelected {
                    VStack {
                        Spacer()
                        Circle()
                            .fill(Theme.Colors.accent)
                            .frame(width: 4, height: 4)
                            .offset(y: -2)
                    }
                }
            }
        }
        .frame(width: 40, height: 40)
    }
}

struct DayDetailView: View {
    let entry: DailyEntry
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text(dateFormatter.string(from: entry.date))
                .font(Theme.Fonts.playfairSemiBold(size: 18))
                .foregroundColor(Theme.Colors.text)
            
            if !entry.selectedMoods.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Mood")
                        .font(Theme.Fonts.playfairMedium(size: 14))
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    HStack {
                        ForEach(entry.selectedMoods) { mood in
                            VStack(spacing: 2) {
                                Text(mood.emoji)
                                    .font(.title2)
                                Text(mood.name)
                                    .font(Theme.Fonts.playfairRegular(size: 10))
                                    .foregroundColor(Theme.Colors.textSecondary)
                            }
                        }
                        Spacer()
                    }
                }
            }
            
            if !entry.gratitudeEntries.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Gratitude")
                        .font(Theme.Fonts.playfairMedium(size: 14))
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    ForEach(entry.gratitudeEntries) { gratitude in
                        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Theme.Colors.accent)
                                .font(.caption)
                                .padding(.top, 2)
                            
                            Text(gratitude.text)
                                .font(Theme.Fonts.playfairRegular(size: 14))
                                .foregroundColor(Theme.Colors.text)
                        }
                    }
                }
            }
            
            if let question = entry.dailyQuestion, !question.answer.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Daily Question")
                        .font(Theme.Fonts.playfairMedium(size: 14))
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    Text(question.question)
                        .font(Theme.Fonts.playfairMedium(size: 14))
                        .foregroundColor(Theme.Colors.primary)
                    
                    Text(question.answer)
                        .font(Theme.Fonts.playfairRegular(size: 14))
                        .foregroundColor(Theme.Colors.text)
                }
            }
            
            if !entry.completedHabits.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Theme.Colors.success)
                    
                    Text("\(entry.completedHabits.count) habits completed")
                        .font(Theme.Fonts.playfairMedium(size: 14))
                        .foregroundColor(Theme.Colors.success)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct TodayPromptView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "sun.max.fill")
                .foregroundColor(Theme.Colors.secondary)
                .font(.title)
            
            Text("Today is waiting for you!")
                .font(Theme.Fonts.playfairSemiBold(size: 16))
                .foregroundColor(Theme.Colors.text)
            
            Text("Go to the Today tab to start your daily journey")
                .font(Theme.Fonts.playfairRegular(size: 14))
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct EmptyDayView: View {
    let date: Date
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "moon.zzz.fill")
                .foregroundColor(Theme.Colors.textSecondary)
                .font(.title)
            
            Text("No entries for \(dateFormatter.string(from: date))")
                .font(Theme.Fonts.playfairMedium(size: 16))
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.5))
        )
    }
}

struct ProgressChartView: View {
    let entries: [DailyEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Progress Overview")
                .font(Theme.Fonts.playfairSemiBold(size: 18))
                .foregroundColor(Theme.Colors.text)
            
            if entries.isEmpty {
                Text("No data to display yet")
                    .font(Theme.Fonts.playfairRegular(size: 14))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, Theme.Spacing.xl)
            } else {
                let last7Days = entries.prefix(7)
                
                HStack(alignment: .bottom, spacing: Theme.Spacing.sm) {
                    ForEach(Array(last7Days.enumerated()), id: \.offset) { index, entry in
                        VStack(spacing: Theme.Spacing.xs) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.Colors.primary, Theme.Colors.accent],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .frame(width: 30, height: CGFloat(entry.progressPercentage * 60))
                            
                            Text(DateFormatter.shortDay.string(from: entry.date))
                                .font(Theme.Fonts.playfairRegular(size: 10))
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 80)
                
                HStack {
                    Text("Daily completion rate over the last 7 days")
                        .font(Theme.Fonts.playfairRegular(size: 12))
                        .foregroundColor(Theme.Colors.textSecondary)
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.selectDate(selectedDate)
                        dismiss()
                    }
                }
            }
        }
    }
}

extension DateFormatter {
    static let shortDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
}

#Preview {
    HistoryView()
}
