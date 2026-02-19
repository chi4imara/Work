import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel

    var body: some View {
        ZStack {
            AppColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color.primaryYellow)
                        
                        Text("Statistics")
                            .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(Color.textPrimary)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        StatisticsCardView(
                            icon: "tshirt.fill",
                            title: "Total Items",
                            value: "\(viewModel.items.count)",
                            color: Color.primaryYellow
                        )
                        
                        StatisticsCardView(
                            icon: "checkmark.circle.fill",
                            title: "Purchased",
                            value: "\(viewModel.purchasedItems.count)",
                            color: Color.secondaryGreen
                        )
                        
                        StatisticsCardView(
                            icon: "cart.fill",
                            title: "To Buy",
                            value: "\(viewModel.items.filter { !$0.isPurchased }.count)",
                            color: Color.accentRed
                        )
                        
                        StatisticsCardView(
                            icon: "folder.fill",
                            title: "Categories",
                            value: "\(viewModel.categories.count)",
                            color: Color.secondaryBlue
                        )
                    }
                    
                    if !viewModel.categories.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Items by Category")
                                .font(FontManager.playfairDisplay(size: 20, weight: .bold))
                                .foregroundColor(Color.textPrimary)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.categories) { category in
                                CategoryStatsRowView(category: category, totalItems: viewModel.items.count)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
        }
    }
}

struct StatisticsCardView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(Color.textSecondary)
                
                Text(value)
                    .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(Color.textPrimary)
            }
            
            Spacer()
        }
        .padding()
        .background(AppColorScheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

struct CategoryStatsRowView: View {
    let category: Category
    let totalItems: Int
    
    var percentage: Double {
        guard totalItems > 0 else { return 0 }
        return Double(category.itemCount) / Double(totalItems) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.name)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Text("\(category.itemCount)")
                    .font(FontManager.playfairDisplay(size: 18, weight: .bold))
                    .foregroundColor(Color.primaryYellow)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.cardBackground)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Color.primaryYellow)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text(String(format: "%.0f%%", percentage))
                .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                .foregroundColor(Color.textSecondary)
        }
        .padding()
        .background(AppColorScheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    StatisticsView()
}

