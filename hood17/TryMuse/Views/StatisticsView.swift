import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: ListViewModel
    
    private var statistics: AppStatistics {
        AppStatistics(from: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Text("Statistics")
                                .font(.appLargeTitle)
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            StatCard(
                                title: "Total Lists",
                                value: "\(statistics.totalLists)",
                                icon: "list.bullet",
                                color: AppColors.primaryBlue
                            )
                            
                            StatCard(
                                title: "Total Items",
                                value: "\(statistics.totalItems)",
                                icon: "checkmark.circle",
                                color: AppColors.success
                            )
                            
                            StatCard(
                                title: "Completed",
                                value: "\(statistics.completedItems)",
                                icon: "checkmark.circle.fill",
                                color: AppColors.yellow
                            )
                            
                            StatCard(
                                title: "Completion Rate",
                                value: "\(Int(statistics.completionRate * 100))%",
                                icon: "chart.pie.fill",
                                color: AppColors.lightBlue
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        if statistics.totalItems > 0 {
                            StatisticsSection(title: "Task Completion") {
                                CompletionChartView(
                                    completed: statistics.completedItems,
                                    total: statistics.totalItems
                                )
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(20)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        if !statistics.categoryDistribution.isEmpty {
                            StatisticsSection(title: "Lists by Category") {
                                ForEach(statistics.categoryDistribution.sorted(by: { $0.value > $1.value }), id: \.key) { category, count in
                                    CategoryRow(
                                        category: category,
                                        count: count,
                                        percentage: Double(count) / Double(statistics.totalLists) * 100
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        if !statistics.recentCompletions.isEmpty {
                            StatisticsSection(title: "Recent Completions") {
                                ForEach(statistics.recentCompletions.prefix(5), id: \.id) { item in
                                    RecentActivityRow(
                                        item: item,
                                        listName: viewModel.getList(by: item.listId)?.name ?? "Unknown"
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        StatisticsSection(title: "Insights") {
                            VStack(spacing: 16) {
                                InsightCard(
                                    icon: "star.fill",
                                    title: "Most Productive Category",
                                    description: statistics.mostProductiveCategory,
                                    color: AppColors.yellow
                                )
                                
                                InsightCard(
                                    icon: "clock.fill",
                                    title: "Average Completion Time",
                                    description: statistics.averageCompletionTime,
                                    color: AppColors.lightBlue
                                )
                                
                                if statistics.longestStreak > 0 {
                                    InsightCard(
                                        icon: "flame.fill",
                                        title: "Longest Streak",
                                        description: "\(statistics.longestStreak) days in a row",
                                        color: AppColors.success
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct AppStatistics {
    let totalLists: Int
    let totalItems: Int
    let completedItems: Int
    let completionRate: Double
    let categoryDistribution: [ListCategory: Int]
    let recentCompletions: [ListItemModel]
    let mostProductiveCategory: String
    let averageCompletionTime: String
    let longestStreak: Int
    
    init(from viewModel: ListViewModel) {
        self.totalLists = viewModel.lists.count
        self.totalItems = viewModel.listItems.count
        self.completedItems = viewModel.listItems.filter { $0.isCompleted }.count
        self.completionRate = self.totalItems > 0 ? Double(self.completedItems) / Double(self.totalItems) : 0.0
        
        var categoryCount: [ListCategory: Int] = [:]
        for list in viewModel.lists {
            categoryCount[list.category, default: 0] += 1
        }
        self.categoryDistribution = categoryCount
        
        self.recentCompletions = viewModel.listItems
            .filter { $0.isCompleted && $0.completedAt != nil }
            .sorted { ($0.completedAt ?? Date.distantPast) > ($1.completedAt ?? Date.distantPast) }
        
        let categoryCompletionRates = categoryCount.map { category, count in
            let categoryItems = viewModel.listItems.filter { item in
                viewModel.getList(by: item.listId)?.category == category
            }
            let completedInCategory = categoryItems.filter { $0.isCompleted }.count
            let rate = categoryItems.count > 0 ? Double(completedInCategory) / Double(categoryItems.count) : 0.0
            return (category, rate)
        }
        
        if let mostProductive = categoryCompletionRates.max(by: { $0.1 < $1.1 }) {
            self.mostProductiveCategory = "\(mostProductive.0.displayName) (\(Int(mostProductive.1 * 100))%)"
        } else {
            self.mostProductiveCategory = "No data yet"
        }
        
        let completedItemsWithTime = viewModel.listItems.filter { $0.isCompleted && $0.completedAt != nil }
        if !completedItemsWithTime.isEmpty {
            let totalTime = completedItemsWithTime.reduce(0) { total, item in
                let timeToComplete = item.completedAt!.timeIntervalSince(item.createdAt)
                return total + timeToComplete
            }
            let averageTime = totalTime / Double(completedItemsWithTime.count)
            let days = Int(averageTime / (24 * 60 * 60))
            self.averageCompletionTime = days > 0 ? "\(days) days" : "Less than a day"
        } else {
            self.averageCompletionTime = "No completions yet"
        }
        
        self.longestStreak = Self.calculateLongestStreak(completedItems: completedItemsWithTime)
    }
    
    private static func calculateLongestStreak(completedItems: [ListItemModel]) -> Int {
        let sortedCompletions = completedItems
            .compactMap { $0.completedAt }
            .sorted()
        
        guard !sortedCompletions.isEmpty else { return 0 }
        
        var currentStreak = 1
        var longestStreak = 1
        
        for i in 1..<sortedCompletions.count {
            let daysBetween = Calendar.current.dateComponents([.day], from: sortedCompletions[i-1], to: sortedCompletions[i]).day ?? 0
            if daysBetween <= 1 {
                currentStreak += 1
                longestStreak = max(longestStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return longestStreak
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.appTitle2)
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(.appCaption)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct StatisticsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.appHeadline)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct CategoryRow: View {
    let category: ListCategory
    let count: Int
    let percentage: Double
    
    var body: some View {
        HStack {
            Text(category.displayName)
                .font(.appBody)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text("\(count) (\(Int(percentage))%)")
                .font(.appCaption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
    }
}

struct RecentActivityRow: View {
    let item: ListItemModel
    let listName: String
    
    private var formattedDate: String {
        guard let completedAt = item.completedAt else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: completedAt)
    }
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundColor(AppColors.success)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.appBody)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text("from \(listName)")
                    .font(.appCaption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text(formattedDate)
                .font(.appCaption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
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
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.appHeadline)
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(16)
    }
}

struct CompletionChartView: View {
    let completed: Int
    let total: Int
    
    private var completedPercentage: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
    
    private var remaining: Int {
        return total - completed
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(AppColors.cardBackground, lineWidth: 20)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: completedPercentage)
                    .stroke(
                        LinearGradient(
                            colors: [AppColors.success, AppColors.yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: completedPercentage)
                
                VStack(spacing: 4) {
                    Text("\(Int(completedPercentage * 100))%")
                        .font(.appTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Complete")
                        .font(.appCaption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            HStack(spacing: 30) {
                LegendItem(
                    color: AppColors.success,
                    title: "Completed",
                    count: completed
                )
                
                LegendItem(
                    color: AppColors.cardBackground,
                    title: "Remaining",
                    count: remaining
                )
            }
        }
    }
}

struct LegendItem: View {
    let color: Color
    let title: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.appCaption)
                    .foregroundColor(AppColors.secondaryText)
                
                Text("\(count)")
                    .font(.appBody)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
}

#Preview {
    StatisticsView(viewModel: ListViewModel())
}
