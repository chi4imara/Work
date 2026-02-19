import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: SkinCareViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerView
                    
                    calendarView
                    
                    selectedDateView
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("History")
                .font(.titleLarge)
                .foregroundColor(ColorManager.primaryText)
            
            Text("View your skincare journey")
                .font(.bodyMedium)
                .foregroundColor(ColorManager.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var calendarView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ColorManager.primaryBlue)
                }
                
                Spacer()
                
                Text(monthYearString(from: currentMonth))
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ColorManager.primaryBlue)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(ColorManager.secondaryText)
                        .fontWeight(.medium)
                        .frame(height: 30)
                }
                
                ForEach(Array(calendarDays.enumerated()), id: \.offset) { _, date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                            progress: viewModel.getProgressForDate(date),
                            onTap: { selectedDate = date }
                        )
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorManager.shadowColor, radius: 10, x: 0, y: 5)
    }
    
    private var selectedDateView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(dateFormatter.string(from: selectedDate))
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            if let progress = viewModel.getProgressForDate(selectedDate) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Completion: \(Int(progress.completionPercentage))%")
                            .font(.bodyLarge)
                            .foregroundColor(ColorManager.darkText)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(progress.completedProcedures.count)/\(progress.totalProcedures)")
                            .font(.bodyMedium)
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    
                    ProgressView(value: min(max(progress.completionPercentage, 0), 100), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: ColorManager.primaryBlue))
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                }
                
                let skinEntries = viewModel.getSkinEntriesForDate(selectedDate)
                if !skinEntries.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Skin Condition")
                            .font(.bodyLarge)
                            .foregroundColor(ColorManager.primaryText)
                            .fontWeight(.medium)
                        
                        ForEach(skinEntries, id: \.id) { entry in
                            HStack(spacing: 12) {
                                Image(systemName: entry.condition.icon)
                                    .font(.system(size: 16))
                                    .foregroundColor(ColorManager.primaryBlue)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(entry.condition.rawValue)
                                        .font(.bodyMedium)
                                        .foregroundColor(ColorManager.darkText)
                                    
                                    if !entry.notes.isEmpty {
                                        Text(entry.notes)
                                            .font(.bodySmall)
                                            .foregroundColor(ColorManager.secondaryText)
                                            .lineLimit(2)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.circle")
                        .font(.system(size: 30))
                        .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
                    
                    Text("No data for this date")
                        .font(.bodyMedium)
                        .foregroundColor(ColorManager.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
        }
        .padding(20)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorManager.shadowColor, radius: 10, x: 0, y: 5)
        .padding(.top, 20)
    }
    
    private var calendarDays: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end - 1)
        else { return [] }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        
        return calendar.generateDates(
            inside: dateInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        ).map { date in
            calendar.isDate(date, equalTo: currentMonth, toGranularity: .month) ? date : nil
        }
    }
    
    private func previousMonth() {
        withAnimation {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func monthYearString(from date: Date) -> String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    init(viewModel: SkinCareViewModel) {
        self.viewModel = viewModel
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let progress: DailyProgress?
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .frame(height: 40)
                
                VStack(spacing: 2) {
                    Text(dayNumber)
                        .font(.bodySmall)
                        .foregroundColor(textColor)
                        .fontWeight(isToday ? .bold : .regular)
                    
                    if let progress = progress, progress.totalProcedures > 0 {
                        Circle()
                            .fill(progressColor)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return ColorManager.primaryBlue
        } else if isToday {
            return ColorManager.primaryYellow.opacity(0.3)
        } else {
            return Color.clear
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if !isCurrentMonth {
            return ColorManager.secondaryText.opacity(0.5)
        } else {
            return ColorManager.darkText
        }
    }
    
    private var progressColor: Color {
        guard let progress = progress else { return Color.clear }
        
        if progress.isFullyCompleted {
            return ColorManager.successGreen
        } else if progress.completionPercentage > 0 {
            return ColorManager.primaryYellow
        } else {
            return ColorManager.secondaryText.opacity(0.3)
        }
    }
}

extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

#Preview {
    HistoryView(viewModel: SkinCareViewModel())
}
