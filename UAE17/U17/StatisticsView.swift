import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: ToolsViewModel
    @State private var selectedPeriod: StatisticsPeriod = .month
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Text("Statistics")
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                if viewModel.tools.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    contentView
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.lightBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No Data Available")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(Color.theme.white)
                
                Text("Add some tools to see statistics")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                StatCard(
                    title: "Total Tools",
                    value: "\(viewModel.statistics.totalTools)",
                    icon: "wrench.and.screwdriver",
                    color: Color.theme.lightBlue
                )
                
                categoryBreakdownView
                
                if !viewModel.statistics.unusedTools.isEmpty {
                    unusedToolsView
                }
                
                usageChartView
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var categoryBreakdownView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tools by Category")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.theme.white)
            
            VStack(spacing: 12) {
                ForEach(ToolCategory.allCases) { category in
                    let count = viewModel.statistics.categoryStats[category] ?? 0
                    if count > 0 {
                        CategoryStatRow(
                            category: category,
                            count: count,
                            total: viewModel.statistics.totalTools
                        )
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardGradient)
            )
        }
    }
    
    private var unusedToolsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tools Not Used Recently")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.theme.white)
            
            Text("Not used in the last 60 days")
                .font(.playfairDisplay(14))
                .foregroundColor(Color.theme.white.opacity(0.7))
            
            VStack(spacing: 8) {
                ForEach(viewModel.statistics.unusedTools.prefix(5)) { tool in
                    HStack {
                        Text(tool.name)
                            .font(.playfairDisplay(16))
                            .foregroundColor(Color.theme.white)
                        
                        Spacer()
                        
                        Text(daysSinceUsed(tool.lastUsedDate))
                            .font(.playfairDisplay(14))
                            .foregroundColor(Color.theme.orange)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardGradient)
            )
        }
    }
    
    private var usageChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Usage Activity")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(Color.theme.white)
                
                Spacer()
                
                Menu {
                    ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                        Button(period.rawValue) {
                            selectedPeriod = period
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedPeriod.rawValue)
                            .font(.playfairDisplay(14, weight: .medium))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color.theme.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.theme.white.opacity(0.1))
                    )
                }
            }
            
            let usageData = viewModel.getUsageCount(for: selectedPeriod)
            if !usageData.isEmpty {
                SimpleChartView(data: usageData)
                    .frame(height: 200)
            } else {
                Text("No usage data for selected period")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.white.opacity(0.7))
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.theme.cardGradient)
                    )
            }
        }
    }
    
    private func daysSinceUsed(_ date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        return "\(days) days ago"
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.theme.white.opacity(0.8))
                
                Text(value)
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.white)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
        )
    }
}

struct CategoryStatRow: View {
    let category: ToolCategory
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        HStack {
            Text(category.displayName)
                .font(.playfairDisplay(16))
                .foregroundColor(Color.theme.white)
            
            Spacer()
            
            Text("\(count)")
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(Color.theme.orange)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.theme.white.opacity(0.2))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(Color.theme.lightBlue)
                        .frame(width: geometry.size.width * percentage, height: 4)
                }
            }
            .frame(width: 60, height: 4)
        }
    }
}

struct SimpleChartView: View {
    let data: [Date: Int]
    
    private var sortedData: [(Date, Int)] {
        data.sorted { $0.key < $1.key }
    }
    
    private var maxValue: Int {
        data.values.max() ?? 1
    }
    
    var body: some View {
        VStack {
            if sortedData.isEmpty {
                Text("No data available")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.white.opacity(0.7))
            } else {
                GeometryReader { geometry in
                    let barWidth = geometry.size.width / CGFloat(sortedData.count)
                    
                    HStack(alignment: .bottom, spacing: 2) {
                        ForEach(Array(sortedData.enumerated()), id: \.offset) { index, item in
                            let (date, count) = item
                            let height = geometry.size.height * (CGFloat(count) / CGFloat(maxValue))
                            
                            VStack(spacing: 4) {
                                Rectangle()
                                    .fill(Color.theme.lightBlue)
                                    .frame(width: max(barWidth - 4, 8), height: max(height, 4))
                                    .cornerRadius(2)
                                
                                Text("\(count)")
                                    .font(.playfairDisplay(10))
                                    .foregroundColor(Color.theme.white.opacity(0.8))
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
        )
    }
}

#Preview {
    StatisticsView(viewModel: ToolsViewModel())
}
