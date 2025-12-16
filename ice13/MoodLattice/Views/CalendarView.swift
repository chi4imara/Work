import SwiftUI

struct CalendarView: View {
    @ObservedObject var dataManager: MoodDataManager
    @State private var selectedDate = Date()
    @State private var sheetItem: SheetItem?
    @State private var showingMenu = false
    @State private var showingClearConfirmation = false
    
    private let calendar = Calendar.current
    
    @Binding var selectedTab: Int
    
    enum SheetItem: Identifiable {
        case moodEntry(date: Date, entry: MoodEntry?)
        case moodDetails(date: Date)
        
        var id: String {
            switch self {
            case .moodEntry(let date, let entry):
                return "moodEntry_\(date.timeIntervalSince1970)_\(entry?.id.uuidString ?? "new")"
            case .moodDetails(let date):
                return "moodDetails_\(date.timeIntervalSince1970)"
            }
        }
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack {
                HStack {
                    Text("Calendar")
                        .font(FontManager.ubuntu(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerView
                        
                        calendarGridView
                        
                        todaySectionView
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .moodEntry(let date, let entry):
                MoodEntryView(
                    dataManager: dataManager,
                    selectedDate: date,
                    entryToEdit: entry
                )
            case .moodDetails(let date):
                MoodDetailsView(
                    dataManager: dataManager,
                    entryDate: date
                )
            }
        }
        .actionSheet(isPresented: $showingClearConfirmation) {
            ActionSheet(
                title: Text("Clear Month"),
                message: Text("Delete all entries for \(monthYearString(selectedDate))?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        dataManager.deleteEntriesForMonth(selectedDate)
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 44, height: 44)
                    .background(AppColors.cardBackground)
                    .clipShape(Circle())
                    .shadow(color: AppColors.shadowColor, radius: 5)
            }
            
            Spacer()
            
            Text(monthYearString(selectedDate))
                .font(FontManager.ubuntu(size: 24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 44, height: 44)
                    .background(AppColors.cardBackground)
                    .clipShape(Circle())
                    .shadow(color: AppColors.shadowColor, radius: 5)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 15) {
            HStack {
                ForEach(weekdayHeaders, id: \.self) { weekday in
                    Text(weekday)
                        .font(FontManager.ubuntu(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isToday: calendar.isDateInToday(date),
                        isCurrentMonth: calendar.isDate(date, equalTo: selectedDate, toGranularity: .month),
                        entry: dataManager.entryForDate(date)
                    ) {
                        dayTapped(date)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 10)
        )
    }
    
    private var todaySectionView: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Today")
                    .font(FontManager.ubuntu(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Menu {
                    Button("History") {
                        withAnimation {
                            selectedTab = 2
                        }
                    }
                    Button("Statistics") {
                        withAnimation {
                            selectedTab = 3
                        }
                    }
                    Button("Clear Month...") {
                        showingClearConfirmation = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 32, height: 32)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                }
            }
            
            if let todayEntry = dataManager.entryForDate(Date()) {
                HStack(spacing: 15) {
                    Text(todayEntry.mood.rawValue)
                        .font(.system(size: 40))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(todayEntry.dateString)
                            .font(FontManager.ubuntu(size: 14, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(todayEntry.shortNote)
                            .font(FontManager.ubuntu(size: 16, weight: .regular))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Button {
                        sheetItem = .moodDetails(date: todayEntry.date)
                    } label: {
                        Text("Open")
                            .font(FontManager.ubuntu(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(AppColors.accent)
                            .cornerRadius(20)
                    }
                }
            } else {
                VStack(spacing: 15) {
                    Text("Today's mood not yet marked")
                        .font(FontManager.ubuntu(size: 16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        selectedDate = Date()
                        sheetItem = .moodEntry(date: Date(), entry: nil)
                    } label: {
                        Text("Choose Mood")
                            .font(FontManager.ubuntu(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.accent)
                            .cornerRadius(25)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 10)
        )
        .padding(.top, 20)
    }
    
    private var weekdayHeaders: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.shortWeekdaySymbols.map { String($0.prefix(3)) }
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            return []
        }
        
        let monthFirstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let daysToSubtract = (monthFirstWeekday + 5) % 7 
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: monthInterval.start) else {
            return []
        }
        
        var days: [Date] = []
        for i in 0..<42 {
            if let day = calendar.date(byAdding: .day, value: i, to: startDate) {
                days.append(day)
            }
        }
        
        return days
    }
    
    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
        }
    }
    
    private func dayTapped(_ date: Date) {
        selectedDate = date
        
        if let existingEntry = dataManager.entryForDate(date) {
            sheetItem = .moodDetails(date: existingEntry.date)
        } else {
            sheetItem = .moodEntry(date: date, entry: nil)
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isToday: Bool
    let isCurrentMonth: Bool
    let entry: MoodEntry?
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(FontManager.ubuntu(size: 16, weight: isToday ? .bold : .regular))
                    .foregroundColor(textColor)
                
                if let entry = entry {
                    Text(entry.mood.rawValue)
                        .font(.system(size: 16))
                }
            }
            .frame(width: 40, height: 50)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: isToday ? 2 : 0)
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return AppColors.secondaryText.opacity(0.5)
        }
        return isToday ? AppColors.accent : AppColors.primaryText
    }
    
    private var backgroundColor: Color {
        if entry != nil {
            return AppColors.accent.opacity(0.1)
        }
        return Color.clear
    }
    
    private var borderColor: Color {
        return isToday ? AppColors.accent : Color.clear
    }
}
