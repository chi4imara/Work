import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var selectedDate = Date()
    @State private var showingDateDetail = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HistoryHeaderSection()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        CalendarView(
                            selectedDate: $selectedDate,
                            viewModel: viewModel,
                            onDateSelected: { date in
                                selectedDate = date
                                showingDateDetail = true
                            }
                        )
                        
                        RecentEntriesSection(viewModel: viewModel)
                        
                        MoodTrendsSection(viewModel: viewModel)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingDateDetail) {
            DayDetailView(date: selectedDate, viewModel: viewModel)
        }
    }
}

struct HistoryHeaderSection: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("History")
                    .font(AppFonts.playfairBold(size: 28))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Track your wellness journey")
                    .font(AppFonts.playfairRegular(size: 16))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.lg)
        .padding(.bottom, AppSpacing.md)
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let viewModel: MoodViewModel
    let onDateSelected: (Date) -> Void
    
    @State private var currentMonth = Date()
    
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
        guard let monthRange = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstDayOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start else {
            return []
        }
        
        return monthRange.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }
    }
    
    private var firstWeekday: Int {
        guard let firstDayOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start else {
            return 0
        }
        return calendar.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Button(action: {
                    withAnimation(AppAnimations.smooth) {
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(AppFonts.playfairSemiBold(size: 20))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(AppAnimations.smooth) {
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
            }
            
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { weekday in
                    Text(weekday)
                        .font(AppFonts.playfairMedium(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: AppSpacing.xs) {
                ForEach(0..<firstWeekday, id: \.self) { _ in
                    Text("")
                        .frame(height: 40)
                }
                
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        hasEntry: hasEntryForDate(date),
                        mood: getMoodForDate(date),
                        onTap: {
                            selectedDate = date
                            onDateSelected(date)
                        }
                    )
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppRadius.md)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func hasEntryForDate(_ date: Date) -> Bool {
        return viewModel.dailyEntries.contains { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
    
    private func getMoodForDate(_ date: Date) -> Mood? {
        return viewModel.dailyEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }?.selectedMood
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEntry: Bool
    let mood: Mood?
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    private var dayNumber: String {
        String(calendar.component(.day, from: date))
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    private var isFutureDate: Bool {
        date > Date()
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(AppColors.primary)
                } else if isToday {
                    Circle()
                        .stroke(AppColors.primary, lineWidth: 2)
                } else if hasEntry {
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                }
                
                Text(dayNumber)
                    .font(AppFonts.playfairMedium(size: 14))
                    .foregroundColor(
                        isSelected ? .white :
                        isFutureDate ? AppColors.textSecondary.opacity(0.5) :
                        AppColors.textPrimary
                    )
                
                if let mood = mood, !isSelected {
                    VStack {
                        Spacer()
                        Circle()
                            .fill(mood.emotion.color)
                            .frame(width: 6, height: 6)
                            .offset(y: -2)
                    }
                }
            }
            .frame(width: 40, height: 40)
        }
        .disabled(isFutureDate)
        .animation(AppAnimations.quick, value: isSelected)
    }
}

struct RecentEntriesSection: View {
    let viewModel: MoodViewModel
    
    private var recentEntries: [DailyEntry] {
        viewModel.dailyEntries
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Recent Entries")
                .font(AppFonts.playfairSemiBold(size: 20))
                .foregroundColor(AppColors.textPrimary)
            
            if recentEntries.isEmpty {
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("No entries yet")
                        .font(AppFonts.playfairMedium(size: 16))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("Start tracking your mood to see your history here")
                        .font(AppFonts.playfairRegular(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(AppSpacing.xl)
                .background(AppColors.cardBackground)
                .cornerRadius(AppRadius.md)
            } else {
                LazyVStack(spacing: AppSpacing.sm) {
                    ForEach(recentEntries) { entry in
                        HistoryEntryRow(entry: entry, viewModel: viewModel)
                    }
                }
            }
        }
    }
}

struct HistoryEntryRow: View {
    let entry: DailyEntry
    let viewModel: MoodViewModel
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(dateFormatter.string(from: entry.date))
                    .font(AppFonts.playfairSemiBold(size: 14))
                    .foregroundColor(AppColors.textPrimary)
                
                if let mood = entry.selectedMood {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: mood.emotion.systemImage)
                            .font(.system(size: 12))
                            .foregroundColor(mood.emotion.color)
                        
                        Text(mood.emotion.displayName)
                            .font(AppFonts.playfairRegular(size: 12))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            CircularProgressView(
                progress: entry.progressPercentage,
                size: 30,
                lineWidth: 3
            )
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppRadius.md)
    }
    
}

struct MoodTrendsSection: View {
    @ObservedObject var viewModel: MoodViewModel
    
    private var moodCounts: [String: Int] {
        var counts: [String: Int] = [:]
        for entry in viewModel.dailyEntries {
            if let mood = entry.selectedMood {
                counts[mood.emotion.displayName, default: 0] += 1
            }
        }
        return counts
    }
    
    private var sortedMoods: [(String, Int)] {
        moodCounts.sorted { $0.value > $1.value }.map { ($0.key, $0.value) }
    }
    
    private var maxCount: Int {
        sortedMoods.map(\.1).max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Mood Trends")
                .font(AppFonts.playfairSemiBold(size: 20))
                .foregroundColor(AppColors.textPrimary)
            
            if sortedMoods.isEmpty {
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.textSecondary)
                    Text("No mood data yet")
                        .font(AppFonts.playfairMedium(size: 16))
                        .foregroundColor(AppColors.textSecondary)
                    Text("Track your moods on the Today tab or load sample data in Settings")
                        .font(AppFonts.playfairRegular(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(AppSpacing.xl)
                .background(AppColors.cardBackground)
                .cornerRadius(AppRadius.md)
            } else {
                VStack(spacing: AppSpacing.md) {
                    ForEach(Array(sortedMoods.enumerated()), id: \.offset) { index, pair in
                        let moodName = pair.0
                        let count = pair.1
                        let mood = Mood.allMoods.first { $0.emotion.displayName == moodName }
                        let barWidth = maxCount > 0 ? CGFloat(count) / CGFloat(maxCount) : 0
                        
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            HStack(spacing: AppSpacing.sm) {
                                if let mood = mood {
                                    Image(systemName: mood.emotion.systemImage)
                                        .font(.system(size: 14))
                                        .foregroundColor(mood.emotion.color)
                                        .frame(width: 20, alignment: .center)
                                }
                                Text(moodName)
                                    .font(AppFonts.playfairMedium(size: 14))
                                    .foregroundColor(AppColors.textPrimary)
                                Spacer()
                                Text("\(count)")
                                    .font(AppFonts.playfairSemiBold(size: 14))
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(AppColors.primary.opacity(0.15))
                                        .frame(height: 8)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(mood?.emotion.color ?? AppColors.primary)
                                        .frame(width: max(0, geo.size.width * barWidth), height: 8)
                                }
                            }
                            .frame(height: 8)
                        }
                    }
                }
                .padding(AppSpacing.md)
                .background(AppColors.cardBackground)
                .cornerRadius(AppRadius.md)
            }
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.primary.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppColors.primary, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
        }
    }
}

struct DayDetailView: View {
    let date: Date
    let viewModel: MoodViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter
    }()
    
    private var dayEntry: DailyEntry? {
        viewModel.dailyEntries.first { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: date)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        Text(dateFormatter.string(from: date))
                            .font(AppFonts.playfairBold(size: 24))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.top, AppSpacing.lg)
                        
                        if let entry = dayEntry {
                            if let mood = entry.selectedMood {
                                VStack(spacing: AppSpacing.md) {
                                    Text("Mood")
                                        .font(AppFonts.playfairSemiBold(size: 18))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    HStack(spacing: AppSpacing.md) {
                                        Image(systemName: mood.emotion.systemImage)
                                            .font(.system(size: 30))
                                            .foregroundColor(mood.emotion.color)
                                        
                                        Text(mood.emotion.displayName)
                                            .font(AppFonts.playfairSemiBold(size: 20))
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                    
                                    if !entry.note.isEmpty {
                                        Text(entry.note)
                                            .font(AppFonts.playfairRegular(size: 16))
                                            .foregroundColor(AppColors.textSecondary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, AppSpacing.md)
                                    }
                                }
                                .padding(AppSpacing.md)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppRadius.md)
                            }
                            
                            if !entry.completedRituals.isEmpty {
                                VStack(alignment: .leading, spacing: AppSpacing.md) {
                                    Text("Completed Rituals")
                                        .font(AppFonts.playfairSemiBold(size: 18))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    ForEach(entry.completedRituals, id: \.self) { ritualId in
                                        if let ritual = viewModel.rituals.first(where: { $0.id == ritualId }) {
                                            HStack {
                                                Image(systemName: ritual.category.systemImage)
                                                    .font(.system(size: 16))
                                                    .foregroundColor(AppColors.success)
                                                
                                                Text(ritual.name)
                                                    .font(AppFonts.playfairMedium(size: 16))
                                                    .foregroundColor(AppColors.textPrimary)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(AppColors.success)
                                            }
                                            .padding(.vertical, AppSpacing.xs)
                                        }
                                    }
                                }
                                .padding(AppSpacing.md)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppRadius.md)
                            }
                            
                            if let challenge = entry.completedChallenge {
                                VStack(alignment: .leading, spacing: AppSpacing.md) {
                                    Text("Daily Challenge")
                                        .font(AppFonts.playfairSemiBold(size: 18))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    HStack {
                                        Image(systemName: challenge.category.systemImage)
                                            .font(.system(size: 16))
                                            .foregroundColor(AppColors.secondary)
                                        
                                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                            Text(challenge.title)
                                                .font(AppFonts.playfairMedium(size: 16))
                                                .foregroundColor(AppColors.textPrimary)
                                            
                                            Text(challenge.description)
                                                .font(AppFonts.playfairRegular(size: 14))
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(AppColors.secondary)
                                    }
                                }
                                .padding(AppSpacing.md)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppRadius.md)
                            }
                            
                            VStack(spacing: AppSpacing.md) {
                                Text("Daily Progress")
                                    .font(AppFonts.playfairSemiBold(size: 18))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                CircularProgressView(
                                    progress: entry.progressPercentage,
                                    size: 80,
                                    lineWidth: 8
                                )
                                .overlay(
                                    Text("\(Int(entry.progressPercentage * 100))%")
                                        .font(AppFonts.playfairBold(size: 16))
                                        .foregroundColor(AppColors.textPrimary)
                                )
                            }
                            .padding(AppSpacing.md)
                            .frame(maxWidth: .infinity)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppRadius.md)
                            
                        } else {
                            VStack(spacing: AppSpacing.md) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 50))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Text("No Entry")
                                    .font(AppFonts.playfairSemiBold(size: 20))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("You didn't track anything on this day")
                                    .font(AppFonts.playfairRegular(size: 16))
                                    .foregroundColor(AppColors.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(AppSpacing.xl)
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(AppFonts.playfairMedium(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(MoodViewModel())
}
