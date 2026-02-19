import SwiftUI
import Combine

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    HStack {
                        Text("Statistics")
                            .font(Theme.Fonts.playfairBold(size: 24))
                            .foregroundColor(Theme.Colors.text)
                        
                        Spacer()
                        
                        Button(action: { viewModel.load() }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(Theme.Colors.primary)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, Theme.Spacing.lg)
                    
                    if viewModel.isEmpty {
                        EmptyStatisticsView()
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.md) {
                            StatSummaryCard(
                                title: "Total Habits",
                                value: "\(viewModel.totalHabits)",
                                icon: "list.bullet.circle.fill"
                            )
                            StatSummaryCard(
                                title: "Habits Completed Today",
                                value: "\(viewModel.habitsCompletedToday)",
                                icon: "checkmark.circle.fill"
                            )
                            StatSummaryCard(
                                title: "Total Completions",
                                value: "\(viewModel.totalCompletions)",
                                icon: "star.fill"
                            )
                            StatSummaryCard(
                                title: "Gratitude Entries",
                                value: "\(viewModel.totalGratitudeEntries)",
                                icon: "heart.fill"
                            )
                            StatSummaryCard(
                                title: "Days with Entries",
                                value: "\(viewModel.daysWithEntries)",
                                icon: "calendar"
                            )
                            StatSummaryCard(
                                title: "Best Streak",
                                value: "\(viewModel.bestStreak)",
                                subtitle: "days",
                                icon: "flame.fill"
                            )
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                        
                        if !viewModel.habitsByStreak.isEmpty {
                            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                                Text("Top Habits by Streak")
                                    .font(Theme.Fonts.playfairSemiBold(size: 18))
                                    .foregroundColor(Theme.Colors.text)
                                
                                VStack(spacing: Theme.Spacing.sm) {
                                    ForEach(viewModel.habitsByStreak.prefix(5)) { habit in
                                        HStack {
                                            Image(systemName: habit.icon)
                                                .foregroundColor(Theme.Colors.accent)
                                                .frame(width: 28, alignment: .center)
                                            
                                            Text(habit.name)
                                                .font(Theme.Fonts.playfairMedium(size: 14))
                                                .foregroundColor(Theme.Colors.text)
                                                .lineLimit(1)
                                            
                                            Spacer()
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "flame.fill")
                                                    .foregroundColor(Theme.Colors.accent)
                                                    .font(.caption)
                                                Text("\(habit.currentStreak)")
                                                    .font(Theme.Fonts.playfairSemiBold(size: 14))
                                                    .foregroundColor(Theme.Colors.text)
                                            }
                                        }
                                        .padding(.vertical, Theme.Spacing.sm)
                                        .padding(.horizontal, Theme.Spacing.md)
                                        .background(
                                            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                                .fill(Theme.Colors.background.opacity(0.8))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                        }
                        
                        if !viewModel.last7DaysCompletion.isEmpty {
                            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                                Text("Last 7 Days")
                                    .font(Theme.Fonts.playfairSemiBold(size: 18))
                                    .foregroundColor(Theme.Colors.text)
                                
                                HStack(alignment: .bottom, spacing: Theme.Spacing.xs) {
                                    ForEach(Array(viewModel.last7DaysCompletion.enumerated()), id: \.offset) { index, value in
                                        VStack(spacing: Theme.Spacing.xs) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Theme.Colors.primary, Theme.Colors.accent],
                                                        startPoint: .bottom,
                                                        endPoint: .top
                                                    )
                                                )
                                                .frame(height: max(20, CGFloat(value) * 60))
                                            
                                            Text(viewModel.last7DaysLabels.indices.contains(index) ? viewModel.last7DaysLabels[index] : "")
                                                .font(Theme.Fonts.playfairRegular(size: 10))
                                                .foregroundColor(Theme.Colors.textSecondary)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .frame(height: 100)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                                        .fill(Theme.Colors.background.opacity(0.8))
                                )
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
}

struct StatSummaryCard: View {
    let title: String
    let value: String
    var subtitle: String = ""
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Theme.Colors.primary)
                    .font(.title3)
                
                Spacer()
            }
            
            HStack(alignment: .firstTextBaseline) {
                Text(value)
                    .font(Theme.Fonts.playfairBold(size: 22))
                    .foregroundColor(Theme.Colors.text)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(Theme.Fonts.playfairRegular(size: 12))
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
            
            Text(title)
                .font(Theme.Fonts.playfairRegular(size: 12))
                .foregroundColor(Theme.Colors.textSecondary)
                .lineLimit(2)
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.Colors.primary.opacity(0.1),
                                Theme.Colors.primary.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "chart.bar.doc.horizontal")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(Theme.Colors.primary)
            }
            
            VStack(spacing: Theme.Spacing.md) {
                Text("No Statistics Yet")
                    .font(Theme.Fonts.playfairSemiBold(size: 20))
                    .foregroundColor(Theme.Colors.text)
                
                Text("Complete habits and add gratitude entries to see your progress here")
                    .font(Theme.Fonts.playfairRegular(size: 16))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
        }
    }
}

class StatisticsViewModel: ObservableObject {
    @Published var totalHabits: Int = 0
    @Published var habitsCompletedToday: Int = 0
    @Published var totalCompletions: Int = 0
    @Published var totalGratitudeEntries: Int = 0
    @Published var daysWithEntries: Int = 0
    @Published var bestStreak: Int = 0
    @Published var habitsByStreak: [Habit] = []
    @Published var last7DaysCompletion: [Double] = []
    @Published var last7DaysLabels: [String] = []
    
    private let userDefaults = UserDefaults.standard
    private let calendar = Calendar.current
    
    var isEmpty: Bool {
        totalHabits == 0 && totalGratitudeEntries == 0
    }
    
    func load() {
        loadHabits()
        loadDailyEntries()
        computeLast7Days()
    }
    
    private func loadHabits() {
        guard let data = userDefaults.data(forKey: "habits"),
              let habits = try? JSONDecoder().decode([Habit].self, from: data) else {
            totalHabits = 0
            habitsCompletedToday = 0
            totalCompletions = 0
            bestStreak = 0
            habitsByStreak = []
            return
        }
        
        totalHabits = habits.count
        habitsCompletedToday = habits.filter { $0.isCompletedToday }.count
        totalCompletions = habits.reduce(0) { $0 + $1.completedDates.count }
        bestStreak = habits.map(\.currentStreak).max() ?? 0
        habitsByStreak = habits.sorted { $0.currentStreak > $1.currentStreak }
    }
    
    private func loadDailyEntries() {
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -30, to: endDate) ?? endDate
        
        var totalGratitude = 0
        var daysCount = 0
        
        var currentDate = startDate
        while currentDate <= endDate {
            let key = "dailyEntry_\(calendar.startOfDay(for: currentDate).timeIntervalSince1970)"
            
            if let data = userDefaults.data(forKey: key),
               let entry = try? JSONDecoder().decode(DailyEntry.self, from: data) {
                totalGratitude += entry.gratitudeEntries.count
                daysCount += 1
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        totalGratitudeEntries = totalGratitude
        daysWithEntries = daysCount
    }
    
    private func computeLast7Days() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        
        var values: [Double] = []
        var labels: [String] = []
        
        for dayOffset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            
            let key = "dailyEntry_\(calendar.startOfDay(for: date).timeIntervalSince1970)"
            var progress: Double = 0
            
            if let data = userDefaults.data(forKey: key),
               let entry = try? JSONDecoder().decode(DailyEntry.self, from: data) {
                let totalTasks = 4.0
                let completed = (entry.selectedMoods.isEmpty ? 0 : 1) +
                    (entry.gratitudeEntries.isEmpty ? 0 : 1) +
                    (entry.dailyQuestion?.answer.isEmpty == false ? 1 : 0) +
                    Double(entry.completedHabits.count)
                progress = min(1, completed / max(1, totalTasks))
            }
            
            values.append(progress)
            labels.append(formatter.string(from: date))
        }
        
        last7DaysCompletion = values
        last7DaysLabels = labels
    }
}

#Preview {
    StatisticsView()
}
