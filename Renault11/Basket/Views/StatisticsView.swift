import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    
    private var totalSpent: Double {
        viewModel.completedPurchases().reduce(0) { $0 + ($1.actualAmount ?? $1.plannedAmount) }
    }
    
    private var totalPlanned: Double {
        viewModel.purchases.reduce(0) { $0 + $1.plannedAmount }
    }
    
    private var completedCount: Int {
        viewModel.completedPurchases().count
    }
    
    private var pendingCount: Int {
        viewModel.pendingPurchases().count
    }
    
    private var categoryBreakdown: [(PurchaseCategory, Double, Int)] {
        let completed = viewModel.completedPurchases()
        let grouped = Dictionary(grouping: completed, by: { $0.category })
        return PurchaseCategory.allCases.compactMap { category in
            let list = grouped[category] ?? []
            let total = list.reduce(0) { $0 + ($1.actualAmount ?? $1.plannedAmount) }
            return total > 0 ? (category, total, list.count) : nil
        }.sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Statistics")
                            .font(FontManager.playfairBold(size: 28))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        Text("Your shopping overview")
                            .font(FontManager.playfairRegular(size: 16))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                    }
                    .padding(.top, 10)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            StatisticCard(
                                title: "Total Spent",
                                value: String(format: "$%.0f", totalSpent),
                                icon: "dollarsign.circle.fill"
                            )
                            StatisticCard(
                                title: "Total Planned",
                                value: String(format: "$%.0f", totalPlanned),
                                icon: "list.bullet.clipboard"
                            )
                        }
                        
                        HStack(spacing: 16) {
                            StatisticCard(
                                title: "Completed",
                                value: "\(completedCount)",
                                icon: "checkmark.circle.fill"
                            )
                            StatisticCard(
                                title: "Pending",
                                value: "\(pendingCount)",
                                icon: "clock.fill"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if !categoryBreakdown.isEmpty {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Spending by Category")
                                    .font(FontManager.playfairBold(size: 18))
                                    .foregroundColor(Color.theme.primaryWhite)
                                Spacer()
                            }
                            
                            VStack(spacing: 8) {
                                ForEach(categoryBreakdown, id: \.0) { category, total, count in
                                    HStack {
                                        Image(systemName: category.icon)
                                            .foregroundColor(Color.theme.primaryYellow)
                                            .frame(width: 24)
                                        
                                        Text(category.rawValue)
                                            .font(FontManager.playfairRegular(size: 14))
                                            .foregroundColor(Color.theme.primaryWhite)
                                        
                                        Spacer()
                                        
                                        Text("\(count) items")
                                            .font(FontManager.playfairRegular(size: 12))
                                            .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                                        
                                        Text(String(format: "$%.0f", total))
                                            .font(FontManager.playfairSemiBold(size: 14))
                                            .foregroundColor(Color.theme.primaryYellow)
                                    }
                                    .padding()
                                    .background(Color.theme.cardGradient)
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    if totalSpent > 0 {
                        BudgetProgressSection(
                            spent: totalSpent,
                            limit: viewModel.dailyBudget.limit
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(Color.theme.primaryYellow)
            
            Text(value)
                .font(FontManager.playfairBold(size: 22))
                .foregroundColor(Color.theme.primaryWhite)
            
            Text(title)
                .font(FontManager.playfairRegular(size: 12))
                .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct BudgetProgressSection: View {
    let spent: Double
    let limit: Double
    
    private var progress: Double {
        limit > 0 ? min(1, spent / limit) : 0
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Budget Usage")
                    .font(FontManager.playfairBold(size: 18))
                    .foregroundColor(Color.theme.primaryWhite)
                Spacer()
            }
            
            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.theme.primaryWhite.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.theme.primaryYellow)
                            .frame(width: geometry.size.width * progress, height: 8)
                    }
                }
                .frame(height: 8)
                
                HStack {
                    Text(String(format: "$%.0f of $%.0f", spent, limit))
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(FontManager.playfairSemiBold(size: 12))
                        .foregroundColor(Color.theme.primaryYellow)
                }
            }
            .padding(16)
            .background(Color.theme.cardGradient)
            .cornerRadius(12)
        }
    }
}

#Preview {
    StatisticsView(viewModel: PurchaseViewModel())
}
