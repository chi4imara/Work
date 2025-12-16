import SwiftUI

struct ToolsListView: View {
    @EnvironmentObject var viewModel: ToolsViewModel
    @State private var showingAddTool = false
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if viewModel.filteredTools.isEmpty {
                    emptyStateView
                } else {
                    toolsListView
                }
            }
            .background(ColorManager.backgroundGradient)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddTool) {
            AddToolView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheetView()
                .environmentObject(viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Tools")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("\(viewModel.tools.count) tools in collection")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
            
            Button(action: { showingAddTool = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(ColorManager.primaryButton)
                    .clipShape(Circle())
                    .shadow(color: ColorManager.cardShadow, radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorManager.secondaryText)
                
                TextField("Search by name or category...", text: $viewModel.searchText)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorManager.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: ColorManager.shadowColor, radius: 4, x: 0, y: 2)
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterButton(
                        title: "All",
                        isSelected: viewModel.selectedCategory == nil && viewModel.selectedCondition == nil
                    ) {
                        viewModel.clearFilters()
                    }
                    
                    FilterButton(
                        title: "Good condition",
                        isSelected: viewModel.selectedCondition == .good
                    ) {
                        viewModel.setFilter(condition: .good)
                    }
                    
                    FilterButton(
                        title: "Needs replacement",
                        isSelected: viewModel.selectedCondition == .needsReplacement
                    ) {
                        viewModel.setFilter(condition: .needsReplacement)
                    }
                    
                    Button(action: { showingFilterSheet = true }) {
                        HStack(spacing: 4) {
                            Text("Categories")
                                .font(.playfairDisplay(14, weight: .medium))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paintbrush.pointed")
                .font(.system(size: 60))
                .foregroundColor(ColorManager.secondaryText.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No tools added yet")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Start with your favorite brush or curler!")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddTool = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Tool")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(ColorManager.primaryButton)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var toolsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredTools) { tool in
                    NavigationLink(destination: ToolDetailView(tool: tool).environmentObject(viewModel)) {
                        ToolCardView(tool: tool)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(isSelected ? .white : ColorManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AnyShapeStyle(ColorManager.primaryButton) : AnyShapeStyle(Color.white.opacity(0.8)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: isSelected ? 0 : 1)
                        )
                )
        }
    }
}

struct ToolCardView: View {
    let tool: Tool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(tool.actualCondition.color)
                .frame(width: 12, height: 12)
            
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
                    
                    Text(tool.actualCondition.displayName)
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(tool.actualCondition.color)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(ColorManager.secondaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.shadowColor, radius: 8, x: 0, y: 4)
        )
    }
}

struct FilterSheetView: View {
    @EnvironmentObject var viewModel: ToolsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Filter by Category")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(ToolCategory.allCases) { category in
                            Button(action: {
                                viewModel.setFilter(category: category)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text(category.displayName)
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(ColorManager.primaryText)
                                    
                                    Spacer()
                                    
                                    if viewModel.selectedCategory == category {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(ColorManager.primaryText)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(viewModel.selectedCategory == category ? AnyShapeStyle(ColorManager.cardGradient) : AnyShapeStyle(Color.clear))
                                )
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .background(ColorManager.backgroundGradient)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
