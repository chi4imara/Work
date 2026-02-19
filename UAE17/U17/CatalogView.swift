import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: ToolsViewModel
    @State private var showingAddTool = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.tools.isEmpty {
                    emptyStateView
                } else {
                    contentView
                }
            }
        }
        .sheet(isPresented: $showingAddTool) {
            AddToolView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Tool Catalog")
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.white)
                
                Spacer()
                
                Button(action: {
                    showingAddTool = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.theme.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.theme.orange)
                        )
                }
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.theme.white.opacity(0.6))
                
                TextField("Search tools...", text: $viewModel.searchText)
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.white)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.theme.white.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.white.opacity(0.1))
            )
            
            categoryFilterView
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryButton(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    viewModel.selectedCategory = nil
                }
                
                ForEach(ToolCategory.allCases) { category in
                    CategoryButton(
                        title: category.displayName,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.lightBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Add your first garage tool")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(Color.theme.white)
                
                Text("Start building your tool inventory")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.white.opacity(0.7))
            }
            
            Button(action: {
                showingAddTool = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Tool")
                }
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.orange)
                )
            }
            .padding(.bottom, 20)
            
            Spacer()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredTools) { tool in
                    ToolRowView(tool: tool, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(isSelected ? Color.theme.white : Color.theme.white.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.theme.orange : Color.theme.white.opacity(0.1))
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct ToolRowView: View {
    let tool: Tool
    let viewModel: ToolsViewModel
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            HStack(spacing: 16) {
                Image(systemName: iconForCategory(tool.category))
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color.theme.lightBlue)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.theme.white.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tool.name)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(Color.theme.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(tool.category.displayName)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(Color.theme.orange)
                    
                    Text("Storage: \(tool.storageLocation)")
                        .font(.playfairDisplay(12))
                        .foregroundColor(Color.theme.white.opacity(0.7))
                    
                    Text("Used: \(formattedDate(tool.lastUsedDate))")
                        .font(.playfairDisplay(12))
                        .foregroundColor(Color.theme.lightBlue)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.white.opacity(0.5))
            }
            .padding(16)
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
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    CatalogView(viewModel: ToolsViewModel())
}
