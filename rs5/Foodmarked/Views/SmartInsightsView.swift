import SwiftUI

struct SmartInsightsView: View {
    @EnvironmentObject var productStore: ProductStore
    
    var insights: [Insight] {
        var result: [Insight] = []
        
        let total = productStore.products.count
        let suitable = productStore.suitableProducts.count
        let unsuitable = productStore.unsuitableProducts.count
        let favorites = productStore.favoriteProducts.count
        
        if total > 5 {
            let suitablePercentage = Double(suitable) / Double(total) * 100
            if suitablePercentage > 70 {
                result.append(Insight(
                    icon: "✅",
                    title: "Great Balance!",
                    description: "You have \(Int(suitablePercentage))% suitable products. Keep up the healthy choices!",
                    color: ColorManager.suitableGreen,
                    type: .positive
                ))
            } else if suitablePercentage < 30 {
                result.append(Insight(
                    icon: "⚠️",
                    title: "Consider More Options",
                    description: "Only \(Int(suitablePercentage))% of your products are suitable. Try exploring healthier alternatives.",
                    color: ColorManager.unsuitableRed,
                    type: .suggestion
                ))
            }
        }
        
        let categories = Set(productStore.products.map { $0.category })
        if categories.count >= 6 {
            result.append(Insight(
                icon: "🗺️",
                title: "Category Explorer",
                description: "You've explored \(categories.count) different categories! Great variety in your choices.",
                color: ColorManager.primaryBlue,
                type: .positive
            ))
        } else if total > 10 && categories.count < 4 {
            result.append(Insight(
                icon: "💡",
                title: "Try New Categories",
                description: "You have products from \(categories.count) categories. Explore more variety!",
                color: ColorManager.primaryYellow,
                type: .suggestion
            ))
        }
        
        if favorites >= 10 {
            result.append(Insight(
                icon: "⭐",
                title: "Favorite Collector",
                description: "You have \(favorites) favorite products! You're building a great personal collection.",
                color: ColorManager.primaryYellow,
                type: .positive
            ))
        }
        
        if total >= 20 {
            result.append(Insight(
                icon: "📈",
                title: "Growing Collection",
                description: "You're tracking \(total) products! Your list is growing steadily.",
                color: ColorManager.primaryBlue,
                type: .positive
            ))
        }
        
        let recentProducts = productStore.products.filter { 
            Calendar.current.isDateInToday($0.dateAdded) || 
            Calendar.current.isDateInYesterday($0.dateAdded)
        }
        if recentProducts.count > 0 {
            result.append(Insight(
                icon: "🆕",
                title: "Active User",
                description: "You've added \(recentProducts.count) product(s) recently. Keep tracking!",
                color: ColorManager.suitableGreen,
                type: .positive
            ))
        }
        
        return result
    }
    
    var body: some View {
        if !insights.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("💡 Smart Insights")
                        .font(.playfairDisplay(size: 20, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    ForEach(insights) { insight in
                        InsightCard(insight: insight)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
                    .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
}

struct Insight: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let color: Color
    let type: InsightType
    
    enum InsightType {
        case positive
        case suggestion
        case warning
    }
}

struct InsightCard: View {
    let insight: Insight
    
    var body: some View {
        HStack(spacing: 12) {
            Text(insight.icon)
                .font(.system(size: 28))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.playfairDisplay(size: 15, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(insight.description)
                    .font(.playfairDisplay(size: 13, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(insight.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(insight.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}
