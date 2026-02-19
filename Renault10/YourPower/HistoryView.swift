import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedMonth = Date()
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("History")
                        .font(FontManager.bold(size: 26))
                        .foregroundColor(ColorManager.darkGray)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        monthNavigationView
                        
                        calendarView
                        
                        if let selectedEntry = viewModel.selectedEntry {
                            dayDetailsView(selectedEntry)
                        } else {
                            emptyDayView
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
            .onAppear {
                viewModel.refreshFromStorage()
            }
        }
    }
    
    private var monthNavigationView: some View {
        HStack {
            Button(action: { changeMonth(-1) }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryBlue)
            }
            
            Spacer()
            
            Text(monthYearString(selectedMonth))
                .font(FontManager.bold(size: 20))
                .foregroundColor(ColorManager.darkGray)
            
            Spacer()
            
            Button(action: { changeMonth(1) }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(ColorManager.cardGradient)
    }
    
    private var calendarView: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(weekdayHeaders, id: \.self) { weekday in
                    Text(weekday)
                        .font(FontManager.medium(size: 14))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        entry: viewModel.getEntry(for: date),
                        isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: selectedMonth, toGranularity: .month)
                    ) {
                        viewModel.selectDate(date)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .background(ColorManager.cardGradient)
    }
    
    private func dayDetailsView(_ entry: DailyEntry) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Text(dayString(entry.date))
                        .font(FontManager.bold(size: 20))
                        .foregroundColor(ColorManager.primaryBlue)
                    
                    Spacer()
                    
                    Text("\(Int(entry.progressPercentage * 100))% completed")
                        .font(FontManager.medium(size: 14))
                        .foregroundColor(ColorManager.success)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(ColorManager.success.opacity(0.1))
                        .cornerRadius(12)
                }
                
                if !entry.energyLevels.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Energy Levels")
                            .font(FontManager.medium(size: 16))
                            .foregroundColor(ColorManager.darkGray)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                            ForEach(entry.energyLevels, id: \.self) { level in
                                HStack(spacing: 8) {
                                    Image(systemName: level.icon)
                                        .font(.system(size: 16))
                                        .foregroundColor(level.color)
                                    
                                    Text(level.title)
                                        .font(FontManager.regular(size: 12))
                                        .foregroundColor(ColorManager.darkGray)
                                }
                                .padding(8)
                                .background(level.color.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Activities")
                        .font(FontManager.medium(size: 16))
                        .foregroundColor(ColorManager.darkGray)
                    
                    VStack(spacing: 8) {
                        ActivityRow(
                            title: "Mini Ritual",
                            isCompleted: entry.completedRitual,
                            icon: "leaf.fill"
                        )
                        
                        ActivityRow(
                            title: "Daily Challenge",
                            isCompleted: entry.completedChallenge,
                            icon: "target"
                        )
                        
                        ActivityRow(
                            title: "Habits",
                            isCompleted: !entry.completedHabits.isEmpty,
                            icon: "heart.fill",
                            subtitle: entry.completedHabits.isEmpty ? nil : "\(entry.completedHabits.count) completed"
                        )
                    }
                }
                
                if !entry.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(FontManager.medium(size: 16))
                            .foregroundColor(ColorManager.darkGray)
                        
                        Text(entry.notes)
                            .font(FontManager.regular(size: 14))
                            .foregroundColor(ColorManager.darkGray.opacity(0.8))
                            .padding(12)
                            .background(ColorManager.lightBlue)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
        }
        .background(ColorManager.cardGradient)
    }
    
    private var emptyDayView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "calendar")
                .font(.system(size: 40))
                .foregroundColor(ColorManager.lightGray)
            
            Text("No activity on this day")
                .font(FontManager.medium(size: 16))
                .foregroundColor(ColorManager.darkGray.opacity(0.7))
            
            Text("Select a day with activity to see details")
                .font(FontManager.regular(size: 14))
                .foregroundColor(ColorManager.darkGray.opacity(0.5))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorManager.cardGradient)
    }
    
    private var weekdayHeaders: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.shortWeekdaySymbols
    }
    
    private var calendarDays: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedMonth)?.start ?? selectedMonth
        let endOfMonth = calendar.dateInterval(of: .month, for: selectedMonth)?.end ?? selectedMonth
        
        let startWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysFromPreviousMonth = startWeekday - 1
        
        var days: [Date] = []
        
        for offset in stride(from: daysFromPreviousMonth, to: 0, by: -1) {
            if let date = calendar.date(byAdding: .day, value: -offset, to: startOfMonth) {
                days.append(date)
            }
        }
        
        var currentDate = startOfMonth
        while currentDate < endOfMonth {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        let remainingDays = max(0, 42 - days.count)
        for i in 0..<remainingDays {
            if let date = calendar.date(byAdding: .day, value: i, to: endOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func changeMonth(_ direction: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: direction, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }
    
    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func dayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
}

struct CalendarDayView: View {
    let date: Date
    let entry: DailyEntry?
    let isSelected: Bool
    let isCurrentMonth: Bool
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var progressColor: Color {
        guard let entry = entry else { return ColorManager.lightGray }
        
        switch entry.progressPercentage {
        case 0.75...1.0: return ColorManager.success
        case 0.5..<0.75: return ColorManager.primaryYellow
        case 0.25..<0.5: return ColorManager.primaryBlue
        default: return ColorManager.lightGray
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(textColor)
                
                Circle()
                    .fill(entry != nil ? progressColor : ColorManager.lightGray.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
            .frame(width: 40, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return ColorManager.lightGray
        } else if isToday {
            return .white
        } else {
            return ColorManager.darkGray
        }
    }
    
    private var backgroundColor: Color {
        if isToday {
            return ColorManager.primaryBlue
        } else if isSelected {
            return ColorManager.primaryBlue.opacity(0.1)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        return ColorManager.primaryBlue
    }
}

struct ActivityRow: View {
    let title: String
    let isCompleted: Bool
    let icon: String
    let subtitle: String?
    
    init(title: String, isCompleted: Bool, icon: String, subtitle: String? = nil) {
        self.title = title
        self.isCompleted = isCompleted
        self.icon = icon
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20))
                .foregroundColor(isCompleted ? ColorManager.success : ColorManager.lightGray)
            
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(ColorManager.primaryBlue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(FontManager.medium(size: 14))
                    .foregroundColor(ColorManager.darkGray)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(FontManager.regular(size: 12))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HistoryView()
}
