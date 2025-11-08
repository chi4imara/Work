import SwiftUI
import Combine

struct AllIdeasView: View {
    @StateObject private var viewModel = AllIdeasViewModel()
    @State private var showingFilters = false
    @State private var showingAddIdea = false
    @State private var selectedIdea: Idea?
    @State private var ideaToDelete: Idea?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if viewModel.filteredIdeas.isEmpty {
                    emptyStateView
                } else {
                    ideasListView
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddIdea) {
            IdeaFormView()
        }
        .sheet(item: $selectedIdea) { idea in
            IdeaDetailView(idea: idea)
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let idea = ideaToDelete {
                    viewModel.deleteIdea(idea)
                    ideaToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaUpdated"))) { _ in
            viewModel.loadIdeas()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteToggled"))) { _ in
            viewModel.loadIdeas()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaDeleted"))) { _ in
            viewModel.loadIdeas()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaAdded"))) { _ in
            viewModel.loadIdeas()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("All Ideas")
                .font(AppFonts.navigationTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    showingFilters = true
                }) {
                    ZStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(viewModel.hasActiveFilters() ? AppColors.primary : AppColors.secondaryText)
                        
                        if viewModel.hasActiveFilters() {
                            Circle()
                                .fill(AppColors.error)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        }
                    }
                }
                
                Button(action: {
                    showingAddIdea = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search ideas...", text: $viewModel.searchText)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.primary.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var ideasListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredIdeas, id: \.id) { idea in
                    IdeaCard(
                        idea: idea,
                        isFavorite: viewModel.isFavorite(idea)
                    ) {
                        selectedIdea = idea
                    } onFavorite: {
                        viewModel.toggleFavorite(for: idea)
                    } onEdit: {
                    } onDelete: {
                        ideaToDelete = idea
                        showingDeleteAlert = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: viewModel.hasActiveFilters() ? "line.3.horizontal.decrease" : "books.vertical")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.primary)
                
                VStack(spacing: 12) {
                    Text(viewModel.hasActiveFilters() ? "No Results Found" : "No Ideas Available")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(viewModel.hasActiveFilters() ? 
                         "No ideas match your current filters. Try adjusting your search criteria." :
                         "No ideas in the list. Add new ones manually to get started.")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            if viewModel.hasActiveFilters() {
                Button(action: {
                    viewModel.clearFilters()
                }) {
                    Text("Clear Filters")
                        .font(AppFonts.buttonTitle)
                        .foregroundColor(AppColors.primary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppColors.primary, lineWidth: 2)
                        )
                }
            } else {
                Button(action: {
                    showingAddIdea = true
                }) {
                    Text("Add Idea")
                        .font(AppFonts.buttonTitle)
                        .foregroundColor(AppColors.onPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.primaryGradient)
                        .cornerRadius(28)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct IdeaCard: View {
    @State private var idea: Idea
    @State private var isFavorite: Bool
    let onTap: () -> Void
    let onFavorite: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingActions = false
    
    private let dataManager = DataManager.shared
    
    init(idea: Idea, isFavorite: Bool, onTap: @escaping () -> Void, onFavorite: @escaping () -> Void, onEdit: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self._idea = State(initialValue: idea)
        self._isFavorite = State(initialValue: isFavorite)
        self.onTap = onTap
        self.onFavorite = onFavorite
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(idea.title)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button(action: {
                        isFavorite.toggle()
                        onFavorite()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isFavorite ? AppColors.error : AppColors.secondaryText)
                    }
                }
                
                Text(idea.category.name)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(AppColors.primary.opacity(0.1))
                    )
                
                if let description = idea.description, !description.isEmpty {
                    Text(description)
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
                
                HStack {
                    Text(idea.isSystem ? "System" : "Custom")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.lightText)
                    
                    Spacer()
                    
                    Text(idea.dateAdded, style: .date)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.lightText)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 6, x: 0, y: 3)
        )
        .onTapGesture {
            onTap()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaUpdated"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                if let updatedIdea = dataManager.getIdea(withId: idea.id) {
                    idea = updatedIdea
                    isFavorite = dataManager.isFavorite(ideaId: idea.id)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteToggled"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                if let favoriteState = notification.userInfo?["isFavorite"] as? Bool {
                    isFavorite = favoriteState
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesCleared"))) { _ in
            isFavorite = dataManager.isFavorite(ideaId: idea.id)
        }
    }
}

struct FiltersView: View {
    @ObservedObject var viewModel: AllIdeasViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categories")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(viewModel.availableCategories, id: \.id) { category in
                                    CategoryFilterButton(
                                        category: category,
                                        isSelected: viewModel.selectedCategories.contains(category)
                                    ) {
                                        viewModel.toggleCategoryFilter(category)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Source")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(SourceFilter.allCases, id: \.self) { filter in
                                    Button(action: {
                                        viewModel.sourceFilter = filter
                                    }) {
                                        Text(filter.rawValue)
                                            .font(AppFonts.callout)
                                            .foregroundColor(viewModel.sourceFilter == filter ? AppColors.onPrimary : AppColors.primary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(viewModel.sourceFilter == filter ? AppColors.primary : AppColors.primary.opacity(0.1))
                                            )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sort By")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 8) {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    HStack {
                                        Button(action: {
                                            viewModel.sortOption = option
                                        }) {
                                            HStack {
                                                Image(systemName: viewModel.sortOption == option ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(viewModel.sortOption == option ? AppColors.primary : AppColors.secondaryText)
                                                
                                                Text(option.rawValue)
                                                    .font(AppFonts.body)
                                                    .foregroundColor(AppColors.primaryText)
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                
                                Toggle("Ascending Order", isOn: $viewModel.isAscending)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                viewModel.clearFilters()
                            }) {
                                Text("Clear All Filters")
                                    .font(AppFonts.buttonTitle)
                                    .foregroundColor(AppColors.primary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(AppColors.primary, lineWidth: 2)
                                    )
                            }
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Apply Filters")
                                    .font(AppFonts.buttonTitle)
                                    .foregroundColor(AppColors.onPrimary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(AppColors.primaryGradient)
                                    .cornerRadius(24)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Filters & Sorting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CategoryFilterButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.name)
                .font(AppFonts.callout)
                .foregroundColor(isSelected ? AppColors.onPrimary : AppColors.primary)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? AppColors.primary : AppColors.primary.opacity(0.1))
                )
        }
    }
}

#Preview {
    AllIdeasView()
}
