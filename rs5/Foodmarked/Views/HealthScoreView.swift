import SwiftUI

struct HealthScoreView: View {
    @EnvironmentObject var productStore: ProductStore
    
    var healthScore: HealthScore {
        calculateHealthScore()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🏥 Health Score")
                    .font(.playfairDisplay(size: 20, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
            }
            
            ZStack {
                Circle()
                    .stroke(healthScore.color.opacity(0.2), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(healthScore.score) / 100)
                    .stroke(healthScore.color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: healthScore.score)
                
                VStack(spacing: 4) {
                    Text("\(Int(healthScore.score))")
                        .font(.playfairDisplay(size: 36, weight: .bold))
                        .foregroundColor(healthScore.color)
                    
                    Text(healthScore.grade)
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            
            VStack(spacing: 12) {
                ScoreBreakdownRow(
                    label: "Suitable Products",
                    value: healthScore.suitablePercentage,
                    color: ColorManager.suitableGreen
                )
                
                ScoreBreakdownRow(
                    label: "Category Diversity",
                    value: healthScore.categoryDiversity,
                    color: ColorManager.primaryBlue
                )
                
                ScoreBreakdownRow(
                    label: "Active Tracking",
                    value: healthScore.activityScore,
                    color: ColorManager.primaryYellow
                )
            }
            
            if let recommendation = healthScore.recommendation {
                HStack(spacing: 12) {
                    Text("💡")
                        .font(.system(size: 20))
                    
                    Text(recommendation)
                        .font(.playfairDisplay(size: 13, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(healthScore.color.opacity(0.1))
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func calculateHealthScore() -> HealthScore {
        let total = productStore.products.count
        guard total > 0 else {
            return HealthScore(
                score: 0,
                grade: "N/A",
                color: ColorManager.secondaryText,
                suitablePercentage: 0,
                categoryDiversity: 0,
                activityScore: 0,
                recommendation: "Add products to calculate your health score"
            )
        }
        
        let suitable = productStore.suitableProducts.count
        let suitablePercentage = Double(suitable) / Double(total) * 100
        
        let categories = Set(productStore.products.map { $0.category })
        let categoryDiversity = min(Double(categories.count) / 8.0 * 100, 100)
        
        let recentProducts = productStore.products.filter {
            Calendar.current.dateComponents([.day], from: $0.dateAdded, to: Date()).day ?? 0 < 7
        }
        let activityScore = min(Double(recentProducts.count) / 10.0 * 100, 100)
        
        let score = (suitablePercentage * 0.5) + (categoryDiversity * 0.3) + (activityScore * 0.2)
        
        let grade: String
        let color: Color
        let recommendation: String?
        
        if score >= 80 {
            grade = "Excellent"
            color = ColorManager.suitableGreen
            recommendation = "Outstanding! You're making great choices. Keep it up!"
        } else if score >= 60 {
            grade = "Good"
            color = ColorManager.primaryBlue
            recommendation = "You're on the right track! Try adding more suitable products."
        } else if score >= 40 {
            grade = "Fair"
            color = ColorManager.primaryYellow
            recommendation = "Consider exploring more suitable alternatives in your categories."
        } else {
            grade = "Needs Improvement"
            color = ColorManager.unsuitableRed
            recommendation = "Try adding more suitable products and exploring different categories."
        }
        
        return HealthScore(
            score: score,
            grade: grade,
            color: color,
            suitablePercentage: suitablePercentage,
            categoryDiversity: categoryDiversity,
            activityScore: activityScore,
            recommendation: recommendation
        )
    }
}

struct HealthScore {
    let score: Double
    let grade: String
    let color: Color
    let suitablePercentage: Double
    let categoryDiversity: Double
    let activityScore: Double
    let recommendation: String?
}

struct ScoreBreakdownRow: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.playfairDisplay(size: 13, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Text(String(format: "%.0f%%", value))
                .font(.playfairDisplay(size: 13, weight: .semibold))
                .foregroundColor(color)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(value / 100), height: 6)
                }
            }
            .frame(width: 60, height: 6)
        }
    }
}
