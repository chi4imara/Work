import SwiftUI

struct StatisticsView: View {
    @ObservedObject var store: FirstExperienceStore
    @State private var selectedPeriod: StatisticsPeriod = .week
    
    @Binding var selectedTabStat: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if store.experiences.isEmpty {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Statistics")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
            }
            
            Picker("Period", selection: $selectedPeriod) {
                ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .colorScheme(.dark)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                statisticsGrid
                
                if !store.experiences.isEmpty {
                    CategoryPieChart(experiences: store.experiences)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.8)),
                            removal: .opacity
                        ))
                }
                
                insightsSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
            .animation(.easeInOut(duration: 0.5), value: selectedPeriod)
        }
    }
    
    private var statisticsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatisticCard(
                title: "Total First Times",
                value: "\(store.getTotalCount())",
                icon: "star.fill",
                color: AppColors.accentYellow
            )
            
            StatisticCard(
                title: "Last \(selectedPeriod.rawValue)",
                value: "\(getPeriodCount())",
                icon: "calendar",
                color: AppColors.lightPurple
            )
            
            if let mostActiveDay = store.getMostActiveDay(for: selectedPeriod) {
                StatisticCard(
                    title: "Most Active Day",
                    value: "\(mostActiveDay.count)",
                    subtitle: DateFormatter.shortFormatter.string(from: mostActiveDay.date),
                    icon: "flame.fill",
                    color: AppColors.peachOrange
                )
            } else {
                StatisticCard(
                    title: "Most Active Day",
                    value: "0",
                    subtitle: "No data",
                    icon: "flame.fill",
                    color: AppColors.peachOrange
                )
            }
            
            if let topCategory = store.getTopCategory(for: selectedPeriod) {
                StatisticCard(
                    title: "Top Category",
                    value: "\(topCategory.count)",
                    subtitle: topCategory.category,
                    icon: "tag.fill",
                    color: AppColors.mintGreen
                )
            } else {
                StatisticCard(
                    title: "Top Category",
                    value: "0",
                    subtitle: "No data",
                    icon: "tag.fill",
                    color: AppColors.mintGreen
                )
            }
        }
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(FontManager.title2)
                .foregroundColor(AppColors.pureWhite)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                InsightCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Recent Activity",
                    description: getRecentActivityInsight(),
                    color: AppColors.softPink
                )
                
                InsightCard(
                    icon: "square.grid.3x3.fill",
                    title: "Category Diversity",
                    description: getCategoryDiversityInsight(),
                    color: AppColors.lightPurple
                )
                
                InsightCard(
                    icon: "calendar.badge.plus",
                    title: "Experience Frequency",
                    description: getFrequencyInsight(),
                    color: AppColors.mintGreen
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.pureWhite.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.pureWhite.opacity(0.7))
            }
            
            VStack(spacing: 12) {
                Text("No Statistics Yet")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.pureWhite)
                
                Text("Statistics will appear when you add your first experience")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.pureWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Button("Go to Feed") {
                selectedTabStat = 0
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func getPeriodCount() -> Int {
        let days: Int
        switch selectedPeriod {
        case .week: days = 7
        case .month: days = 30
        case .year: days = 365
        }
        return store.getCountForPeriod(days: days)
    }
    
    private func getRecentActivityInsight() -> String {
        let last7Days = store.getCountForPeriod(days: 7)
        let last30Days = store.getCountForPeriod(days: 30)
        
        if last7Days == 0 {
            return "No recent activity. Time to try something new!"
        } else if last7Days >= 3 {
            return "Great momentum! You've been very active lately."
        } else if last30Days > last7Days * 2 {
            return "You were more active earlier this month."
        } else {
            return "Steady progress with your new experiences."
        }
    }
    
    private func getCategoryDiversityInsight() -> String {
        let uniqueCategories = Set(store.experiences.compactMap { $0.category }).count
        let totalExperiences = store.experiences.count
        
        if uniqueCategories == 0 {
            return "Consider adding categories to organize your experiences."
        } else if uniqueCategories == 1 {
            return "You're focused on one category. Try exploring others!"
        } else if uniqueCategories >= totalExperiences / 2 {
            return "Great diversity! You're exploring many different areas."
        } else {
            return "You have \(uniqueCategories) different categories of experiences."
        }
    }
    
    private func getFrequencyInsight() -> String {
        let lastExperienceDate = store.experiences.last?.date ?? .now
        let totalDays = Calendar.current.dateComponents([.day], from: lastExperienceDate, to: .now).day ?? 0
        let daysCount = max(1, totalDays) 
        let avgPerWeek = Double(store.experiences.count) / Double(daysCount) * 7
        
        if avgPerWeek >= 2 {
            return "Excellent! You're adding multiple experiences per week."
        } else if avgPerWeek >= 1 {
            return "Good pace! About one new experience per week."
        } else if avgPerWeek >= 0.5 {
            return "Steady progress with regular new experiences."
        } else {
            return "Consider trying new things more frequently."
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let color: Color
    
    init(title: String, value: String, subtitle: String? = nil, icon: String, color: Color) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.title1)
                .foregroundColor(AppColors.darkGray)
            
            Text(title)
                .font(FontManager.caption1)
                .foregroundColor(AppColors.mediumGray)
                .multilineTextAlignment(.center)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(FontManager.caption2)
                    .foregroundColor(AppColors.mediumGray.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .cardBackground()
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Text(description)
                    .font(FontManager.callout)
                    .foregroundColor(AppColors.mediumGray)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(16)
        .cardBackground()
    }
}

extension DateFormatter {
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}


