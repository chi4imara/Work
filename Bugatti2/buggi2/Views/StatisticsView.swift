import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    
    private var totalItems: Int {
        inventoryViewModel.items.count
    }
    
    private var itemsByLocation: [(String, Int)] {
        let grouped = Dictionary(grouping: inventoryViewModel.items, by: { $0.location })
        return grouped.map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
    }
    
    private var itemsByOwner: [(String, Int)] {
        let grouped = Dictionary(grouping: inventoryViewModel.items, by: { $0.owner })
        return grouped.map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryTextWhite)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppColors.primaryYellow.opacity(0.3), AppColors.primaryBlue.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "archivebox.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(AppColors.primaryTextWhite)
                            }
                            
                            Text("\(totalItems)")
                                .font(.playfairDisplay(40, weight: .bold))
                                .foregroundColor(AppColors.primaryTextWhite)
                            
                            Text("Total items in inventory")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(AppColors.secondaryTextWhite)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardBackground)
                                .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                        )
                        .padding(.horizontal, 20)
                        
                        if !itemsByLocation.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 8) {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(AppColors.accentGreen)
                                    Text("By storage location")
                                        .font(.playfairDisplay(18, weight: .bold))
                                        .foregroundColor(AppColors.primaryTextWhite)
                                }
                                
                                StatisticsBarChartView(
                                    data: itemsByLocation.map { ($0.0, Double($0.1)) },
                                    maxValue: Double(itemsByLocation.map(\.1).max() ?? 1)
                                )
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        if !itemsByOwner.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 8) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(AppColors.primaryYellow)
                                    Text("By owner")
                                        .font(.playfairDisplay(18, weight: .bold))
                                        .foregroundColor(AppColors.primaryTextWhite)
                                }
                                
                                VStack(spacing: 12) {
                                    ForEach(itemsByOwner, id: \.0) { owner, count in
                                        HStack {
                                            Text(owner)
                                                .font(.playfairDisplay(16, weight: .medium))
                                                .foregroundColor(AppColors.secondaryTextWhite)
                                                .lineLimit(1)
                                            Spacer()
                                            Text("\(count)")
                                                .font(.playfairDisplay(16, weight: .semibold))
                                                .foregroundColor(AppColors.primaryTextWhite)
                                        }
                                        .padding(12)
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        if inventoryViewModel.items.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.system(size: 44))
                                    .foregroundColor(AppColors.primaryTextWhite.opacity(0.7))
                                Text("Add items to see statistics")
                                    .font(.playfairDisplay(16, weight: .medium))
                                    .foregroundColor(AppColors.secondaryTextWhite)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct StatisticsBarChartView: View {
    let data: [(String, Double)]
    let maxValue: Double
    
    private let barHeight: CGFloat = 22
    private let rowSpacing: CGFloat = 8
    private let rowVerticalPadding: CGFloat = 8
    
    private let barColors: [Color] = [
        AppColors.primaryBlue,
        AppColors.accentGreen,
        AppColors.primaryYellow,
        AppColors.softOrange,
        AppColors.accentPurple
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    let value = item.1
                    let widthRatio = maxValue > 0 ? value / maxValue : 0
                    let barWidth = availableWidth * CGFloat(widthRatio)
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.0)
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(AppColors.secondaryTextWhite)
                                .lineLimit(1)
                            Spacer()
                            Text("\(Int(value))")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(AppColors.primaryTextWhite)
                        }
                        RoundedRectangle(cornerRadius: 6)
                            .fill(barColors[index % barColors.count])
                            .frame(width: max(4, barWidth), height: barHeight)
                            .animation(.easeOut(duration: 0.4), value: barWidth)
                    }
                    .padding(.vertical, rowVerticalPadding)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: chartContentHeight)
    }
    
    private var chartContentHeight: CGFloat {
        guard !data.isEmpty else { return 0 }
        let labelHeight: CGFloat = 20
        let spacing: CGFloat = 6
        let rowHeight = labelHeight + spacing + barHeight + rowVerticalPadding * 2
        return CGFloat(data.count) * rowHeight
    }
}

#Preview {
    StatisticsView()
        .environmentObject(InventoryViewModel())
}
