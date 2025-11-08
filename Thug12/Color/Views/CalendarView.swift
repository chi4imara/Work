import SwiftUI

struct CalendarView: View {
    @ObservedObject var weatherData: WeatherDataManager
    @ObservedObject var appState: AppStateManager
    @State private var currentMonth = Date()
    @State private var animateCalendar = false
    @State private var refreshTrigger = 0
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                calendarGridView
                    .scaleEffect(animateCalendar ? 1.0 : 0.9)
                    .opacity(animateCalendar ? 1.0 : 0.0)
                
                ScrollView {
                if weatherData.weatherEntries.isEmpty {
                    emptyStateView
                } else {
                        VStack(spacing: 24) {
                            quickActionsView
                                .opacity(animateCalendar ? 1 : 0)
                                .offset(y: animateCalendar ? 0 : 20)
                                .animation(.easeOut(duration: 0.8).delay(0.3), value: animateCalendar)
                            
                            monthlyStatsView
                                .opacity(animateCalendar ? 1 : 0)
                                .offset(y: animateCalendar ? 0 : 20)
                                .animation(.easeOut(duration: 0.8).delay(0.5), value: animateCalendar)
                            
                            recentEntriesView
                                .opacity(animateCalendar ? 1 : 0)
                                .offset(y: animateCalendar ? 0 : 20)
                                .animation(.easeOut(duration: 0.8).delay(0.7), value: animateCalendar)
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                animateCalendar = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("WeatherDataUpdated"))) { _ in
            refreshTrigger += 1
        }
        .onChange(of: currentMonth) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
            }
        }
        .sheet(isPresented: $appState.showingColorPicker) {
            ColorPickerView(
                weatherData: weatherData,
                appState: appState,
                selectedDate: appState.selectedDate
            )
        }
        .onChange(of: weatherData.weatherEntries.count) { _ in
            refreshTrigger += 1
            withAnimation(.easeInOut(duration: 0.3)) {
            }
        }
        .sheet(isPresented: $appState.showingDayDetails) {
            DayDetailsView(
                weatherData: weatherData,
                appState: appState,
                selectedDate: appState.selectedDate
            )
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("Weather in Colors")
                    .font(Font.poppinsBold(size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut) {
                        currentMonth = Date()
                    }
                } label: {
                    Text("Today")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryOrange)
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .background(AppColors.cardGradient)
                        .cornerRadius(AppCornerRadius.small)
                }
            }
            
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryOrange)
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(Font.poppinsMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryOrange)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: AppSpacing.sm) {
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        currentMonth: currentMonth,
                        weatherData: weatherData,
                        appState: appState,
                        refreshTrigger: refreshTrigger
                    )
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .padding(.vertical, AppSpacing.lg)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "paintbrush.fill")
                .font(.system(size: 40))
                .foregroundColor(AppColors.primaryOrange)
            
            VStack(spacing: AppSpacing.sm) {
                Text("Start marking days with colors")
                    .font(Font.poppinsMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Choose colors that reflect the weather")
                    .font(Font.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button("Mark Today") {
                appState.showColorPicker(for: Date())
            }
            .font(AppFonts.button)
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, AppSpacing.xl)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.primaryOrange)
            .cornerRadius(AppCornerRadius.medium)
        }
        .padding(.horizontal, AppSpacing.lg)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let daysToSubtract = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstOfMonth) else { return [] }
        
        var dates: [Date] = []
        var currentDate = startDate
        
        for _ in 0..<42 { 
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let currentMonth: Date
    let weatherData: WeatherDataManager
    let appState: AppStateManager
    let refreshTrigger: Int
    
    private let calendar = Calendar.current
    
    private var isInCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    private var dayNumber: String {
        String(calendar.component(.day, from: date))
    }
    
    private var weatherEntry: WeatherEntry? {
        weatherData.getEntry(for: date)
    }
    
    var body: some View {
        Button(action: {
            if weatherEntry != nil {
                appState.showDayDetails(for: date)
            } else {
                appState.showColorPicker(for: date)
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: AppCornerRadius.small)
                    .fill(backgroundcolor)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                            .stroke(isToday ? AppColors.primaryOrange : Color.clear, lineWidth: 2)
                    )
                    .animation(.easeInOut(duration: 0.3), value: backgroundcolor)
                
                Text(dayNumber)
                    .font(AppFonts.callout)
                    .foregroundColor(textColor)
                    .fontWeight(isToday ? .bold : .regular)
                    .animation(.easeInOut(duration: 0.3), value: textColor)
            }
        }
        .frame(height: 32)
        .disabled(!isInCurrentMonth)
        .scaleEffect(isInCurrentMonth ? 1.0 : 0.8)
        .opacity(isInCurrentMonth ? 1.0 : 0.3)
        .animation(.easeInOut(duration: 0.3), value: refreshTrigger)
    }
    
    private var backgroundcolor: Color {
        if let entry = weatherEntry {
            return entry.weatherColor.swiftUIColor
        } else {
            return Color.white.opacity(0.1)
        }
    }
    
    private var textColor: Color {
        if weatherEntry != nil {
            return AppColors.primaryText
        } else {
            return isInCurrentMonth ? AppColors.primaryText : AppColors.secondaryText
        }
    }
}

extension CalendarView {
    private var quickActionsView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Actions")
                    .font(Font.poppinsMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "Today",
                    icon: "calendar.badge.plus",
                    color: AppColors.primaryOrange
                ) {
                    appState.showColorPicker(for: Date())
                }
                
                QuickActionButton(
                    title: "Yesterday",
                    icon: "calendar.badge.minus",
                    color: AppColors.accentYellow
                ) {
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                    appState.showColorPicker(for: yesterday)
                }
                
                QuickActionButton(
                    title: "Tomorrow",
                    icon: "calendar.badge.clock",
                    color: AppColors.success
                ) {
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                    appState.showColorPicker(for: tomorrow)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.cardGradient)
        .cornerRadius(AppCornerRadius.large)
    }
    
    private var monthlyStatsView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Monthly Statistics")
                    .font(Font.poppinsMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            let monthlyEntries = getMonthlyEntries()
            let colorDistribution = getMonthlyColorDistribution()
            
            if !monthlyEntries.isEmpty {
                HStack(spacing: 16) {
                    MonthlyStatCard(
                        title: "Days Marked",
                        value: "\(monthlyEntries.count)",
                        icon: "calendar",
                        color: AppColors.primaryOrange
                    )
                    
                    MonthlyStatCard(
                        title: "Colors Used",
                        value: "\(colorDistribution.count)",
                        icon: "paintpalette",
                        color: AppColors.accentYellow
                    )
                    
                    MonthlyStatCard(
                        title: "Most Used",
                        value: getMostUsedColor(),
                        icon: "star",
                        color: AppColors.success
                    )
                }
            } else {
                Text("No entries in this month yet")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.lg)
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.cardGradient)
        .cornerRadius(AppCornerRadius.large)
    }
    
    private var recentEntriesView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Entries")
                    .font(Font.poppinsMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            let recentEntries = Array(weatherData.weatherEntries.prefix(5))
            
            if !recentEntries.isEmpty {
                VStack(spacing: 12) {
                    ForEach(recentEntries, id: \.id) { entry in
                        RecentEntryRow(entry: entry, appState: appState)
                    }
                }
            } else {
                Text("No entries yet")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.lg)
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.cardGradient)
        .cornerRadius(AppCornerRadius.large)
    }
    
    private func getMonthlyEntries() -> [WeatherEntry] {
        let calendar = Calendar.current
        return weatherData.weatherEntries.filter { entry in
            calendar.isDate(entry.date, equalTo: currentMonth, toGranularity: .month)
        }
    }
    
    private func getMonthlyColorDistribution() -> [String: Int] {
        let monthlyEntries = getMonthlyEntries()
        var distribution: [String: Int] = [:]
        
        for entry in monthlyEntries {
            let colorName = entry.weatherColor.displayName
            distribution[colorName, default: 0] += 1
        }
        
        return distribution
    }
    
    private func getMostUsedColor() -> String {
        let distribution = getMonthlyColorDistribution()
        return distribution.max(by: { $0.value < $1.value })?.key ?? "—"
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(Font.poppinsRegular(size: 10))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(color.opacity(0.1))
            .cornerRadius(AppCornerRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MonthlyStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            
            Text(value)
                .font(Font.poppinsMedium(size: 14))
                .foregroundColor(AppColors.primaryText)
                .fontWeight(.bold)
            
            Text(title)
                .font(Font.poppinsRegular(size: 9))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(color.opacity(0.1))
        .cornerRadius(AppCornerRadius.medium)
    }
}

struct RecentEntryRow: View {
    let entry: WeatherEntry
    let appState: AppStateManager
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
    
    var body: some View {
        Button(action: {
            appState.showDayDetails(for: entry.date)
        }) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(entry.weatherColor.swiftUIColor)
                    .frame(width: 16, height: 16)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.weatherColor.displayName)
                        .font(Font.poppinsMedium(size: 12))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(dateFormatter.string(from: entry.date))
                        .font(Font.poppinsRegular(size: 10))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.vertical, AppSpacing.sm)
        }
    }
}

#Preview {
    CalendarView(weatherData: WeatherDataManager(), appState: AppStateManager())
}
