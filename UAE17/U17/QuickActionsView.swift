import SwiftUI

struct QuickActionsView: View {
    @ObservedObject var viewModel: ToolsViewModel
    @Binding var selectedTab: TabItem
    @State private var showingAddTool = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Text("Quick Actions")
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        quickAddSection
                        
                        recentToolsSection
                        
                        quickStatsSection
                        
                        quickFiltersSection
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingAddTool) {
            AddToolView(viewModel: viewModel)
        }
    }
    
    private var quickAddSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add New Tool")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.theme.white)
                .padding(.horizontal, 20)
            
            Button(action: {
                showingAddTool = true
            }) {
                HStack(spacing: 16) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(Color.theme.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Add Tool to Catalog")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(Color.theme.white)
                        
                        Text("Quickly add a new tool to your collection")
                            .font(.playfairDisplay(14))
                            .foregroundColor(Color.theme.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.theme.white.opacity(0.5))
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardGradient)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 20)
        }
    }
    
    private var recentToolsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recently Used")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.theme.white)
                .padding(.horizontal, 20)
            
            if viewModel.usages.isEmpty {
                Text("No recent usage")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.theme.cardGradient)
                    )
                    .padding(.horizontal, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(viewModel.usages.suffix(5).reversed()), id: \.id) { usage in
                            if let tool = viewModel.tools.first(where: { $0.id == usage.toolId }) {
                                RecentToolCard(tool: tool, usage: usage, viewModel: viewModel)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.theme.white)
                .padding(.horizontal, 20)
            
            HStack(spacing: 12) {
                StatMiniCard(
                    title: "Total Tools",
                    value: "\(viewModel.tools.count)",
                    icon: "wrench.and.screwdriver",
                    color: Color.theme.lightBlue
                )
                
                StatMiniCard(
                    title: "Used Today",
                    value: "\(todayUsageCount)",
                    icon: "checkmark.circle",
                    color: Color.theme.green
                )
                
                StatMiniCard(
                    title: "Categories",
                    value: "\(activeCategoriesCount)",
                    icon: "tag",
                    color: Color.theme.orange
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var quickFiltersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Filters")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.theme.white)
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ToolCategory.allCases.prefix(4)) { category in
                    QuickFilterCard(
                        category: category,
                        count: viewModel.tools.filter { $0.category == category }.count,
                        viewModel: viewModel,
                        selectedTab: $selectedTab
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var todayUsageCount: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return viewModel.usages.filter { calendar.startOfDay(for: $0.date) == today }.count
    }
    
    private var activeCategoriesCount: Int {
        Set(viewModel.tools.map { $0.category }).count
    }
}

struct RecentToolCard: View {
    let tool: Tool
    let usage: Usage
    let viewModel: ToolsViewModel
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: iconForCategory(tool.category))
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color.theme.lightBlue)
                    
                    Spacer()
                    
                    Text(timeAgo(usage.date))
                        .font(.playfairDisplay(10, weight: .medium))
                        .foregroundColor(Color.theme.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.theme.orange.opacity(0.2))
                        )
                }
                
                Text(tool.name)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.white)
                    .lineLimit(2)
                
                Text(tool.category.displayName)
                    .font(.playfairDisplay(12))
                    .foregroundColor(Color.theme.white.opacity(0.7))
            }
            .padding(16)
            .frame(width: 160)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardGradient)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            ToolDetailView(tool: tool, viewModel: viewModel)
        }
    }
    
    private func iconForCategory(_ category: ToolCategory) -> String {
        switch category {
        case .manual:
            return "wrench"
        case .electric:
            return "bolt"
        case .measuring:
            return "ruler"
        case .automotive:
            return "car"
        case .other:
            return "questionmark"
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: date, to: now)
        
        if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "Just now"
        }
    }
}

struct StatMiniCard: View {
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
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(Color.theme.white)
            
            Text(title)
                .font(.playfairDisplay(12, weight: .medium))
                .foregroundColor(Color.theme.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
        )
    }
}

struct QuickFilterCard: View {
    let category: ToolCategory
    let count: Int
    let viewModel: ToolsViewModel
    @Binding var selectedTab: TabItem
    
    var body: some View {
        Button(action: {
            viewModel.selectedCategory = category
            selectedTab = .catalog
        }) {
            HStack(spacing: 12) {
                Image(systemName: iconForCategory(category))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color.theme.orange)
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(Color.theme.orange.opacity(0.2))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.playfairDisplay(13, weight: .semibold))
                        .foregroundColor(Color.theme.white)
                    
                    Text("\(count) tools")
                        .font(.playfairDisplay(12))
                        .foregroundColor(Color.theme.white.opacity(0.7))
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardGradient)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func iconForCategory(_ category: ToolCategory) -> String {
        switch category {
        case .manual:
            return "wrench"
        case .electric:
            return "bolt"
        case .measuring:
            return "ruler"
        case .automotive:
            return "car"
        case .other:
            return "questionmark"
        }
    }
}

#Preview {
    QuickActionsView(viewModel: ToolsViewModel(), selectedTab: .constant(.catalog))
}
