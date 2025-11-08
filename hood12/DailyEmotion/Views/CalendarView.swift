import SwiftUI

struct CalendarView: View {
    @ObservedObject var dataManager: EmotionDataManager
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var selectedEntry: EmotionEntry?
    @State private var showingEntryDetail = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var monthYearString: String {
        dateFormatter.string(from: currentMonth)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let monthEnd = monthInterval.end
        
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let daysToSubtract = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        guard let calendarStart = calendar.date(byAdding: .day, value: -daysToSubtract, to: monthStart) else {
            return []
        }
        
        var days: [Date] = []
        var currentDate = calendarStart
        
        for _ in 0..<42 {
            days.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
            
            if currentDate >= monthEnd && days.count % 7 == 0 {
                break
            }
        }
        
        return days
    }
    
    private var entriesByDate: [String: EmotionEntry] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var entriesDict: [String: EmotionEntry] = [:]
        for entry in dataManager.entries {
            let dateKey = dateFormatter.string(from: entry.date)
            entriesDict[dateKey] = entry
        }
        return entriesDict
    }
    
    private var weekdayHeaders: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.shortWeekdaySymbols
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
                VStack(spacing: 0) {
                    HStack {
                        Text("Emotion Calendar")
                            .font(.poppinsBold(size: 24))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            Button(action: previousMonth) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(width: 40, height: 40)
                                    .background(AppColors.cardBackground)
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Text(monthYearString)
                                .font(.poppinsBold(size: 20))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Button(action: nextMonth) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(width: 40, height: 40)
                                    .background(AppColors.cardBackground)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 8) {
                            HStack(spacing: 0) {
                                ForEach(weekdayHeaders, id: \.self) { weekday in
                                    Text(weekday)
                                        .font(.poppinsMedium(size: 12))
                                        .foregroundColor(AppColors.secondaryText)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                                ForEach(daysInMonth, id: \.self) { date in
                                    CalendarDayView(
                                        date: date,
                                        currentMonth: currentMonth,
                                        entry: entryForDate(date),
                                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
                                    ) {
                                        selectedDate = date
                                        if let entry = entryForDate(date) {
                                            selectedEntry = entry
                                            showingEntryDetail = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        CalendarLegendView()
                        
                        if let entry = entryForDate(selectedDate) {
                            SelectedDateInfoView(entry: entry) {
                                selectedEntry = entry
                                showingEntryDetail = true
                            }
                        } else {
                            EmptyDateInfoView(date: selectedDate)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 70)
                }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(entry: entry, dataManager: dataManager)
        }
    }
    
    private func entryForDate(_ date: Date) -> EmotionEntry? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateKey = dateFormatter.string(from: date)
        return entriesByDate[dateKey]
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
    let currentMonth: Date
    let entry: EmotionEntry?
    let isSelected: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    private var dayNumber: String {
        String(calendar.component(.day, from: date))
    }
    
    private var isCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(backgroundColorForDay)
                        .frame(width: 36, height: 36)
                    
                    Text(dayNumber)
                        .font(.poppinsMedium(size: 14))
                        .foregroundColor(textColorForDay)
                    
                    if isToday && !isSelected {
                        Circle()
                            .stroke(AppColors.accentYellow, lineWidth: 2)
                            .frame(width: 36, height: 36)
                    }
                }
                
                if let entry = entry {
                    Image(systemName: entry.emotion.icon)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(emotionColor(for: entry.emotion))
                } else {
                    Spacer()
                        .frame(height: 12)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }
    
    private var backgroundColorForDay: Color {
        if isSelected {
            return AppColors.accentYellow
        } else if entry != nil {
            return AppColors.cardBackground
        } else {
            return Color.clear
        }
    }
    
    private var textColorForDay: Color {
        if isSelected {
            return AppColors.primaryBlue
        } else {
            return AppColors.primaryText
        }
    }
    
    private func emotionColor(for emotion: EmotionType) -> Color {
        switch emotion {
        case .joy: return AppColors.accentYellow
        case .calm: return AppColors.accentYellow
        case .tired: return AppColors.secondaryText
        case .angry: return AppColors.errorRed
        case .bored: return AppColors.primaryText.opacity(0.6)
        case .success: return AppColors.successGreen
        }
    }
}

struct CalendarLegendView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Legend")
                .font(.poppinsSemiBold(size: 16))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(EmotionType.allCases, id: \.self) { emotion in
                    HStack(spacing: 8) {
                        Image(systemName: emotion.icon)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(emotionColor(for: emotion))
                            .frame(width: 16)
                        
                        Text(emotion.title)
                            .font(.poppinsRegular(size: 12))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    private func emotionColor(for emotion: EmotionType) -> Color {
        switch emotion {
        case .joy: return AppColors.accentYellow
        case .calm: return AppColors.accentYellow
        case .tired: return AppColors.secondaryText
        case .angry: return AppColors.errorRed
        case .bored: return AppColors.primaryText.opacity(0.6)
        case .success: return AppColors.successGreen
        }
    }
}

struct SelectedDateInfoView: View {
    let entry: EmotionEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Entry for \(DateFormatter.displayFormatter.string(from: entry.date))")
                        .font(.poppinsSemiBold(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.primaryText.opacity(0.6))
                }
                
                HStack(spacing: 12) {
                    Image(systemName: entry.emotion.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.emotion.title)
                            .font(.poppinsMedium(size: 14))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(entry.reason)
                            .font(.poppinsRegular(size: 12))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

struct EmptyDateInfoView: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 8) {
            Text("No entry for \(DateFormatter.displayFormatter.string(from: date))")
                .font(.poppinsMedium(size: 14))
                .foregroundColor(AppColors.secondaryText)
            
            Text("Tap on a day with an emotion icon to view details")
                .font(.poppinsRegular(size: 12))
                .foregroundColor(AppColors.placeholderText)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}

#Preview {
    CalendarView(dataManager: EmotionDataManager())
}
