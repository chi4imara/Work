import SwiftUI

struct IdeasListView: View {
    @EnvironmentObject var viewModel: IdeasViewModel
    @State private var showingAddIdea = false
    @State private var showingRandomIdea = false
    @State private var showingFilterMenu = false
    @State private var showingSortMenu = false
    @State private var randomIdea: Idea?
    @State private var selectedIdea: Idea?
    @State private var ideaToEdit: Idea?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                searchBarView
                
                statisticsView
                
                if !viewModel.selectedCategories.isEmpty {
                    filterChipsView
                }
                
                if viewModel.filteredIdeas.isEmpty {
                    emptyStateView
                } else {
                    ideasListView
                }
            }
        }
        .sheet(isPresented: $showingAddIdea) {
            AddEditIdeaView(viewModel: viewModel)
        }
        .sheet(item: $ideaToEdit) { idea in
            AddEditIdeaView(viewModel: viewModel, ideaToEdit: idea)
        }
        .sheet(item: $selectedIdea) { idea in
            IdeaDetailView(ideaId: idea.id, viewModel: viewModel)
        }
        .alert("Random Idea", isPresented: $showingRandomIdea, presenting: randomIdea) { idea in
            Button("Open") {
                selectedIdea = idea
            }
            Button("Close", role: .cancel) { }
        } message: { idea in
            VStack(alignment: .leading, spacing: 8) {
                Text(idea.title)
                    .font(.headline)
                Text(idea.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .confirmationDialog("Filter by Category", isPresented: $showingFilterMenu) {
            ForEach(viewModel.categories, id: \.id) { category in
                Button(category.name) {
                    toggleCategoryFilter(category.name)
                }
            }
            Button("Clear Filters") {
                viewModel.clearFilters()
            }
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog("Sort Options", isPresented: $showingSortMenu) {
            ForEach(IdeasViewModel.SortOption.allCases, id: \.self) { option in
                Button(option.rawValue) {
                    viewModel.sortOption = option
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    
    private var searchBarView: some View {
        return HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search ideas...", text: $viewModel.searchText)
                .font(.theme.body)
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
    
    private var statisticsView: some View {
        let stats = viewModel.statistics
        
        return HStack(spacing: 20) {
            StatisticView(title: "Total Ideas", value: "\(stats.totalIdeas)")
            StatisticView(title: "Categories", value: "\(stats.totalCategories)")
            StatisticView(title: "Recent", value: stats.recentIdea, isText: true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
    
    private var filterChipsView: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(viewModel.selectedCategories), id: \.self) { category in
                    HStack(spacing: 5) {
                        Text("Filter: \(category)")
                            .font(.theme.caption1)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Button(action: { toggleCategoryFilter(category) }) {
                            Image(systemName: "xmark")
                                .font(.caption)
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.primaryOrange.opacity(0.8))
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 10)
    }
    
    private var ideasListView: some View {
        return ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredIdeas) { idea in
                    IdeaCardView(idea: idea) {
                        selectedIdea = idea
                    }
                    .contextMenu {
                        Button(action: {
                            ideaToEdit = idea
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            viewModel.deleteIdea(idea)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
        }
    }
    
    private var emptyStateView: some View {
        return VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
            
            Text(viewModel.ideas.isEmpty ? "No Ideas Yet" : "No Results Found")
                .font(.theme.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Text(viewModel.ideas.isEmpty ? 
                 "Start by adding your first home activity idea" : 
                 "Try adjusting your search or filters")
                .font(.theme.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button {
                if viewModel.ideas.isEmpty {
                    showingAddIdea = true
                } else {
                    viewModel.clearFilters()
                }
            } label: {
                Text(viewModel.ideas.isEmpty ? "Add First Idea" : "Clear Filters")
                    .font(.theme.buttonMedium)
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryOrange)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func showRandomIdea() {
        if let idea = viewModel.getRandomIdea() {
            randomIdea = idea
            showingRandomIdea = true
        }
    }
    
    private func toggleCategoryFilter(_ category: String) {
        if viewModel.selectedCategories.contains(category) {
            viewModel.selectedCategories.remove(category)
        } else {
            viewModel.selectedCategories.insert(category)
        }
    }
}

struct StatisticView: View {
    let title: String
    let value: String
    let isText: Bool
    
    init(title: String, value: String, isText: Bool = false) {
        self.title = title
        self.value = value
        self.isText = isText
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.theme.caption1)
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(isText ? .theme.headline : .theme.headline)
                .foregroundColor(AppColors.primaryOrange)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(AppColors.cardBackground)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct IdeaCardView: View {
    let idea: Idea
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(idea.title)
                        .font(.theme.headline)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Text(idea.category)
                        .font(.theme.caption1)
                        .foregroundColor(AppColors.primaryOrange)
                        .lineLimit(1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.primaryOrange.opacity(0.2))
                        .cornerRadius(8)
                }
                
                HStack {
                    Text(DateFormatter.shortDate.string(from: idea.dateAdded))
                        .font(.theme.caption2)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                }
                
                if !idea.note.isEmpty {
                    Text(idea.note)
                        .font(.theme.footnote)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    IdeasListView()
        .environmentObject(IdeasViewModel())
}
