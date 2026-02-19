import SwiftUI

struct SelectableDate: Identifiable {
    let id = UUID()
    let date: Date
}

struct HistoryView: View {
    @EnvironmentObject var store: AppDataStore
    @State private var selectedDate: SelectableDate?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("History")
                        .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        StatsOverviewSection(store: store)
                        
                        CalendarSection(
                            entries: store.allEntriesForHistory(),
                            onDateSelected: { date in
                                selectedDate = SelectableDate(date: date)
                            }
                        )
                        
                        RecentEntriesSection(entries: store.allEntriesForHistory())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .id(store.dataVersion)
            }
        }
        .sheet(item: $selectedDate) { selectable in
            DateDetailSheet(date: selectable.date, entry: store.entry(for: selectable.date))
        }
    }
}

struct StatsOverviewSection: View {
    let store: AppDataStore
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Progress")
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                Spacer()
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Current Streak",
                    value: "\(store.streakCount())",
                    subtitle: "days",
                    color: AppColors.secondary
                )
                
                StatCard(
                    title: "This Week",
                    value: "\(Int(store.completionRate(period: .week) * 100))",
                    subtitle: "% complete",
                    color: AppColors.success
                )
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(FontManager.playfairDisplay(size: 14))
                .foregroundColor(AppColors.text.opacity(0.6))
                .multilineTextAlignment(.center)
            
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(color)
                
                Text(subtitle)
                    .font(FontManager.playfairDisplay(size: 12))
                    .foregroundColor(AppColors.text.opacity(0.6))
                    .offset(y: -2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct CalendarSection: View {
    let entries: [DailyEntry]
    let onDateSelected: (Date) -> Void
    
    @State private var currentMonth = Date()
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                        .foregroundColor(AppColors.text.opacity(0.6))
                        .frame(height: 30)
                }
                
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        entry: entryForDate(date),
                        onTap: { onDateSelected(date) }
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end - 1) else {
            return []
        }
        
        var days: [Date] = []
        var date = monthFirstWeek.start
        
        while date < monthLastWeek.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        return days
    }
    
    private func entryForDate(_ date: Date) -> DailyEntry? {
        entries.first { calendar.isDate($0.date, inSameDayAs: date) }
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
    let isCurrentMonth: Bool
    let entry: DailyEntry?
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(FontManager.playfairDisplay(size: 16, weight: isToday ? .semibold : .medium))
                    .foregroundColor(textColor)
                
                Circle()
                    .fill(indicatorColor)
                    .frame(width: 6, height: 6)
                    .opacity(entry != nil ? 1.0 : 0.0)
            }
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .fill(backgroundColor)
                    .opacity(isToday ? 1.0 : 0.0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return AppColors.text.opacity(0.3)
        } else if isToday {
            return .white
        } else {
            return AppColors.text
        }
    }
    
    private var backgroundColor: Color {
        isToday ? AppColors.primary : .clear
    }
    
    private var indicatorColor: Color {
        guard let entry = entry else { return .clear }
        
        if entry.isComplete {
            return AppColors.success
        } else if entry.mood != nil {
            return AppColors.secondary
        } else {
            return AppColors.text.opacity(0.4)
        }
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
}

struct RecentEntriesSection: View {
    let entries: [DailyEntry]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Entries")
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                Spacer()
            }
            
            if entries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primary.opacity(0.5))
                    
                    Text("No entries yet")
                        .font(FontManager.playfairDisplay(size: 16))
                        .foregroundColor(AppColors.text.opacity(0.6))
                }
                .padding(.vertical, 20)
            } else {
                ForEach(entries.prefix(5)) { entry in
                    EntryRowView(entry: entry)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct EntryRowView: View {
    let entry: DailyEntry
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateFormatter.string(from: entry.date))
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                if let mood = entry.mood {
                    HStack(spacing: 6) {
                        Text(mood.emoji)
                            .font(.system(size: 16))
                        Text(mood.name)
                            .font(FontManager.playfairDisplay(size: 14))
                            .foregroundColor(AppColors.text.opacity(0.6))
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: entry.isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16))
                    .foregroundColor(entry.isComplete ? AppColors.success : AppColors.text.opacity(0.4))
                
                Text(entry.isComplete ? "Complete" : "Partial")
                    .font(FontManager.playfairDisplay(size: 14))
                    .foregroundColor(entry.isComplete ? AppColors.success : AppColors.text.opacity(0.6))
            }
        }
        .padding(.vertical, 8)
    }
}

struct DateDetailSheet: View {
    let date: Date
    let entry: DailyEntry?
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Text(dateFormatter.string(from: date))
                            .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                            .foregroundColor(AppColors.text)
                            .padding(.top, 20)
                        
                        if let entry = entry {
                            if let mood = entry.mood {
                                VStack(spacing: 16) {
                                    Text("Mood")
                                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                        .foregroundColor(AppColors.text)
                                    
                                    VStack(spacing: 12) {
                                        Text(mood.emoji)
                                            .font(.system(size: 60))
                                        
                                        Text(mood.name)
                                            .font(FontManager.playfairDisplay(size: 20, weight: .medium))
                                            .foregroundColor(AppColors.text)
                                    }
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.cardGradient)
                                .cornerRadius(16)
                            }
                            
                            if !entry.note.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Note")
                                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                        .foregroundColor(AppColors.text)
                                    
                                    Text(entry.note)
                                        .font(FontManager.playfairDisplay(size: 16))
                                        .foregroundColor(AppColors.text.opacity(0.7))
                                        .lineSpacing(2)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(AppColors.cardGradient)
                                .cornerRadius(16)
                            }
                            
                            VStack(spacing: 12) {
                                Text("Completion")
                                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.text)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: entry.isComplete ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(entry.isComplete ? AppColors.success : AppColors.text.opacity(0.4))
                                    
                                    Text(entry.isComplete ? "Complete" : "Partial")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                                        .foregroundColor(entry.isComplete ? AppColors.success : AppColors.text.opacity(0.6))
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppColors.cardGradient)
                            .cornerRadius(16)
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 60))
                                    .foregroundColor(AppColors.primary.opacity(0.5))
                                
                                Text("No entry for this date")
                                    .font(FontManager.playfairDisplay(size: 18, weight: .medium))
                                    .foregroundColor(AppColors.text.opacity(0.6))
                            }
                            .padding(.vertical, 40)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Entry Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(AppDataStore())
}
