import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedDate: Date?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("History")
                        .font(.playfair(24, weight: .bold))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        CalendarView(
                            selectedDate: $selectedDate,
                            history: dataManager.history
                        )
                        
                        if let selectedDate = selectedDate,
                           let entry = dataManager.history.first(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
                            DayDetailCard(entry: entry)
                        }
                        
                        if !dataManager.history.isEmpty {
                            RecentActivityCard(history: Array(dataManager.history.prefix(7)))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date?
    let history: [HistoryEntry]
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    @State private var currentMonth = Date()
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(ColorTheme.accentColor)
                    }
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: currentMonth))
                        .font(.playfair(18, weight: .medium))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Spacer()
                    
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(ColorTheme.accentColor)
                    }
                }
                
                HStack {
                    ForEach(Array(["S", "M", "T", "W", "T", "F", "S"].enumerated()), id: \.offset) { item in
                        Text(item.element)
                            .font(.playfair(14, weight: .medium))
                            .foregroundColor(ColorTheme.secondaryColor)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(calendarDays, id: \.self) { date in
                        CalendarDayView(
                            date: date,
                            isSelected: selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!),
                            hasActivity: hasActivityForDate(date),
                            careLevel: careLevelForDate(date)
                        ) {
                            selectedDate = date
                        }
                    }
                }
            }
        }
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let monthEnd = monthInterval.end
        
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart
        
        var days: [Date] = []
        var currentDate = startOfWeek
        
        while currentDate < monthEnd {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    private func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    private func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    private func hasActivityForDate(_ date: Date) -> Bool {
        return history.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func careLevelForDate(_ date: Date) -> Double {
        return history.first { calendar.isDate($0.date, inSameDayAs: date) }?.careLevel ?? 0
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasActivity: Bool
    let careLevel: Double
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(
                        isSelected ? ColorTheme.accentColor :
                        hasActivity ? ColorTheme.accentColor.opacity(0.1) :
                        Color.clear
                    )
                    .frame(width: 36, height: 36)
                
                if hasActivity && !isSelected {
                    Circle()
                        .stroke(ColorTheme.accentColor.opacity(careLevel), lineWidth: 2)
                        .frame(width: 36, height: 36)
                }
                
                Text("\(calendar.component(.day, from: date))")
                    .font(.playfair(14, weight: .medium))
                    .foregroundColor(
                        isSelected ? .white :
                        calendar.isDate(date, equalTo: Date(), toGranularity: .month) ? ColorTheme.textColor :
                        ColorTheme.secondaryColor.opacity(0.5)
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DayDetailCard: View {
    let entry: HistoryEntry
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text(dateFormatter.string(from: entry.date))
                    .font(.playfair(18, weight: .medium))
                    .foregroundColor(ColorTheme.textColor)
                
                if !entry.wellnessStates.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Wellness Check")
                            .font(.playfair(16, weight: .medium))
                            .foregroundColor(ColorTheme.textColor)
                        
                        ForEach(Array(entry.wellnessStates.keys), id: \.self) { type in
                            HStack {
                                Text(type.rawValue)
                                    .font(.playfair(14))
                                    .foregroundColor(ColorTheme.secondaryColor)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    ForEach(1...5, id: \.self) { level in
                                        Circle()
                                            .fill(level <= (entry.wellnessStates[type] ?? 0) ? ColorTheme.accentColor : ColorTheme.secondaryColor.opacity(0.3))
                                            .frame(width: 12, height: 12)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if !entry.completedPractices.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Completed Practices")
                            .font(.playfair(16, weight: .medium))
                            .foregroundColor(ColorTheme.textColor)
                        
                        ForEach(Array(entry.completedPractices.enumerated()), id: \.offset) { item in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(ColorTheme.accentColor)
                                    .font(.system(size: 12))
                                
                                Text(item.element)
                                    .font(.playfair(14))
                                    .foregroundColor(ColorTheme.secondaryColor)
                            }
                        }
                    }
                }
                
                if !entry.completedChallenges.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Completed Challenges")
                            .font(.playfair(16, weight: .medium))
                            .foregroundColor(ColorTheme.textColor)
                        
                        ForEach(Array(entry.completedChallenges.enumerated()), id: \.offset) { item in
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(ColorTheme.accentColor)
                                    .font(.system(size: 12))
                                
                                Text(item.element)
                                    .font(.playfair(14))
                                    .foregroundColor(ColorTheme.secondaryColor)
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Care Level")
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Spacer()
                    
                    Text("\(Int(entry.careLevel * 100))%")
                        .font(.playfair(16, weight: .bold))
                        .foregroundColor(ColorTheme.accentColor)
                }
            }
        }
    }
}

struct RecentActivityCard: View {
    let history: [HistoryEntry]
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Activity")
                    .font(.playfair(18, weight: .medium))
                    .foregroundColor(ColorTheme.textColor)
                
                VStack(spacing: 12) {
                    ForEach(history) { entry in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(formatDate(entry.date))
                                    .font(.playfair(14, weight: .medium))
                                    .foregroundColor(ColorTheme.textColor)
                                
                                Text("\(entry.completedPractices.count + entry.completedChallenges.count) activities")
                                    .font(.playfair(12))
                                    .foregroundColor(ColorTheme.secondaryColor)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .stroke(ColorTheme.secondaryColor.opacity(0.3), lineWidth: 3)
                                    .frame(width: 24, height: 24)
                                
                                Circle()
                                    .trim(from: 0, to: entry.careLevel)
                                    .stroke(ColorTheme.accentColor, lineWidth: 3)
                                    .frame(width: 24, height: 24)
                                    .rotationEffect(.degrees(-90))
                            }
                        }
                        
                        if entry.id != history.last?.id {
                            Divider()
                                .background(ColorTheme.secondaryColor.opacity(0.3))
                        }
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
        .environmentObject(DataManager.shared)
}
