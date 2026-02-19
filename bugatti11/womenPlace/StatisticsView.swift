import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: DailyEntryViewModel
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 8) {
                        Text("Statistics")
                            .font(AppFonts.playfairBold(size: 28))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Your progress at a glance")
                            .font(AppFonts.playfairRegular(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        StatCardView(
                            title: "Days Tracked",
                            value: "\(viewModel.dailyEntries.count)",
                            icon: "calendar",
                            accent: AppColors.accentYellow
                        )
                        
                        StatCardView(
                            title: "Total Habits",
                            value: "\(viewModel.habits.count)",
                            icon: "repeat.circle",
                            accent: AppColors.lightGreen
                        )
                        
                        StatCardView(
                            title: "Longest Streak",
                            value: "\(viewModel.habits.map { $0.streak }.max() ?? 0)",
                            icon: "flame.fill",
                            accent: AppColors.softPink
                        )
                        
                        StatCardView(
                            title: "Perfect Days",
                            value: "\(viewModel.dailyEntries.filter { $0.progressPercentage == 1.0 }.count)",
                            icon: "star.fill",
                            accent: AppColors.lavender
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    if !viewModel.dailyEntries.isEmpty {
                        let avgCompletion = viewModel.dailyEntries.reduce(0.0) { $0 + $1.progressPercentage } / Double(viewModel.dailyEntries.count)
                        StatCardView(
                            title: "Average Completion",
                            value: "\(Int(avgCompletion * 100))%",
                            icon: "chart.bar.fill",
                            accent: AppColors.primaryBlue
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    CompletionChartView(entries: viewModel.dailyEntries)
                        .padding(.horizontal, 20)
                    
                    if !viewModel.dailyEntries.compactMap(\.mood).isEmpty {
                        MoodDistributionView(entries: viewModel.dailyEntries)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let accent: Color
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(accent.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(Color.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.playfairRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(AppFonts.playfairBold(size: 24))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct CompletionChartView: View {
    let entries: [DailyEntry]
    private let calendar = Calendar.current
    private let numberOfDays = 7
    
    private var dayLabels: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return (0..<numberOfDays).reversed().map { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: Date()) else { return "" }
            return formatter.string(from: date)
        }
    }
    
    private var dataPoints: [Double] {
        (0..<numberOfDays).reversed().map { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: Date()) else { return 0 }
            let dayStart = calendar.startOfDay(for: date)
            if let entry = entries.first(where: { calendar.isDate($0.date, inSameDayAs: dayStart) }) {
                return entry.progressPercentage
            }
            return 0
        }
    }
    
    private var maxValue: Double {
        max(dataPoints.max() ?? 1, 0.1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Completion Over Time")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            if entries.isEmpty {
                Text("No data yet. Complete tasks to see your progress.")
                    .font(AppFonts.playfairRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, value in
                        VStack(spacing: 8) {
                            Text("\(Int(value * 100))%")
                                .font(AppFonts.playfairRegular(size: 10))
                                .foregroundColor(AppColors.secondaryText)
                                .lineLimit(1)
                            
                            GeometryReader { geo in
                                let height = maxValue > 0 ? (value / maxValue) * geo.size.height : 0
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(
                                        LinearGradient(
                                            colors: [AppColors.accentYellow, AppColors.accentYellow.opacity(0.6)],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                    )
                                    .frame(height: max(height, value > 0 ? 4 : 0))
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                            }
                            .frame(height: 120)
                            
                            Text(dayLabels.indices.contains(index) ? dayLabels[index] : "")
                                .font(AppFonts.playfairRegular(size: 11))
                                .foregroundColor(AppColors.secondaryText)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct MoodRowView: View {
    let mood: Mood
    let count: Int
    let total: Int
    
    private var pct: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: mood.rawValue)
                .font(.system(size: 18))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 24, alignment: .center)
            
            Text(mood.displayName)
                .font(AppFonts.playfairRegular(size: 14))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text("\(count)")
                .font(AppFonts.playfairSemiBold(size: 14))
                .foregroundColor(AppColors.accentYellow)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(AppColors.accentYellow.opacity(0.3))
                .frame(width: 80 * pct, height: 8)
        }
    }
}

struct MoodDistributionView: View {
    let entries: [DailyEntry]
    
    private var moodCounts: [(Mood, Int)] {
        let moods = entries.compactMap(\.mood)
        guard !moods.isEmpty else { return [] }
        
        return Mood.allCases.map { mood in
            (mood, moods.filter { $0 == mood }.count)
        }.filter { $0.1 > 0 }.sorted { $0.1 > $1.1 }
    }
    
    private var total: Int {
        moodCounts.reduce(0) { $0 + $1.1 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Mood Overview")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            if moodCounts.isEmpty {
                Text("No mood data yet")
                    .font(AppFonts.playfairRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(moodCounts, id: \.0.rawValue) { mood, count in
                        MoodRowView(mood: mood, count: count, total: total)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}
