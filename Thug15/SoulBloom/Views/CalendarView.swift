import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var showingNewEntry = false
    @State private var showingDayDetails = false
    @State private var selectedDate = Date()
    @Binding var selectedTab: Int
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
            ZStack {
                LinearGradient.appBackground
                    .ignoresSafeArea()
                
                GridPatternView()
                    .opacity(0.1)
                
                VStack(spacing: 0) {
                    headerView
                    
                    calendarGridView
                        .padding(.horizontal, 15)
                        .padding(.bottom, 4)
                    
                    if viewModel.entries.isEmpty {
                        Spacer()
                        
                        emptyStateView
                        
                        Spacer()
                    } else {
                        contentBelowCalendar
                    }
                }
            }
        .sheet(isPresented: $showingNewEntry) {
                NewEntryView(viewModel: viewModel, selectedDate: selectedDate)
        }
        .sheet(isPresented: $showingDayDetails) {
                DayDetailsView(viewModel: viewModel, date: selectedDate)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Gratitude Diary")
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.top, 8)
            
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.previousMonth()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(ColorTheme.cardBackground)
                        )
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: viewModel.currentMonth))
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.nextMonth()
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(ColorTheme.cardBackground)
                        )
                }
            }
            .padding(.horizontal, 15)
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.goToToday()
                }
            } label: {
                Text("Today")
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.buttonText)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.buttonBackground)
                    )
            }

        }
        .padding(.top, 5)
        .padding(.bottom, 15)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(FontManager.caption2)
                        .foregroundColor(ColorTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 3)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isCurrentMonth: viewModel.isCurrentMonth(date),
                        isToday: viewModel.isToday(date),
                        hasEntry: viewModel.hasEntry(for: date)
                    )
                    .onTapGesture {
                        handleDayTap(date)
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(ColorTheme.cardBackground)
        )
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: viewModel.currentMonth) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let monthEnd = monthInterval.end
        
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart
        
        let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: calendar.date(byAdding: .day, value: -1, to: monthEnd) ?? monthEnd)?.end ?? monthEnd
        
        var dates: [Date] = []
        var currentDate = startOfWeek
        
        while currentDate < endOfWeek {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Image(systemName: "calendar")
                .font(.system(size: 40))
                .foregroundColor(ColorTheme.accentYellow)
            
            Text("Start your gratitude journey — mark today")
                .font(FontManager.callout)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            Button {
                selectedDate = Date()
                showingNewEntry = true
            } label: {
                Text("Add Entry")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.buttonText)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.buttonBackground)
                    )
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
    }
    
    private var contentBelowCalendar: some View {
        ScrollView {
            VStack(spacing: 20) {
                quickStatsSection
                
                recentEntriesSection
                
                motivationalSection
                
                quickActionsSection
            }
            .padding(.horizontal, 15)
            .padding(.top, 20)
            .padding(.bottom, 80)
        }
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Progress")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            HStack(spacing: 12) {
                QuickStatCard(
                    title: "Total Days",
                    value: "\(viewModel.totalDaysWithEntries)",
                    icon: "calendar.badge.checkmark",
                    color: ColorTheme.accentOrange
                )
                
                QuickStatCard(
                    title: "Current Streak",
                    value: "\(viewModel.currentStreak)",
                    icon: "flame.fill",
                    color: ColorTheme.warningRed
                )
                
                QuickStatCard(
                    title: "Max Streak",
                    value: "\(viewModel.maxStreak)",
                    icon: "trophy.fill",
                    color: ColorTheme.accentYellow
                )
            }
        }
    }
    
    private var recentEntriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Entries")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Button("View All") {
                    selectedTab = 1
                }
                .font(FontManager.caption)
                .foregroundColor(ColorTheme.accentYellow)
            }
            
            VStack(spacing: 8) {
                ForEach(Array(viewModel.entries.prefix(3))) { entry in
                    RecentEntryRow(entry: entry)
                        .onTapGesture {
                            selectedDate = entry.date
                            showingDayDetails = true
                        }
                }
            }
        }
    }
    
    private var motivationalSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(ColorTheme.warningRed)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(motivationalMessage.title)
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.primaryText)
                        .fontWeight(.medium)
                    
                    Text(motivationalMessage.subtitle)
                        .font(FontManager.caption)
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardBackground)
            )
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: viewModel.hasEntry(for: Date()) ? "View Today" : "Add Today",
                    icon: viewModel.hasEntry(for: Date()) ? "eye.fill" : "plus.circle.fill",
                    color: viewModel.hasEntry(for: Date()) ? ColorTheme.accentOrange : ColorTheme.successGreen
                ) {
                    selectedDate = Date()
                    if viewModel.hasEntry(for: Date()) {
                        showingDayDetails = true
                    } else {
                        showingNewEntry = true
                    }
                }
                
                QuickActionButton(
                    title: "View Stats",
                    icon: "chart.bar.fill",
                    color: ColorTheme.accentOrange
                ) {
                    selectedTab = 2
                }
            }
        }
    }
    
    private var motivationalMessage: (title: String, subtitle: String) {
        let streak = viewModel.currentStreak
        let totalDays = viewModel.totalDaysWithEntries
        
        if streak >= 7 {
            return ("Amazing streak! 🔥", "You've been practicing gratitude for \(streak) days in a row!")
        } else if totalDays >= 30 {
            return ("Great progress! 🌟", "You've made \(totalDays) gratitude entries so far!")
        } else if totalDays >= 7 {
            return ("Keep it up! 💪", "You're building a wonderful habit!")
        } else {
            return ("Great start! 🌱", "Every entry brings you closer to mindfulness!")
        }
    }
    
    private func handleDayTap(_ date: Date) {
        selectedDate = date
        
        if viewModel.hasEntry(for: date) {
            showingDayDetails = true
        } else {
            showingNewEntry = true
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
    let hasEntry: Bool
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(backgroundColor)
                .frame(height: 32)
            
            if isToday {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(ColorTheme.calendarToday, lineWidth: 1.5)
            }
            
            VStack(spacing: 1) {
                Text(dayNumber)
                    .font(FontManager.caption)
                    .foregroundColor(textColor)
                
                if hasEntry {
                    Circle()
                        .fill(ColorTheme.calendarWithEntry)
                        .frame(width: 4, height: 4)
                }
            }
        }
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }
    
    private var backgroundColor: Color {
        if hasEntry {
            return ColorTheme.calendarWithEntry.opacity(0.2)
        } else if isToday {
            return ColorTheme.calendarToday.opacity(0.2)
        } else {
            return ColorTheme.calendarEmpty
        }
    }
    
    private var textColor: Color {
        if hasEntry || isToday {
            return ColorTheme.primaryText
        } else {
            return ColorTheme.secondaryText
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(FontManager.caption2)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(ColorTheme.cardBackground)
        )
    }
}

struct RecentEntryRow: View {
    let entry: GratitudeEntry
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 2) {
                Text(entry.date.dayOfMonth)
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.primaryText)
                    .fontWeight(.medium)
                
                Text(entry.date.monthAbbreviation)
                    .font(FontManager.caption2)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.firstGratitude)
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                HStack {
                    Circle()
                        .fill(ColorTheme.accentOrange)
                        .frame(width: 4, height: 4)
                    
                    Circle()
                        .fill(ColorTheme.accentYellow)
                        .frame(width: 4, height: 4)
                    
                    Circle()
                        .fill(ColorTheme.successGreen)
                        .frame(width: 4, height: 4)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(ColorTheme.cardBackground)
        )
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(title)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.primaryText)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(ColorTheme.cardBackground)
            )
        }
    }
}

extension Date {
    var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    var monthAbbreviation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: self)
    }
}

#Preview {
    CalendarView(viewModel: GratitudeViewModel(), selectedTab: .constant(0))
}
