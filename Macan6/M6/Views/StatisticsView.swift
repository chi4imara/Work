import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = TestsViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        overviewSection
                        
                        categoryBreakdownSection
                        
                        ratingDistributionSection
                        
                        statusBreakdownSection
                        
                        monthlyActivitySection                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Total Tests",
                    value: "\(viewModel.tests.count)",
                    icon: "list.bullet.clipboard",
                    color: AppColors.yellow
                )
                
                StatCard(
                    title: "Recommended",
                    value: "\(recommendedCount)",
                    icon: "checkmark.circle.fill",
                    color: AppColors.success
                )
                
                StatCard(
                    title: "Categories",
                    value: "\(activeCategoriesCount)",
                    icon: "square.grid.2x2",
                    color: AppColors.info
                )
                
                StatCard(
                    title: "This Month",
                    value: "\(thisMonthCount)",
                    icon: "calendar",
                    color: AppColors.warning
                )
            }
        }
    }
    
    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryStatRow(
                        category: category,
                        count: categoryCount(category),
                        percentage: categoryPercentage(category)
                    )
                }
            }
            .cardStyle()
        }
    }
    
    private var ratingDistributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rating Distribution")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(1...5, id: \.self) { rating in
                    RatingStatRow(
                        rating: rating,
                        count: ratingCount(rating),
                        percentage: ratingPercentage(rating)
                    )
                }
            }
            .cardStyle()
        }
    }
    
    private var statusBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status Breakdown")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(TestStatus.allCases, id: \.self) { status in
                    StatusStatRow(
                        status: status,
                        count: statusCount(status),
                        percentage: statusPercentage(status)
                    )
                }
            }
            .cardStyle()
        }
    }
    
    private var monthlyActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Activity")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            if monthlyData.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.yellow.opacity(0.6))
                    
                    Text("No activity data yet")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .cardStyle()
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(monthlyData.enumerated()), id: \.offset) { index, data in
                        MonthlyActivityRow(month: data.month, count: data.count)
                        
                        if index < monthlyData.count - 1 {
                            Divider()
                                .background(AppColors.gridColor)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .cardStyle()
            }
        }
    }
    
    private var recommendedCount: Int {
        viewModel.tests.filter { $0.status == .recommend }.count
    }
    
    private var activeCategoriesCount: Int {
        Set(viewModel.tests.map { $0.category }).count
    }
    
    private var thisMonthCount: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.tests.filter { test in
            calendar.isDate(test.testDate, equalTo: now, toGranularity: .month)
        }.count
    }
    
    private func categoryCount(_ category: Category) -> Int {
        viewModel.tests.filter { $0.category == category }.count
    }
    
    private func categoryPercentage(_ category: Category) -> Double {
        guard !viewModel.tests.isEmpty else { return 0 }
        return Double(categoryCount(category)) / Double(viewModel.tests.count) * 100
    }
    
    private func ratingCount(_ rating: Int) -> Int {
        viewModel.tests.filter { $0.rating == rating }.count
    }
    
    private func ratingPercentage(_ rating: Int) -> Double {
        guard !viewModel.tests.isEmpty else { return 0 }
        return Double(ratingCount(rating)) / Double(viewModel.tests.count) * 100
    }
    
    private func statusCount(_ status: TestStatus) -> Int {
        viewModel.tests.filter { $0.status == status }.count
    }
    
    private func statusPercentage(_ status: TestStatus) -> Double {
        guard !viewModel.tests.isEmpty else { return 0 }
        return Double(statusCount(status)) / Double(viewModel.tests.count) * 100
    }
    
    private var monthlyData: [(month: String, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.tests) { (test: TestModel) -> Int in
            calendar.component(.month, from: test.testDate)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let mapped: [(String, Int)] = grouped.map { (month: Int, tests: [TestModel]) -> (String, Int) in
            let date = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: month)) ?? Date()
            return (formatter.string(from: date), tests.count)
        }
        
        let sorted = mapped.sorted { (first: (String, Int), second: (String, Int)) -> Bool in
            first.0 > second.0
        }
        
        return Array(sorted.prefix(6))
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
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cardStyle()
    }
}

struct CategoryStatRow: View {
    let category: Category
    let count: Int
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: categoryIcon(for: category))
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.yellow)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.displayName)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) test\(count == 1 ? "" : "s")")
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text("\(Int(percentage))%")
                .font(.playfairDisplay(16, weight: .bold))
                .foregroundColor(AppColors.yellow)
        }
        .padding(16)
    }
    
    private func categoryIcon(for category: Category) -> String {
        switch category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .hair:
            return "scissors"
        case .body:
            return "figure.walk"
        case .fragrance:
            return "aqi.medium"
        }
    }
}

struct RatingStatRow: View {
    let rating: Int
    let count: Int
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.system(size: 14))
                        .foregroundColor(star <= rating ? AppColors.yellow : AppColors.secondaryText)
                }
            }
            .frame(width: 80)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(rating) star\(rating == 1 ? "" : "s")")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) test\(count == 1 ? "" : "s")")
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text("\(Int(percentage))%")
                .font(.playfairDisplay(16, weight: .bold))
                .foregroundColor(AppColors.yellow)
        }
        .padding(16)
    }
}

struct StatusStatRow: View {
    let status: TestStatus
    let count: Int
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: status.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(statusColor(for: status))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(status.displayName)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) test\(count == 1 ? "" : "s")")
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text("\(Int(percentage))%")
                .font(.playfairDisplay(16, weight: .bold))
                .foregroundColor(statusColor(for: status))
        }
        .padding(16)
    }
    
    private func statusColor(for status: TestStatus) -> Color {
        switch status {
        case .recommend:
            return AppColors.success
        case .notSuitable:
            return AppColors.error
        case .testing:
            return AppColors.warning
        }
    }
}

struct MonthlyActivityRow: View {
    let month: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "calendar")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.yellow)
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(month)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) test\(count == 1 ? "" : "s") added")
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    StatisticsView()
}
