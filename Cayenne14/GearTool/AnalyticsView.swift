import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var viewModel: ToolsViewModel
    
    var totalTools: Int {
        viewModel.tools.count
    }
    
    var totalUsageCount: Int {
        viewModel.tools.reduce(0) { $0 + $1.usageCount }
    }
    
    var toolsByCategory: [ToolCategory: Int] {
        Dictionary(grouping: viewModel.tools, by: { $0.category })
            .mapValues { $0.count }
    }
    
    var mostUsedTool: Tool? {
        viewModel.tools.max { $0.usageCount < $1.usageCount }
    }
    
    var unusedTools: [Tool] {
        viewModel.tools.filter { $0.usageDates.isEmpty }
    }
    
    var recentlyUsedTools: [Tool] {
        viewModel.tools
            .filter { $0.lastUsedDate != nil }
            .sorted { ($0.lastUsedDate ?? Date.distantPast) > ($1.lastUsedDate ?? Date.distantPast) }
            .prefix(5)
            .map { $0 }
    }
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            if viewModel.tools.isEmpty {
                VStack {
                    Text("Settings")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.top, 20)
                    
                    VStack {
                        Spacer()
                        Text("No analytics available.")
                            .font(.ubuntu(18))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 25) {
                        Text("Analytics")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.top, 20)
                        
                        HStack(spacing: 15) {
                            StatCard(
                                title: "Total Tools",
                                value: "\(totalTools)",
                                icon: "wrench.and.screwdriver",
                                color: AppColors.lightBlue
                            )
                            
                            StatCard(
                                title: "Total Usage",
                                value: "\(totalUsageCount)",
                                icon: "chart.bar.fill",
                                color: AppColors.orange
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Tools by Category")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            ForEach(ToolCategory.allCases) { category in
                                if let count = toolsByCategory[category], count > 0 {
                                    CategoryRow(category: category, count: count, total: totalTools)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        if let mostUsed = mostUsedTool, mostUsed.usageCount > 0 {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Most Used Tool")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                MostUsedCard(tool: mostUsed)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        if !unusedTools.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Unused Tools")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("\(unusedTools.count) tool\(unusedTools.count == 1 ? "" : "s") haven't been used yet")
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.secondaryText)
                                
                                ForEach(unusedTools.prefix(5)) { tool in
                                    UnusedToolRow(tool: tool)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        if !recentlyUsedTools.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Recently Used")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                ForEach(recentlyUsedTools) { tool in
                                    RecentlyUsedRow(tool: tool)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
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
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(15)
    }
}

struct CategoryRow: View {
    let category: ToolCategory
    let count: Int
    let total: Int
    
    var percentage: Double {
        Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.orange)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.buttonBackground)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(AppColors.lightBlue)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct MostUsedCard: View {
    let tool: Tool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(tool.name)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(tool.usageCount) usage\(tool.usageCount == 1 ? "" : "s")")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "star.fill")
                .font(.system(size: 30))
                .foregroundColor(AppColors.orange)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(15)
    }
}

struct UnusedToolRow: View {
    let tool: Tool
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 16))
                .foregroundColor(AppColors.warning)
            
            Text(tool.name)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(tool.category.rawValue)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct RecentlyUsedRow: View {
    let tool: Tool
    
    var daysSince: Int? {
        guard let lastUsed = tool.lastUsedDate else { return nil }
        return Calendar.current.dateComponents([.day], from: lastUsed, to: Date()).day
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                if let days = daysSince {
                    Text("\(days) day\(days == 1 ? "" : "s") ago")
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Text("\(tool.usageCount)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.lightBlue)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    AnalyticsView(viewModel: ToolsViewModel())
}
