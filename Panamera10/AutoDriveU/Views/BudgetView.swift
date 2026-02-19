import SwiftUI

struct BudgetView: View {
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
                    budgetContent
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Budget Overview")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("Total: $\(Int(viewModel.totalBudget))")
                    .font(FontManager.title3)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.9))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "dollarsign.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No Budget Data")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("Add modifications to see budget breakdown.")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
    
    private var budgetContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                totalBudgetCard
                
                if !viewModel.budgetByCategory.isEmpty {
                    categoryBudgetSection
                }
                
                modificationsListSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var totalBudgetCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Total Budget")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.cardText.opacity(0.7))
                
                Text("$\(Int(viewModel.totalBudget))")
                    .font(FontManager.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.cardText)
            }
            
            Divider()
                .background(AppColors.cardText.opacity(0.2))
            
            HStack(spacing: 20) {
                StatisticItem(
                    title: "Modifications",
                    value: "\(viewModel.modifications.count)",
                    icon: "wrench.and.screwdriver"
                )
                
                StatisticItem(
                    title: "Categories",
                    value: "\(viewModel.budgetByCategory.count)",
                    icon: "folder"
                )
                
                StatisticItem(
                    title: "Avg. Cost",
                    value: "$\(viewModel.modifications.isEmpty ? 0 : Int(viewModel.totalBudget / Double(viewModel.modifications.count)))",
                    icon: "chart.bar"
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var categoryBudgetSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Budget by Category")
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 12) {
                ForEach(Array(viewModel.budgetByCategory.keys.sorted(by: { viewModel.budgetByCategory[$0]! > viewModel.budgetByCategory[$1]! })), id: \.self) { category in
                    CategoryBudgetRow(
                        category: category,
                        amount: viewModel.budgetByCategory[category] ?? 0,
                        totalBudget: viewModel.totalBudget
                    )
                }
            }
        }
    }
    
    private var modificationsListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("All Modifications")
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 12) {
                ForEach(viewModel.modifications.sorted(by: { $0.budget > $1.budget })) { modification in
                    NavigationLink(destination: ModificationDetailView(modificationId: modification.id)
                        .environmentObject(viewModel)) {
                        BudgetModificationRow(modification: modification)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct StatisticItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.primaryDarkBlue)
            
            Text(value)
                .font(FontManager.headline)
                .foregroundColor(AppColors.cardText)
            
            Text(title)
                .font(FontManager.caption1)
                .foregroundColor(AppColors.cardText.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryBudgetRow: View {
    let category: ModificationCategory
    let amount: Double
    let totalBudget: Double
    
    private var percentage: Double {
        totalBudget > 0 ? (amount / totalBudget) * 100 : 0
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
                    Text("$\(Int(amount))")
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

struct BudgetModificationRow: View {
    let modification: Modification
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Circle()
                    .fill(AppColors.statusColor(for: modification.status))
                    .frame(width: 12, height: 12)
                
                Image(systemName: categoryIcon(for: modification.category))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.categoryColor(for: modification.category))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(modification.name)
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.cardText)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(modification.category.displayName)
                        .font(FontManager.caption2)
                        .foregroundColor(AppColors.categoryColor(for: modification.category))
                    
                    Text("•")
                        .font(FontManager.caption2)
                        .foregroundColor(AppColors.cardText.opacity(0.4))
                    
                    Text(modification.status.displayName)
                        .font(FontManager.caption2)
                        .foregroundColor(AppColors.statusColor(for: modification.status))
                }
            }
            
            Spacer()
            
            Text("$\(Int(modification.budget))")
                .font(FontManager.headline)
                .foregroundColor(AppColors.cardText)
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
    BudgetView()
        .environmentObject(ModificationViewModel())
}
