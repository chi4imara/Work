import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: ModificationViewModel
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.modifications.isEmpty {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
            }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Statistics")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("Overview of your modifications")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No Statistics")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("Add modifications to see statistics.")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                overviewCards
                
                statusBreakdown
                
                categoryDistribution
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var overviewCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Mods",
                    value: "\(viewModel.modifications.count)",
                    icon: "wrench.and.screwdriver",
                    color: AppColors.primaryDarkBlue
                )
                
                StatCard(
                    title: "Total Budget",
                    value: "$\(Int(viewModel.totalBudget))",
                    icon: "dollarsign.circle.fill",
                    color: AppColors.accentGreen
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Completed",
                    value: "\(completedCount)",
                    icon: "checkmark.circle.fill",
                    color: AppColors.accentGreen
                )
                
                StatCard(
                    title: "In Progress",
                    value: "\(inProgressCount)",
                    icon: "arrow.triangle.2.circlepath",
                    color: AppColors.accentYellow
                )
            }
        }
    }
    
    private var statusBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status Breakdown")
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 12) {
                StatusStatRow(
                    status: .plan,
                    count: planCount,
                    total: viewModel.modifications.count
                )
                
                StatusStatRow(
                    status: .inProgress,
                    count: inProgressCount,
                    total: viewModel.modifications.count
                )
                
                StatusStatRow(
                    status: .completed,
                    count: completedCount,
                    total: viewModel.modifications.count
                )
            }
        }
    }
    
    private var categoryDistribution: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Distribution")
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 12) {
                ForEach(ModificationCategory.allCases) { category in
                    CategoryStatRow(
                        category: category,
                        count: categoryCount(for: category),
                        total: viewModel.modifications.count
                    )
                }
            }
        }
    }
    
    private var planCount: Int {
        viewModel.modifications.filter { $0.status == .plan }.count
    }
    
    private var inProgressCount: Int {
        viewModel.modifications.filter { $0.status == .inProgress }.count
    }
    
    private var completedCount: Int {
        viewModel.modifications.filter { $0.status == .completed }.count
    }
    
    private func categoryCount(for category: ModificationCategory) -> Int {
        viewModel.modifications.filter { $0.category == category }.count
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
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.title1)
                .foregroundColor(AppColors.cardText)
            
            Text(title)
                .font(FontManager.caption1)
                .foregroundColor(AppColors.cardText.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct StatusStatRow: View {
    let status: ModificationStatus
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? (Double(count) / Double(total)) * 100 : 0
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 12) {
                    Circle()
                        .fill(AppColors.statusColor(for: status))
                        .frame(width: 12, height: 12)
                    
                    Text(status.displayName)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.cardText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(count)")
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.cardText)
                    
                    Text("\(Int(percentage))%")
                        .font(FontManager.caption1)
                        .foregroundColor(AppColors.cardText.opacity(0.6))
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.cardText.opacity(0.1))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(AppColors.statusColor(for: status))
                        .frame(width: geometry.size.width * (percentage / 100), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct CategoryStatRow: View {
    let category: ModificationCategory
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? (Double(count) / Double(total)) * 100 : 0
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: categoryIcon(for: category))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.categoryColor(for: category))
                        .frame(width: 24)
                    
                    Text(category.displayName)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.cardText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(count)")
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.cardText)
                    
                    Text("\(Int(percentage))%")
                        .font(FontManager.caption1)
                        .foregroundColor(AppColors.cardText.opacity(0.6))
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.cardText.opacity(0.1))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(AppColors.categoryColor(for: category))
                        .frame(width: geometry.size.width * (percentage / 100), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func categoryIcon(for category: ModificationCategory) -> String {
        switch category {
        case .exterior:
            return "car.fill"
        case .technical:
            return "wrench.and.screwdriver.fill"
        case .interior:
            return "carseat.right.fill"
        case .electrical:
            return "bolt.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(ModificationViewModel())
}
