import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: ShoesViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if viewModel.shoes.isEmpty {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("No statistics available")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("Add some shoes to see your collection statistics")
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var statisticsContent: some View {
        VStack(spacing: 20) {
            StatCard(
                title: "Total Shoes",
                value: "\(viewModel.shoes.count)",
                icon: "shoe.2.fill",
                color: ColorTheme.lightBlue
            )
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("By Category")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 20)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(ShoeCategory.allCases, id: \.self) { category in
                        let count = viewModel.getCategoryCount(category)
                        if count > 0 {
                            StatCard(
                                title: category.displayName,
                                value: "\(count)",
                                icon: categoryIcon(category),
                                color: ColorTheme.orange
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("By Condition")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 20)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(ShoeCondition.allCases, id: \.self) { condition in
                        let count = viewModel.getConditionCount(condition)
                        if count > 0 {
                            StatCard(
                                title: condition.displayName,
                                value: "\(count)",
                                icon: conditionIcon(condition),
                                color: conditionColor(condition)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            if !recentPurchases.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Purchases")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 8) {
                        ForEach(recentPurchases.prefix(3), id: \.id) { shoe in
                            HStack {
                                Text(shoe.model)
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Spacer()
                                
                                Text(formattedDate(shoe.purchaseDate))
                                    .font(.ubuntu(14, weight: .regular))
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
    }
    
    private var recentPurchases: [Shoe] {
        viewModel.shoes.sorted { $0.purchaseDate > $1.purchaseDate }
    }
    
    private func categoryIcon(_ category: ShoeCategory) -> String {
        switch category {
        case .sneakers:
            return "shoe.2"
        case .boots:
            return "shoe"
        case .dress:
            return "shoe.2.fill"
        case .summer:
            return "sun.max"
        case .winter:
            return "snowflake"
        case .other:
            return "ellipsis"
        }
    }
    
    private func conditionIcon(_ condition: ShoeCondition) -> String {
        switch condition {
        case .excellent:
            return "star.fill"
        case .good:
            return "checkmark.circle.fill"
        case .average:
            return "minus.circle.fill"
        case .poor:
            return "xmark.circle.fill"
        }
    }
    
    private func conditionColor(_ condition: ShoeCondition) -> Color {
        switch condition {
        case .excellent:
            return ColorTheme.success
        case .good:
            return ColorTheme.lightBlue
        case .average:
            return ColorTheme.warning
        case .poor:
            return ColorTheme.error
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(ShoesViewModel())
}
