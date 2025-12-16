import SwiftUI

struct ScheduleCheckView: View {
    @EnvironmentObject var viewModel: ToolsViewModel
    @State private var selectedFilter: ScheduleFilter = .all
    
    enum ScheduleFilter: String, CaseIterable {
        case all = "All"
        case good = "Good"
        case needsReplacement = "Needs Replacement"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                
                filterView
                
                if filteredTools.isEmpty {
                    emptyStateView
                } else {
                    toolsListView
                }
            }
            .background(ColorManager.backgroundGradient)
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Schedule Check")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
            }
            
            Text("Tools sorted by purchase date")
                .font(.playfairDisplay(14))
                .foregroundColor(ColorManager.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ScheduleFilter.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.displayName,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
        .padding(.vertical, 16)
    }
    
    private var filteredTools: [Tool] {
        let sortedTools = viewModel.toolsSortedByDate
        
        switch selectedFilter {
        case .all:
            return sortedTools
        case .good:
            return sortedTools.filter { $0.actualCondition == .good }
        case .needsReplacement:
            return sortedTools.filter { $0.actualCondition == .needsReplacement }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(ColorManager.statusGood)
            
            VStack(spacing: 8) {
                Text("All tools are in good condition!")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Excellent care of your collection!")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var toolsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if !viewModel.toolsNeedingReplacement.isEmpty {
                    recommendationsSection
                }
                
                ForEach(filteredTools) { tool in
                    NavigationLink(destination: ToolDetailView(tool: tool).environmentObject(viewModel)) {
                        ScheduleToolCardView(tool: tool)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(ColorManager.accentYellow)
                
                Text("Recommendations")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
            }
            
            Text("Tools older than 12 months are recommended for replacement to maintain hygiene and performance.")
                .font(.playfairDisplay(14))
                .foregroundColor(ColorManager.secondaryText)
                .lineSpacing(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.accentYellow.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.accentYellow.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.bottom, 8)
    }
}

struct ScheduleToolCardView: View {
    let tool: Tool
    
    private var daysSincePurchase: Int {
        Calendar.current.dateComponents([.day], from: tool.purchaseDate, to: Date()).day ?? 0
    }
    
    private var monthsSincePurchase: Int {
        Calendar.current.dateComponents([.month], from: tool.purchaseDate, to: Date()).month ?? 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Circle()
                    .fill(tool.actualCondition.color)
                    .frame(width: 16, height: 16)
                
                Text("\(monthsSincePurchase)m")
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(1)
                
                Text(tool.category.displayName)
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorManager.secondaryText)
                
                HStack {
                    Text("Purchased: \(tool.purchaseDate, formatter: DateFormatter.shortDate)")
                        .font(.playfairDisplay(12))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        if tool.isOld {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                        }
                        
                        Text(tool.actualCondition.displayName)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(tool.actualCondition.color)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(daysSincePurchase)")
                    .font(.playfairDisplay(16, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("days")
                    .font(.playfairDisplay(10))
                    .foregroundColor(ColorManager.secondaryText)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(tool.isOld ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 2)
                )
                .shadow(color: ColorManager.shadowColor, radius: 8, x: 0, y: 4)
        )
    }
}
