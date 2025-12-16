import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var toolsViewModel: ToolsViewModel
    @EnvironmentObject var notesViewModel: NotesViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            statisticsContent
        }
        .background(ColorManager.backgroundGradient)
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                overviewCards
                
                toolsStatistics
                
                categoryBreakdown
                
                conditionOverview
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100) 
        }
    }
    
    private var overviewCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Tools",
                    value: "\(toolsViewModel.tools.count)",
                    icon: "paintbrush.pointed.fill",
                    color: ColorManager.primaryText
                )
                
                StatCard(
                    title: "Total Notes",
                    value: "\(notesViewModel.notes.count)",
                    icon: "note.text",
                    color: ColorManager.accentYellow
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Good Condition",
                    value: "\(toolsViewModel.toolsInGoodCondition.count)",
                    icon: "checkmark.circle.fill",
                    color: ColorManager.statusGood
                )
                
                StatCard(
                    title: "Need Replacement",
                    value: "\(toolsViewModel.toolsNeedingReplacement.count)",
                    icon: "exclamationmark.triangle.fill",
                    color: ColorManager.statusBad
                )
            }
        }
    }
    
    private var toolsStatistics: some View {
        StatisticsSection(title: "Tools Overview") {
            VStack(spacing: 12) {
                StatRow(
                    title: "Total Tools",
                    value: "\(toolsViewModel.tools.count)",
                    icon: "paintbrush.pointed.fill"
                )
                
                Divider()
                    .background(ColorManager.secondaryText.opacity(0.3))
                
                StatRow(
                    title: "Average Age",
                    value: averageAgeText,
                    icon: "calendar"
                )
                
                Divider()
                    .background(ColorManager.secondaryText.opacity(0.3))
                
                StatRow(
                    title: "Oldest Tool",
                    value: oldestToolAge,
                    icon: "clock"
                )
            }
            .padding(.vertical, 8)
        }
    }
    
    private var categoryBreakdown: some View {
        StatisticsSection(title: "By Category") {
            VStack(spacing: 12) {
                ForEach(ToolCategory.allCases) { category in
                    let count = toolsViewModel.tools.filter { $0.category == category }.count
                    if count > 0 {
                        CategoryStatRow(
                            category: category,
                            count: count,
                            total: toolsViewModel.tools.count
                        )
                        
                        if category != ToolCategory.allCases.last {
                            Divider()
                                .background(ColorManager.secondaryText.opacity(0.3))
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var conditionOverview: some View {
        StatisticsSection(title: "Condition Overview") {
            VStack(spacing: 16) {
                ConditionStatBar(
                    condition: .good,
                    count: toolsViewModel.toolsInGoodCondition.count,
                    total: toolsViewModel.tools.count,
                    color: ColorManager.statusGood
                )
                
                ConditionStatBar(
                    condition: .worn,
                    count: toolsViewModel.tools.filter { $0.actualCondition == .worn }.count,
                    total: toolsViewModel.tools.count,
                    color: ColorManager.statusWorn
                )
                
                ConditionStatBar(
                    condition: .needsReplacement,
                    count: toolsViewModel.toolsNeedingReplacement.count,
                    total: toolsViewModel.tools.count,
                    color: ColorManager.statusBad
                )
            }
            .padding(.vertical, 8)
        }
    }
    
    private var averageAgeText: String {
        guard !toolsViewModel.tools.isEmpty else { return "N/A" }
        let totalDays = toolsViewModel.tools.reduce(0) { sum, tool in
            let days = Calendar.current.dateComponents([.day], from: tool.purchaseDate, to: Date()).day ?? 0
            return sum + days
        }
        let averageDays = totalDays / toolsViewModel.tools.count
        if averageDays < 30 {
            return "\(averageDays) days"
        } else if averageDays < 365 {
            return "\(averageDays / 30) months"
        } else {
            return "\(averageDays / 365) years"
        }
    }
    
    private var oldestToolAge: String {
        guard let oldest = toolsViewModel.toolsSortedByDate.first else { return "N/A" }
        let days = Calendar.current.dateComponents([.day], from: oldest.purchaseDate, to: Date()).day ?? 0
        if days < 30 {
            return "\(days) days"
        } else if days < 365 {
            return "\(days / 30) months"
        } else {
            return "\(days / 365) years"
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
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Text(title)
                .font(.playfairDisplay(14))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.shadowColor, radius: 8, x: 0, y: 4)
        )
    }
}

struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
                .frame(width: 24)
            
            Text(title)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

struct CategoryStatRow: View {
    let category: ToolCategory
    let count: Int
    let total: Int
    
    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int((Double(count) / Double(total)) * 100)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconForCategory(category))
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
                .frame(width: 24)
            
            Text(category.displayName)
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(count)")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("(\(percentage)%)")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorManager.secondaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    private func iconForCategory(_ category: ToolCategory) -> String {
        switch category {
        case .brushes: return "paintbrush.pointed.fill"
        case .sponges: return "circle.fill"
        case .curlers: return "waveform"
        case .tweezers: return "scissors"
        case .other: return "wrench.and.screwdriver.fill"
        }
    }
}

struct ConditionStatBar: View {
    let condition: ToolCondition
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(count) / CGFloat(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                
                Text(condition.displayName)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorManager.secondaryText.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

struct StatisticsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 4)
            
            content
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorManager.cardGradient)
                        .shadow(color: ColorManager.shadowColor, radius: 8, x: 0, y: 4)
                )
        }
    }
}
