import SwiftUI

struct CatalogView: View {
    @ObservedObject var toolsViewModel: ToolsViewModel
    @State private var searchText = ""
    
    var filteredTools: [Tool] {
        if searchText.isEmpty {
            return toolsViewModel.tools
        } else {
            return toolsViewModel.searchTools(query: searchText)
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("Tool Catalog")
                        .font(.playfairDisplay(size: 32, weight: .bold))
                        .foregroundColor(.appWhite)
                    
                    SearchBar(text: $searchText)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                if filteredTools.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTools) { tool in
                                NavigationLink(destination: ToolDetailView(tool: tool, toolsViewModel: toolsViewModel)) {
                                    ToolRowView(tool: tool)
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.appMediumGray)
            
            TextField("Search tools...", text: $text)
                .font(.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(.appWhite)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.appMediumGray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

struct ToolRowView: View {
    let tool: Tool
    
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
                Text(tool.name)
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
            }
            
            Spacer()
            
            HStack {
                Text("Open")
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(.appLightBlue)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.appLightBlue)
            }
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
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.appMediumGray)
            }
            
            VStack(spacing: 8) {
                Text("No Tools Yet")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(.appWhite)
                
                Text("You haven't added any tools to your catalog yet.")
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
    CatalogView(toolsViewModel: ToolsViewModel())
}
