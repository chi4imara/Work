import SwiftUI

struct SimpleBarChart: View {
    let data: [ChartDataPoint]
    
    private var maxValue: Int {
        data.map(\.count).max() ?? 1
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, dataPoint in
                    VStack(spacing: AppSpacing.xs) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(AppColors.primaryOrange)
                            .frame(
                                width: max(20, (UIScreen.main.bounds.width - 80) / CGFloat(data.count) - 4),
                                height: max(4, CGFloat(dataPoint.count) / CGFloat(maxValue) * 120)
                            )
                            .animation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1), value: dataPoint.count)
                        
                        Text(dateFormatter.string(from: dataPoint.date))
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                            .rotationEffect(.degrees(-45))
                            .frame(width: 40, height: 20)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Text("0")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                Text("\(maxValue)")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
}

#Preview {
    SimpleBarChart(data: [
        ChartDataPoint(date: Date(), count: 3),
        ChartDataPoint(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), count: 1),
        ChartDataPoint(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), count: 5)
    ])
    .padding()
    .background(AppColors.backgroundGradient)
}
