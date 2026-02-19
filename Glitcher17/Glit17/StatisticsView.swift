import SwiftUI

struct StatisticsView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(FontManager.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(ColorManager.cardGradient)
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 50, weight: .light))
                                    .foregroundColor(ColorManager.accentYellow)
                            }
                            
                            Text("Your Progress")
                                .font(FontManager.ubuntu(20, weight: .bold))
                                .foregroundColor(ColorManager.textWhite)
                            
                            Text("Track your beauty routine achievements!")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textSecondary)
                        }
                        .padding(.top, 40)
                        
                        VStack(spacing: 20) {
                            Text("Overview")
                                .font(FontManager.ubuntu(18, weight: .bold))
                                .foregroundColor(ColorManager.textWhite)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 20) {
                                StatCard(
                                    title: "Total Procedures",
                                    value: "\(appState.procedures.count)",
                                    icon: "list.bullet"
                                )
                                
                                StatCard(
                                    title: "Completed",
                                    value: "\(appState.history.count)",
                                    icon: "checkmark.circle"
                                )
                            }
                            
                            HStack(spacing: 20) {
                                StatCard(
                                    title: "Categories",
                                    value: "\(appState.categoriesWithProcedures().count)",
                                    icon: "folder"
                                )
                                
                                StatCard(
                                    title: "This Week",
                                    value: "\(completedThisWeek())",
                                    icon: "calendar"
                                )
                            }
                        }
                        
                        if !appState.procedures.isEmpty {
                            CompletionRateCard(
                                completionRate: completionRate(),
                                totalExpected: totalExpectedCompletions(),
                                totalCompleted: appState.history.count
                            )
                        }
                        
                        if !categoryStatistics().isEmpty {
                            CategoryStatisticsView(statistics: categoryStatistics())
                        }
                        
                        if !frequencyStatistics().isEmpty {
                            FrequencyStatisticsView(statistics: frequencyStatistics())
                        }
                        
                        if !appState.history.isEmpty {
                            WeeklyActivityView(history: appState.history)
                        }
                        
                        if !topProcedures().isEmpty {
                            TopProceduresView(procedures: topProcedures())
                        }
                        
                        StreakCard(currentStreak: currentStreak())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func completedThisWeek() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        
        return appState.history.filter { historyEntry in
            historyEntry.completionDate >= startOfWeek && historyEntry.completionDate <= now
        }.count
    }
    
    private func completionRate() -> Double {
        let totalExpected = totalExpectedCompletions()
        guard totalExpected > 0 else { return 0 }
        return Double(appState.history.count) / Double(totalExpected) * 100
    }
    
    private func totalExpectedCompletions() -> Int {
        let calendar = Calendar.current
        let now = Date()
        var total = 0
        
        for procedure in appState.procedures {
            let startDate = procedure.firstExecutionDate
            let daysSinceStart = calendar.dateComponents([.day], from: startDate, to: now).day ?? 0
            
            if daysSinceStart < 0 { continue }
            
            switch procedure.frequency {
            case .daily:
                total += max(0, daysSinceStart + 1)
            case .weekly:
                total += max(0, (daysSinceStart / 7) + 1)
            case .custom(let days):
                total += max(0, (daysSinceStart / days) + 1)
            }
        }
        
        return total
    }
    
    private func categoryStatistics() -> [(category: String, count: Int, percentage: Double)] {
        let total = appState.history.count
        guard total > 0 else { return [] }
        
        var categoryCounts: [String: Int] = [:]
        for entry in appState.history {
            categoryCounts[entry.categoryName, default: 0] += 1
        }
        
        return categoryCounts.map { (category, count) in
            (category: category, count: count, percentage: Double(count) / Double(total) * 100)
        }.sorted { $0.count > $1.count }
    }
    
    private func frequencyStatistics() -> [(frequency: String, count: Int)] {
        var frequencyCounts: [String: Int] = [:]
        for procedure in appState.procedures {
            let frequencyText = procedure.frequency.displayText
            frequencyCounts[frequencyText, default: 0] += 1
        }
        
        return frequencyCounts.map { (frequency: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }
    
    private func topProcedures() -> [(name: String, count: Int)] {
        var procedureCounts: [String: Int] = [:]
        for entry in appState.history {
            procedureCounts[entry.procedureName, default: 0] += 1
        }
        
        return procedureCounts.map { (name: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
            .prefix(5)
            .map { $0 }
    }
    
    private func currentStreak() -> Int {
        let calendar = Calendar.current
        let now = Date()
        var streak = 0
        var currentDate = calendar.startOfDay(for: now)
        
        while true {
            let hasActivity = appState.history.contains { entry in
                calendar.isDate(entry.completionDate, inSameDayAs: currentDate)
            }
            
            if hasActivity {
                streak += 1
                if let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) {
                    currentDate = calendar.startOfDay(for: previousDay)
                } else {
                    break
                }
            } else {
                break
            }
        }
        
        return streak
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(ColorManager.accentYellow)
            
            Text(value)
                .font(FontManager.ubuntu(24, weight: .bold))
                .foregroundColor(ColorManager.textWhite)
            
            Text(title)
                .font(FontManager.ubuntu(12, weight: .medium))
                .foregroundColor(ColorManager.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

struct CompletionRateCard: View {
    let completionRate: Double
    let totalExpected: Int
    let totalCompleted: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Completion Rate")
                .font(FontManager.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.textWhite)
            
            VStack(spacing: 12) {
                HStack {
                    Text("\(Int(completionRate))%")
                        .font(FontManager.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.accentYellow)
                    
                    Spacer()
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.cardBackground)
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.accentYellow)
                            .frame(width: geometry.size.width * CGFloat(completionRate / 100), height: 12)
                    }
                }
                .frame(height: 12)
                
                HStack {
                    Text("\(totalCompleted) of \(totalExpected) completed")
                        .font(FontManager.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.textSecondary)
                    
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

struct CategoryStatisticsView: View {
    let statistics: [(category: String, count: Int, percentage: Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(FontManager.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.textWhite)
            
            VStack(spacing: 12) {
                ForEach(statistics.prefix(5), id: \.category) { stat in
                    CategoryStatRow(
                        category: stat.category,
                        count: stat.count,
                        percentage: stat.percentage
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

struct CategoryStatRow: View {
    let category: String
    let count: Int
    let percentage: Double
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category)
                    .font(FontManager.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.textWhite)
                
                Spacer()
                
                Text("\(count) (\(Int(percentage))%)")
                    .font(FontManager.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.cardBackground)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.accentYellow)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

struct FrequencyStatisticsView: View {
    let statistics: [(frequency: String, count: Int)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Frequency")
                .font(FontManager.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.textWhite)
            
            VStack(spacing: 12) {
                ForEach(statistics, id: \.frequency) { stat in
                    HStack {
                        Image(systemName: "clock")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ColorManager.accentYellow)
                            .frame(width: 24)
                        
                        Text(stat.frequency)
                            .font(FontManager.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.textWhite)
                        
                        Spacer()
                        
                        Text("\(stat.count)")
                            .font(FontManager.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorManager.accentYellow)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

struct WeeklyActivityView: View {
    let history: [HistoryEntry]
    
    private var weeklyData: [(day: String, count: Int)] {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        
        var dayCounts: [Int: Int] = [:]
        
        for entry in history {
            if entry.completionDate >= startOfWeek && entry.completionDate <= now {
                let weekday = calendar.component(.weekday, from: entry.completionDate)
                dayCounts[weekday, default: 0] += 1
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        
        return (1...7).map { dayIndex in
            let date = calendar.date(byAdding: .day, value: dayIndex - calendar.component(.weekday, from: startOfWeek), to: startOfWeek) ?? startOfWeek
            let dayName = formatter.string(from: date)
            let count = dayCounts[dayIndex] ?? 0
            return (day: dayName, count: count)
        }
    }
    
    private var maxCount: Int {
        weeklyData.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week Activity")
                .font(FontManager.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.textWhite)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(weeklyData, id: \.day) { data in
                    VStack(spacing: 8) {
                        Text("\(data.count)")
                            .font(FontManager.ubuntu(12, weight: .bold))
                            .foregroundColor(ColorManager.textWhite)
                            .opacity(data.count > 0 ? 1 : 0.3)
                        
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(data.count > 0 ? ColorManager.accentYellow : ColorManager.cardBackground)
                                .frame(height: max(geometry.size.height * CGFloat(data.count) / CGFloat(maxCount), 4))
                        }
                        .frame(height: 60)
                        
                        Text(data.day)
                            .font(FontManager.ubuntu(10, weight: .medium))
                            .foregroundColor(ColorManager.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

struct TopProceduresView: View {
    let procedures: [(name: String, count: Int)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Most Completed")
                .font(FontManager.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.textWhite)
            
            VStack(spacing: 12) {
                ForEach(Array(procedures.enumerated()), id: \.offset) { index, procedure in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(ColorManager.accentYellow.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Text("\(index + 1)")
                                .font(FontManager.ubuntu(14, weight: .bold))
                                .foregroundColor(ColorManager.accentYellow)
                        }
                        
                        Text(procedure.name)
                            .font(FontManager.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.textWhite)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("\(procedure.count)")
                            .font(FontManager.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorManager.accentYellow)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

struct StreakCard: View {
    let currentStreak: Int
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorManager.accentYellow.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(ColorManager.accentYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Streak")
                    .font(FontManager.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.textSecondary)
                
                Text("\(currentStreak) day\(currentStreak == 1 ? "" : "s")")
                    .font(FontManager.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorManager.textWhite)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

#Preview {
    StatisticsView(appState: AppState())
}

