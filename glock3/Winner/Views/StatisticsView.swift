import SwiftUI

struct StatisticsView: View {
    @ObservedObject var store: VictoryStore
    @State private var selectedPeriod: StatisticsPeriod = .week
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .opacity(0)
                    }
                    .disabled(true)
                    
                    Text("Statistics")
                        .font(AppFonts.navigationTitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                
                if store.victories.isEmpty {
                    EmptyStateView(
                        iconName: "chart.bar",
                        title: "No Statistics Yet",
                        subtitle: "Statistics will appear when you add your first victory",
                        buttonTitle: "Go to Feed"
                    ) {
                        withAnimation {
                            selectedTab = .feed
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            PeriodSelectorView(selectedPeriod: $selectedPeriod)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                StatisticCardView(
                                    title: "Total Victories",
                                    value: "\(store.getTotalVictories())",
                                    iconName: "trophy.fill",
                                    color: AppColors.primaryYellow
                                )
                                
                                StatisticCardView(
                                    title: "Last \(selectedPeriod.rawValue)",
                                    value: "\(store.getVictoriesCount(for: selectedPeriod))",
                                    iconName: "calendar",
                                    color: AppColors.accentGreen
                                )
                                
                                if let bestDay = store.getBestDay(for: selectedPeriod) {
                                    StatisticCardView(
                                        title: "Best Day",
                                        value: "\(bestDay.count)",
                                        subtitle: bestDay.date.formatted(date: .abbreviated, time: .omitted),
                                        iconName: "star.fill",
                                        color: AppColors.accentOrange
                                    )
                                } else {
                                    StatisticCardView(
                                        title: "Best Day",
                                        value: "—",
                                        iconName: "star.fill",
                                        color: AppColors.accentOrange
                                    )
                                }
                                
                                StatisticCardView(
                                    title: "Current Streak",
                                    value: "\(store.getCurrentStreak())",
                                    subtitle: store.getCurrentStreak() == 1 ? "day" : "days",
                                    iconName: "flame.fill",
                                    color: AppColors.accentPurple
                                )
                            }
                            
                            VStack(spacing: 16) {
                                InsightCardView(store: store)
                                CategoryBreakdownView(store: store)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

struct PeriodSelectorView: View {
    @Binding var selectedPeriod: StatisticsPeriod
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                Button {
                    selectedPeriod = period
                } label: {
                    Text(period.rawValue)
                        .font(AppFonts.callout)
                        .foregroundColor(selectedPeriod == period ? .black : AppColors.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ? AppColors.primaryYellow : AppColors.cardBackground)
                        .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
    }
}

struct StatisticCardView: View {
    let title: String
    let value: String
    let subtitle: String?
    let iconName: String
    let color: Color
    
    init(title: String, value: String, subtitle: String? = nil, iconName: String, color: Color) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.iconName = iconName
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(AppFonts.caption2)
                    .foregroundColor(AppColors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct InsightCardView: View {
    @ObservedObject var store: VictoryStore
    
    private var insight: String {
        let total = store.getTotalVictories()
        let thisWeek = store.getVictoriesCount(for: .week)
        let streak = store.getCurrentStreak()
        
        if total == 0 {
            return "Start your journey by adding your first victory!"
        } else if streak > 7 {
            return "Amazing! You're on a \(streak)-day streak. Keep it up!"
        } else if thisWeek > 5 {
            return "Great week! You've logged \(thisWeek) victories this week."
        } else if total > 50 {
            return "Incredible! You've reached \(total) total victories."
        } else {
            return "You're building momentum with \(total) victories so far!"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Insight")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            Text(insight)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct CategoryBreakdownView: View {
    @ObservedObject var store: VictoryStore
    
    private var categoryStats: [(name: String, count: Int)] {
        let grouped = Dictionary(grouping: store.victories) { $0.category ?? "Uncategorized" }
        return grouped.map { (name: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
            .prefix(5)
            .map { $0 }
    }
    
    private func barColor(for categoryName: String) -> Color {
        let colors: [Color] = [
            AppColors.primaryYellow,
            AppColors.accentGreen,
            AppColors.accentOrange,
            AppColors.accentPurple,
            AppColors.textSecondary
        ]
        
        let index = categoryStats.firstIndex { $0.name == categoryName } ?? 0
        return colors[index % colors.count]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.accentGreen)
                
                Text("Top Categories")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            if categoryStats.isEmpty {
                Text("No categories yet")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textTertiary)
            } else {
                VStack(spacing: 12) {
                    ForEach(categoryStats, id: \.name) { stat in
                        VStack(spacing: 6) {
                            HStack {
                                Text(stat.name)
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Spacer()
                                
                                Text("\(stat.count)")
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            GeometryReader { geometry in
                                let maxCount = categoryStats.first?.count ?? 1
                                let barWidth = geometry.size.width * CGFloat(stat.count) / CGFloat(maxCount)
                                
                                HStack(spacing: 0) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(barColor(for: stat.name))
                                        .frame(width: barWidth, height: 6)
                                    
                                    Spacer(minLength: 0)
                                }
                            }
                            .frame(height: 6)
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}


