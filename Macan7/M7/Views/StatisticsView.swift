import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: PhotoshootViewModel
    
    private var totalScenarios: Int {
        viewModel.scenarios.count
    }
    
    private var plannedCount: Int {
        viewModel.scenarios.filter { $0.status == .planned }.count
    }
    
    private var completedCount: Int {
        viewModel.scenarios.filter { $0.status == .completed }.count
    }
    
    private var scenariosByCategory: [ScenarioCategory: Int] {
        Dictionary(grouping: viewModel.scenarios, by: { $0.category })
            .mapValues { $0.count }
    }
    
    var body: some View {
        ZStack {
            StaticBackground()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.appPrimaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        overviewCards
                        
                        statusBreakdown
                        
                        categoryBreakdown
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Your Photoshoot Statistics")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            Text("Track your creative progress")
                .font(.ubuntu(16))
                .foregroundColor(.appSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var overviewCards: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Total",
                value: "\(totalScenarios)",
                icon: "camera.fill",
                color: .appPrimary
            )
            
            StatCard(
                title: "Planned",
                value: "\(plannedCount)",
                icon: "circle.fill",
                color: .appPlanned
            )
            
            StatCard(
                title: "Completed",
                value: "\(completedCount)",
                icon: "checkmark.circle.fill",
                color: .appCompleted
            )
        }
    }
    
    private var statusBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status Breakdown")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            VStack(spacing: 12) {
                if totalScenarios > 0 {
                    StatusProgressBar(
                        title: "Planned",
                        count: plannedCount,
                        total: totalScenarios,
                        color: .appPlanned
                    )
                    
                    StatusProgressBar(
                        title: "Completed",
                        count: completedCount,
                        total: totalScenarios,
                        color: .appCompleted
                    )
                } else {
                    Text("No scenarios yet")
                        .font(.ubuntu(16))
                        .foregroundColor(.appSecondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            if scenariosByCategory.isEmpty {
                Text("No categories yet")
                    .font(.ubuntu(16))
                    .foregroundColor(.appSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(ScenarioCategory.allCases, id: \.self) { category in
                        if let count = scenariosByCategory[category], count > 0 {
                            CategoryStatRow(
                                category: category,
                                count: count,
                                total: totalScenarios
                            )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            Text(title)
                .font(.ubuntu(14))
                .foregroundColor(.appSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct StatusProgressBar: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: CGFloat {
        total > 0 ? CGFloat(count) / CGFloat(total) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
                
                Text("\(count) / \(total)")
                    .font(.ubuntu(14))
                    .foregroundColor(.appSecondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appLightGray)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

struct CategoryStatRow: View {
    let category: ScenarioCategory
    let count: Int
    let total: Int
    
    private var percentage: CGFloat {
        total > 0 ? CGFloat(count) / CGFloat(total) : 0
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 20))
                .foregroundColor(.appPrimary)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appPrimaryText)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.appLightGray)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.appPrimary)
                            .frame(width: geometry.size.width * percentage, height: 6)
                    }
                }
                .frame(height: 6)
            }
            
            Spacer()
            
            Text("\(count)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(.appPrimary)
                .frame(minWidth: 30, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView()
}
