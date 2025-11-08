import SwiftUI

struct PieChartView: View {
    let importantCount: Int
    let totalCount: Int
    
    private var importantPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(importantCount) / Double(totalCount)
    }
    
    private var regularPercentage: Double {
        return 1.0 - importantPercentage
    }
    
    var body: some View {
        HStack(spacing: 30) {
            ZStack {
                Circle()
                    .trim(from: 0, to: regularPercentage)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 30, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .trim(from: regularPercentage, to: 1.0)
                    .stroke(
                        AppColors.importantStar,
                        style: StrokeStyle(lineWidth: 30, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(totalCount)")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Total")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .frame(width: 120, height: 120)
            
            VStack(alignment: .leading, spacing: 12) {
                LegendItem(
                    color: AppColors.importantStar,
                    title: "Important",
                    count: importantCount,
                    percentage: importantPercentage
                )
                
                LegendItem(
                    color: Color.blue,
                    title: "Regular",
                    count: totalCount - importantCount,
                    percentage: regularPercentage
                )
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct LegendItem: View {
    let color: Color
    let title: String
    let count: Int
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) (\(Int(percentage * 100))%)")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    PieChartView(importantCount: 3, totalCount: 10)
        .padding()
        .background(AppColors.backgroundGradientStart)
}
