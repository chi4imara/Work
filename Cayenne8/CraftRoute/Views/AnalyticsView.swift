import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var viewModel: ProjectsViewModel
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Analytics")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.projects.isEmpty {
                    EmptyAnalyticsView()
                } else {
                    AnalyticsContentView(viewModel: viewModel)
                }
            }
        }
    }
}

struct EmptyAnalyticsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            VStack(spacing: 8) {
                Text("No data to analyze")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Add some projects to see analytics")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AnalyticsContentView: View {
    @ObservedObject var viewModel: ProjectsViewModel
    
    private var categoryStats: [(category: ProjectCategory, count: Int)] {
        let grouped = Dictionary(grouping: viewModel.projects) { $0.category }
        return grouped.map { (category: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }
    
    private var mostUsedTools: [Tool] {
        Array(viewModel.allTools.prefix(5))
    }
    
    private var mostUsedMaterials: [Material] {
        Array(viewModel.allMaterials.prefix(5))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("Overview")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            title: "Total Projects",
                            value: "\(viewModel.projects.count)",
                            icon: "folder.fill",
                            color: ColorManager.accentBlue
                        )
                        
                        StatCard(
                            title: "Unique Tools",
                            value: "\(viewModel.allTools.count)",
                            icon: "hammer.fill",
                            color: ColorManager.accentOrange
                        )
                        
                        StatCard(
                            title: "Materials Used",
                            value: "\(viewModel.allMaterials.count)",
                            icon: "cube.box.fill",
                            color: ColorManager.categoryColors["Garden"] ?? ColorManager.accentBlue
                        )
                        
                        StatCard(
                            title: "This Month",
                            value: "\(projectsThisMonth)",
                            icon: "calendar",
                            color: ColorManager.categoryColors["Repair"] ?? ColorManager.accentOrange
                        )
                    }
                }
                
                if !categoryStats.isEmpty {
                    VStack(spacing: 16) {
                        Text("Projects by Category")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 12) {
                            ForEach(categoryStats, id: \.category) { stat in
                                CategoryStatRow(
                                    category: stat.category,
                                    count: stat.count,
                                    total: viewModel.projects.count
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ColorManager.cardGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(ColorManager.separatorColor, lineWidth: 1)
                                )
                        )
                    }
                }
                
                if !mostUsedTools.isEmpty {
                    VStack(spacing: 16) {
                        Text("Most Used Tools")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 8) {
                            ForEach(mostUsedTools) { tool in
                                TopItemRow(
                                    name: tool.name,
                                    count: tool.projectCount,
                                    icon: "hammer.fill",
                                    color: ColorManager.accentOrange
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ColorManager.cardGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(ColorManager.separatorColor, lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 100)
        }
    }
    
    private var projectsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.projects.filter { project in
            calendar.isDate(project.date, equalTo: now, toGranularity: .month)
        }.count
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
                .foregroundColor(ColorManager.primaryText)
            
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorManager.separatorColor, lineWidth: 1)
                )
        )
    }
}

struct CategoryStatRow: View {
    let category: ProjectCategory
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(category.displayName)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Text("\(count)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.separatorColor)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.categoryColors[category.rawValue] ?? ColorManager.accentBlue)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(width: 60, height: 8)
        }
    }
}

struct TopItemRow: View {
    let name: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(name)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Text("\(count)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorManager.secondaryText)
        }
    }
}

#Preview {
    AnalyticsView(viewModel: ProjectsViewModel())
}
