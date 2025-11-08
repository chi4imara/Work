import SwiftUI

enum SheetType: Identifiable {
    case colorSelection(Date)
    case dayDetails(Date)
    
    var id: String {
        switch self {
        case .colorSelection(let date):
            return "colorSelection_\(date.timeIntervalSince1970)"
        case .dayDetails(let date):
            return "dayDetails_\(date.timeIntervalSince1970)"
        }
    }
}

struct CalendarView: View {
    @StateObject private var dataManager = MoodDataManager.shared
    @State private var currentDate = Date()
    @State private var showMenu = false
    @State private var showClearAlert = false
    @State private var animateContent = false
    @State private var showFloatingButton = false
    @State private var scrollOffset: CGFloat = 0
    @State private var highlightedDate: Date?
    @State private var showMoodSavedAnimation = false
    @State private var savedMoodDate: Date?
    @State private var presentedSheet: SheetType?
    
    var onNavigateToAnalytics: (() -> Void)?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var currentMonthEntries: [MoodEntry] {
        dataManager.getEntriesForMonth(currentDate)
    }
    
    private var currentStreak: Int {
        dataManager.getCurrentStreak()
    }
    
    private var monthStats: (totalDays: Int, moodDays: Int, favoriteDays: Int) {
        let moodDays = currentMonthEntries.count
        let favoriteDays = currentMonthEntries.filter { $0.isFavorite }.count
        let totalDays = calendar.range(of: .day, in: .month, for: currentDate)?.count ?? 0
        return (totalDays, moodDays, favoriteDays)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section {
                            VStack(spacing: 0) {
                                modernHeaderView
                                
                                quickStatsView
                                
                                monthNavigationView
                            }
                        } header: {
                            Color.clear.frame(height: 0)
                        }
                        
                        Section {
                            if dataManager.moodEntries.isEmpty {
                                modernEmptyStateView
                            } else {
                                modernCalendarGridView
                            }
                        }
                        
                        if !currentMonthEntries.isEmpty {
                            Section {
                                moodInsightsView
                            }
                        }
                        
                        if !currentMonthEntries.isEmpty {
                            Section {
                                modernColorDistributionView
                            }
                        }
                        
                        Color.clear.frame(height: 120)
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showFloatingButton = value > 200
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    floatingActionButton
                        .padding(.trailing, 20)
                        .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: $presentedSheet) { sheetType in
            switch sheetType {
            case .colorSelection(let date):
                ColorSelectionView(selectedDate: date, isPresented: .constant(false))
                    .onDisappear {
                        if dataManager.getEntry(for: date) != nil {
                            showMoodSavedAnimation(date)
                        }
                    }
            case .dayDetails(let date):
                DayDetailsView(selectedDate: date, isPresented: .constant(false))
            }
        }
        .actionSheet(isPresented: $showMenu) {
            ActionSheet(
                title: Text("Calendar Menu"),
                message: Text("Choose an action"),
                buttons: [
                    .default(Text("Add Mood for Today")) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        presentedSheet = .colorSelection(Date())
                    },
                    .default(Text("View Analytics")) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        
                        onNavigateToAnalytics?()
                    },
                    .destructive(Text("Clear Month")) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()
                        
                        showClearAlert = true
                    },
                    .cancel(Text("Cancel"))
                ]
            )
        }
        .alert("Clear Month", isPresented: $showClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                dataManager.clearMonth(for: currentDate)
            }
        } message: {
            Text("Are you sure you want to clear all mood entries for this month? This action cannot be undone.")
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                animateContent = true
            }
        }
    }
    
    private var modernHeaderView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Mood Calendar")
                        .font(AppTheme.Fonts.largeTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : -20)
                    
                    if currentStreak > 0 {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(AppTheme.Colors.accentYellow)
                                .font(.system(size: 16))
                            
                            Text("\(currentStreak) day streak")
                                .font(AppTheme.Fonts.callout)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(AppTheme.Colors.accentYellow.opacity(0.2))
                        )
                        .opacity(animateContent ? 1 : 0)
                        .offset(x: animateContent ? 0 : -20)
                    }
                }
                
                Spacer()
                
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                
                showMenu = true 
            }) {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 40, height: 40)
                    )
            }
                .opacity(animateContent ? 1 : 0)
                .offset(x: animateContent ? 0 : 20)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private var quickStatsView: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ModernStatCard(
                title: "This Month",
                value: "\(monthStats.moodDays)",
                subtitle: "mood days",
                icon: "paintpalette.fill",
                color: AppTheme.Colors.accentYellow,
                delay: 0.1
            )
            
            ModernStatCard(
                title: "Streak",
                value: "\(currentStreak)",
                subtitle: "days",
                icon: "flame.fill",
                color: .orange,
                delay: 0.2
            )
            
            ModernStatCard(
                title: "Total",
                value: "\(dataManager.moodEntries.count)",
                subtitle: "entries",
                icon: "chart.bar.fill",
                color: AppTheme.Colors.primaryBlue,
                delay: 0.3
            )
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private var monthNavigationView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 40, height: 40)
                    )
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentDate))
                .font(AppTheme.Fonts.title2)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                )
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 40, height: 40)
                    )
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private var modernCalendarGridView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack(spacing: 0) {
                ForEach(Array(["S", "M", "T", "W", "T", "F", "S"].enumerated()), id: \.offset) { index, day in
                    Text(day)
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    Button(action: {
                        handleDateTap(date)
                    }) {
                        ModernCalendarDayView(
                            date: date,
                            moodEntry: dataManager.getEntry(for: date),
                            isToday: calendar.isDateInToday(date),
                            isCurrentMonth: calendar.isDate(date, equalTo: currentDate, toGranularity: .month),
                            isHighlighted: highlightedDate == date,
                            showSavedAnimation: showMoodSavedAnimation && savedMoodDate == date
                        )
                    }
                    .buttonStyle(CalendarDayButtonStyle())
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                handleDateLongPress(date)
                            }
                    )
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            VStack(spacing: AppTheme.Spacing.xs) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Text("Tap any date to add mood color")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "hand.point.up.left.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    
                    Text("Long press for mood details")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
            }
            .padding(.top, AppTheme.Spacing.sm)
        }
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private var modernEmptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.accentYellow.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .animation(.easeOut(duration: 0.8).delay(0.5), value: animateContent)
                
                Image(systemName: "paintpalette")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppTheme.Colors.accentYellow)
                    .scaleEffect(animateContent ? 1.0 : 0.5)
                    .animation(.easeOut(duration: 0.8).delay(0.7), value: animateContent)
            }
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text("Start Your Mood Journey")
                    .font(AppTheme.Fonts.title2)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                
                Text("Track your daily emotions and discover patterns in your mood over time")
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
            }
            
            Button(action: {
                presentedSheet = .colorSelection(Date())
            }) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    Text("Add Your First Mood")
                        .font(AppTheme.Fonts.buttonFont)
                }
                .foregroundColor(AppTheme.Colors.backgroundBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [AppTheme.Colors.accentYellow, AppTheme.Colors.accentYellow.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(AppTheme.CornerRadius.large)
                .shadow(color: AppTheme.Colors.accentYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .scaleEffect(animateContent ? 1.0 : 0.9)
            .opacity(animateContent ? 1 : 0)
            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
        }
        .padding(.top, AppTheme.Spacing.xxl)
    }
    
    private var moodInsightsView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Mood Insights")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            VStack(spacing: AppTheme.Spacing.md) {
                if currentStreak > 0 {
                    InsightCard(
                        icon: "flame.fill",
                        title: "Great Streak!",
                        description: "You've tracked your mood for \(currentStreak) days in a row",
                        color: .orange
                    )
                }
                
                if let mostCommon = dataManager.getColorDistribution().first {
                    InsightCard(
                        icon: "star.fill",
                        title: "Most Common Mood",
                        description: "\(mostCommon.0.displayName) appears \(mostCommon.1) times this month",
                        color: mostCommon.0.color
                    )
                }
                
                if monthStats.favoriteDays > 0 {
                    InsightCard(
                        icon: "heart.fill",
                        title: "Special Days",
                        description: "You've marked \(monthStats.favoriteDays) days as favorites",
                        color: .pink
                    )
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
        }
        .padding(.top, AppTheme.Spacing.xl)
    }
    
    private var modernColorDistributionView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Mood Distribution")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            let colorDistribution = dataManager.getColorDistribution()
            
            if !colorDistribution.isEmpty {
                VStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(Array(colorDistribution.prefix(4).enumerated()), id: \.offset) { index, item in
                        let (moodColor, count) = item
                        let percentage = currentMonthEntries.isEmpty ? 0 : (count * 100) / currentMonthEntries.count
                        
                        ModernDistributionRow(
                            moodColor: moodColor,
                            count: count,
                            percentage: percentage,
                            delay: Double(index) * 0.1
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
    }
    
    private var floatingActionButton: some View {
        Button(action: {
            presentedSheet = .colorSelection(Date())
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppTheme.Colors.backgroundBlue)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(AppTheme.Colors.accentYellow)
                        .shadow(color: AppTheme.Colors.accentYellow.opacity(0.4), radius: 8, x: 0, y: 4)
                )
        }
        .scaleEffect(showFloatingButton ? 1.0 : 0.0)
        .opacity(showFloatingButton ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showFloatingButton)
    }
    
    private func getDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let daysToSubtract = firstWeekday - 1
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstOfMonth) else {
            return []
        }
        
        var days: [Date] = []
        var currentDate = startDate
        
        for _ in 0..<42 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        }
    }
    
    private func handleDateTap(_ date: Date) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.1)) {
            highlightedDate = date
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                highlightedDate = nil
            }
        }
        
        presentedSheet = .colorSelection(date)
    }
    
    private func handleDateLongPress(_ date: Date) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.2)) {
            highlightedDate = date
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                highlightedDate = nil
            }
        }
        
        presentedSheet = .dayDetails(date)
    }
    
    private func showMoodSavedAnimation(_ date: Date) {
        savedMoodDate = date
        showMoodSavedAnimation = true
        
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                showMoodSavedAnimation = false
                savedMoodDate = nil
            }
        }
    }
}

struct ModernCalendarDayView: View {
    let date: Date
    let moodEntry: MoodEntry?
    let isToday: Bool
    let isCurrentMonth: Bool
    let isHighlighted: Bool
    let showSavedAnimation: Bool
    
    @State private var savedAnimationScale: CGFloat = 1.0
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: isToday ? 2 : 0)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(highlightColor, lineWidth: isHighlighted ? 3 : 0)
                )
                .scaleEffect(isHighlighted ? 1.05 : savedAnimationScale)
                .animation(.easeInOut(duration: 0.1), value: isHighlighted)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: savedAnimationScale)
                .shadow(
                    color: isHighlighted ? AppTheme.Colors.accentYellow.opacity(0.5) : Color.clear,
                    radius: isHighlighted ? 8 : 0,
                    x: 0,
                    y: isHighlighted ? 4 : 0
                )
            
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(textColor)
                    .fontWeight(isToday ? .bold : .medium)
                
                if let moodEntry = moodEntry {
                    HStack(spacing: 2) {
                        if moodEntry.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 6))
                                .foregroundColor(.pink)
                        }
                        
                        if !moodEntry.note.isEmpty {
                            Image(systemName: "note.text")
                                .font(.system(size: 6))
                                .foregroundColor(textColor.opacity(0.7))
                        }
                    }
                }
            }
        }
        .frame(height: 44)
        .opacity(isCurrentMonth ? 1.0 : 0.3)
        .onAppear {
            if showSavedAnimation {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    savedAnimationScale = 1.2
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        savedAnimationScale = 1.0
                    }
                }
            }
        }
        .onChange(of: showSavedAnimation) { newValue in
            if newValue {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    savedAnimationScale = 1.2
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        savedAnimationScale = 1.0
                    }
                }
            }
        }
    }
    
    private var backgroundColor: Color {
        if let moodEntry = moodEntry {
            return moodEntry.moodColor.color.opacity(0.8)
        } else {
            return Color.white.opacity(0.1)
        }
    }
    
    private var borderColor: Color {
        return isToday ? AppTheme.Colors.accentYellow : Color.clear
    }
    
    private var highlightColor: Color {
        return AppTheme.Colors.accentYellow
    }
    
    private var textColor: Color {
        if let moodEntry = moodEntry {
            switch moodEntry.moodColor {
            case .yellow, .white:
                return Color.black
            default:
                return Color.white
            }
        } else {
            return AppTheme.Colors.primaryText
        }
    }
}

struct ModernStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                Text(subtitle)
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(animate ? 1.0 : 0.9)
        .opacity(animate ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(description)
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct ModernDistributionRow: View {
    let moodColor: MoodColor
    let count: Int
    let percentage: Int
    let delay: Double
    
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Circle()
                .fill(moodColor.color)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            Text(moodColor.displayName)
                .font(AppTheme.Fonts.callout)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(moodColor.color)
                        .frame(width: animate ? geometry.size.width * CGFloat(percentage) / 100 : 0, height: 8)
                        .animation(.easeOut(duration: 1.0).delay(delay), value: animate)
                }
            }
            .frame(width: 60, height: 8)
            
            HStack(spacing: 4) {
                Text("\(count)")
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.accentYellow)
                    .fontWeight(.medium)
                
                Text("(\(percentage)%)")
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                .fill(Color.white.opacity(0.05))
        )
        .onAppear {
            animate = true
        }
    }
}

struct CalendarDayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    CalendarView()
}
