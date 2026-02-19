import SwiftUI

struct ToolCatalogView: View {
    @ObservedObject var viewModel: ToolViewModel
    @State private var showingSortOptions = false
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndSortView
                
                if viewModel.filteredTools.isEmpty {
                    emptyStateView
                } else {
                    toolsListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Tool Catalog")
                .font(FontManager.title(.bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    selectedTab = 3
                }
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 40, height: 40)
                    .background(ColorTheme.accentGradient)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndSortView: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTheme.mutedText)
                    .font(.system(size: 16))
                
                TextField("Search tools...", text: $viewModel.searchText)
                    .font(FontManager.body(.regular))
                    .foregroundColor(ColorTheme.primaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTheme.mutedText)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(ColorTheme.inputBackground)
            .cornerRadius(12)
            
            Button(action: {
                showingSortOptions = true
            }) {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 44, height: 44)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(12)
            }
            .confirmationDialog("Sort Tools", isPresented: $showingSortOptions, titleVisibility: .visible) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(option.rawValue) {
                        viewModel.selectedSortOption = option
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorTheme.accentOrange)
            }
            
            VStack(spacing: 12) {
                Text("No Tools Found")
                    .font(FontManager.headline(.medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(viewModel.searchText.isEmpty ? 
                     "Add your first tool to get started" : 
                        "No tools match your search")
                .font(FontManager.body(.regular))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if viewModel.searchText.isEmpty {
                    withAnimation {
                        selectedTab = 3
                    }
                } else {
                    viewModel.searchText = ""
                }
            }) {
                Text(viewModel.searchText.isEmpty ? "Add Tool" : "Clear Search")
                    .font(FontManager.body(.medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 140, height: 44)
                    .background(ColorTheme.accentGradient)
                    .cornerRadius(22)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var toolsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredTools) { tool in
                    ToolCardView(tool: tool) {
                        viewModel.selectedToolId = tool.id
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ToolCardView: View {
    let tool: Tool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.accentOrange.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: tool.type.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(ColorTheme.accentOrange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tool.name)
                        .font(FontManager.body(.medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(1)
                    
                    Text(tool.type.rawValue)
                        .font(FontManager.caption(.regular))
                        .foregroundColor(ColorTheme.accentOrange)
                    
                    HStack {
                        if !tool.size.isEmpty {
                            Label(tool.size, systemImage: "ruler")
                                .font(FontManager.small(.light))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                        
                        if !tool.storageLocation.isEmpty {
                            Label(tool.storageLocation, systemImage: "location")
                                .font(FontManager.small(.light))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.mutedText)
            }
            .padding(16)
            .background(ColorTheme.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
