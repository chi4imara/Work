import SwiftUI

struct CalendarGridView: View {
    let currentMonth: Date
    let moodEntries: [MoodEntry]
    let settings: AppSettings
    let onDateTapped: (Date) -> Void
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    private var monthDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let monthEnd = monthInterval.end
        
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let daysFromPreviousMonth = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date] = []
        
        if daysFromPreviousMonth > 0 {
            for i in (1...daysFromPreviousMonth).reversed() {
                if let date = calendar.date(byAdding: .day, value: -i, to: monthStart) {
                    days.append(date)
                }
            }
        }
        
        var currentDate = monthStart
        while currentDate < monthEnd {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? monthEnd
        }
        
        let remainingDays = 42 - days.count
        for i in 0..<remainingDays {
            if let date = calendar.date(byAdding: .day, value: i, to: monthEnd) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private var weekdayHeaders: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.shortWeekdaySymbols
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                ForEach(weekdayHeaders, id: \.self) { weekday in
                    Text(weekday)
                        .font(FontManager.caption)
                        .foregroundColor(Color.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(monthDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        currentMonth: currentMonth,
                        moodEntry: getMoodEntry(for: date),
                        settings: settings,
                        isToday: calendar.isDateInToday(date),
                        onTap: {
                            onDateTapped(date)
                        }
                    )
                }
            }
        }
    }
    
    private func getMoodEntry(for date: Date) -> MoodEntry? {
        return moodEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let currentMonth: Date
    let moodEntry: MoodEntry?
    let settings: AppSettings
    let isToday: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    private var isCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isFutureDate: Bool {
        date > Date()
    }
    
    var body: some View {
        Button(action: {
            if !isFutureDate {
                onTap()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .frame(height: 40)
                
                Text(dayNumber)
                    .font(FontManager.caption)
                    .foregroundColor(textColor)
                
                if let mood = moodEntry?.mood {
                    Text(settings.useExtendedMoods ? mood.extendedEmoji : mood.emoji)
                        .font(.system(size: 12))
                        .offset(x: 8, y: -8)
                }
                
                if isToday && moodEntry == nil {
                    Circle()
                        .stroke(Color.primaryBlue, lineWidth: 2)
                        .frame(width: 36, height: 36)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isFutureDate)
    }
    
    private var backgroundColor: Color {
        if !isCurrentMonth {
            return Color.clear
        } else if let mood = moodEntry?.mood {
            return moodBackgroundColor(for: mood)
        } else if isToday {
            return Color.lightBlue.opacity(0.2)
        } else {
            return Color.backgroundGray.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return Color.textSecondary.opacity(0.3)
        } else if isFutureDate {
            return Color.textSecondary.opacity(0.5)
        } else if moodEntry != nil {
            return Color.textPrimary
        } else if isToday {
            return Color.primaryBlue
        } else {
            return Color.textPrimary
        }
    }
    
    private func moodBackgroundColor(for mood: MoodType) -> Color {
        switch mood {
        case .veryBad:
            return Color.moodVeryBad.opacity(0.2)
        case .bad:
            return Color.moodBad.opacity(0.2)
        case .neutral:
            return Color.moodNeutral.opacity(0.2)
        case .good:
            return Color.moodGood.opacity(0.2)
        case .veryGood:
            return Color.moodVeryGood.opacity(0.2)
        }
    }
}

#Preview {
    CalendarGridView(
        currentMonth: Date(),
        moodEntries: [],
        settings: AppSettings(),
        onDateTapped: { _ in }
    )
    .padding()
}
