import SwiftUI

struct SearchView: View {
    @ObservedObject var toolsViewModel: ToolsViewModel
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case mechanical = "Mechanical"
        case woodworking = "Woodworking"
        case electrical = "Electrical"
        case new = "New"
        case working = "Working"
        case needsRepair = "Needs Repair"
    }
    
    var filteredTools: [Tool] {
        var tools = toolsViewModel.tools
        
        if !searchText.isEmpty {
            tools = toolsViewModel.searchTools(query: searchText)
        }
        
        if selectedFilter != .all {
            switch selectedFilter {
            case .mechanical:
                tools = tools.filter { $0.type.lowercased().contains("mechanical") || $0.type.lowercased().contains("mechanic") }
            case .woodworking:
                tools = tools.filter { $0.type.lowercased().contains("wood") || $0.type.lowercased().contains("timber") }
            case .electrical:
                tools = tools.filter { $0.type.lowercased().contains("electrical") || $0.type.lowercased().contains("electric") }
            case .new:
                tools = tools.filter { $0.condition.lowercased().contains("new") }
            case .working:
                tools = tools.filter { $0.condition.lowercased().contains("working") || $0.condition.lowercased().contains("good") }
            case .needsRepair:
                tools = tools.filter { $0.condition.lowercased().contains("repair") || $0.condition.lowercased().contains("broken") }
            case .all:
                break
            }
        }
        
        return tools
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Search Tools")
                    .font(.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(.appWhite)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                
                SearchBar(text: $searchText)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(FilterOption.allCases, id: \.self) { filter in
                            FilterChip(
                                title: filter.rawValue,
                                isSelected: selectedFilter == filter,
                                action: { selectedFilter = filter }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)
                
                if filteredTools.isEmpty {
                    SearchEmptyStateView(hasSearchText: !searchText.isEmpty)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTools) { tool in
                                NavigationLink(destination: ToolDetailView(tool: tool, toolsViewModel: toolsViewModel)) {
                                    SearchResultRowView(tool: tool, searchText: searchText)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .appWhite : .appMediumGray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AppColors.buttonGradient : AppColors.cardGradient
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.lightBlue.opacity(isSelected ? 0.0 : 0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SearchResultRowView: View {
    let tool: Tool
    let searchText: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.buttonGradient)
                    .frame(width: 50, height: 50)
                
                Image(systemName: toolIcon(for: tool.type))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.appWhite)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(highlightedText(tool.name, searchText: searchText))
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(.appWhite)
                    .lineLimit(1)
                
                HStack {
                    Text(tool.type)
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(.appLightBlue)
                        .lineLimit(2)
                    
                    Text("•")
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(.appMediumGray)
                    
                    Text(tool.condition)
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(conditionColor(tool.condition))
                        .lineLimit(2)
                }
                
                if !tool.comment.isEmpty && tool.comment.localizedCaseInsensitiveContains(searchText) && !searchText.isEmpty {
                    Text(tool.comment)
                        .font(.playfairDisplay(size: 12, weight: .regular))
                        .foregroundColor(.appSoftGray)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.appLightBlue)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.lightBlue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func toolIcon(for type: String) -> String {
        switch type.lowercased() {
        case let t where t.contains("mechanical") || t.contains("mechanic"):
            return "wrench.and.screwdriver"
        case let t where t.contains("wood") || t.contains("timber"):
            return "hammer"
        case let t where t.contains("electrical") || t.contains("electric"):
            return "bolt"
        default:
            return "wrench.and.screwdriver"
        }
    }
    
    private func conditionColor(_ condition: String) -> Color {
        switch condition.lowercased() {
        case let c where c.contains("new"):
            return .appSoftGreen
        case let c where c.contains("working") || c.contains("good"):
            return .appLightBlue
        case let c where c.contains("repair") || c.contains("broken"):
            return .appOrange
        default:
            return .appMediumGray
        }
    }
    
    private func highlightedText(_ text: String, searchText: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        if !searchText.isEmpty {
            let range = text.range(of: searchText, options: .caseInsensitive)
            if let range = range {
                let nsRange = NSRange(range, in: text)
                if let attributedRange = Range(nsRange, in: attributedString) {
                    attributedString[attributedRange].foregroundColor = .appOrange
                }
            }
        }
        
        return attributedString
    }
}

struct SearchEmptyStateView: View {
    let hasSearchText: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: hasSearchText ? "magnifyingglass" : "magnifyingglass.circle")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.appMediumGray)
            }
            
            VStack(spacing: 8) {
                Text(hasSearchText ? "No Results" : "Start Searching")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(.appWhite)
                
                Text(hasSearchText ? "No tools match your search criteria." : "Enter a search term to find your tools.")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(.appMediumGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    SearchView(toolsViewModel: ToolsViewModel())
}
