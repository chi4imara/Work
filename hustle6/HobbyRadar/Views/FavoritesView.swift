import SwiftUI
import Combine

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var selectedIdea: Idea?
    @State private var showingMenu = false
    @State private var showingClearConfirmation = false
    @State private var ideaToRemove: Idea?
    @State private var showingRemoveAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.isEmpty {
                    emptyStateView
                } else {
                    favoritesListView
                }
            }
        }
        .sheet(item: $selectedIdea) { idea in
            IdeaDetailView(idea: idea)
        }
        .actionSheet(isPresented: $showingMenu) {
            ActionSheet(
                title: Text("Sort Options"),
                buttons: [
                    .default(Text("Sort Alphabetically")) {
                        viewModel.setSortOption(.alphabetical)
                    },
                    .default(Text("Sort by Date Added")) {
                        viewModel.setSortOption(.dateAdded)
                    },
                    .destructive(Text("Clear All Favorites")) {
                        showingClearConfirmation = true
                    },
                    .cancel()
                ]
            )
        }
        .alert("Clear All Favorites", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                viewModel.clearAllFavorites()
            }
        } message: {
            Text("Are you sure you want to remove all ideas from your favorites? This action cannot be undone.")
        }
        .alert("Remove from Favorites", isPresented: $showingRemoveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let idea = ideaToRemove {
                    viewModel.removeFromFavorites(idea)
                    ideaToRemove = nil
                }
            }
        } message: {
            Text("Are you sure you want to remove this idea from your favorites?")
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaUpdated"))) { _ in
            viewModel.loadFavorites()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteToggled"))) { _ in
            viewModel.loadFavorites()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesCleared"))) { _ in
            viewModel.loadFavorites()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaDeleted"))) { _ in
            viewModel.loadFavorites()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaAdded"))) { _ in
            viewModel.loadFavorites()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(AppFonts.navigationTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if !viewModel.isEmpty {
                Button(action: {
                    showingMenu = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var favoritesListView: some View {
        VStack(spacing: 0) {
            if !viewModel.isEmpty {
                HStack {
                    Text("Sorted by \(viewModel.sortOption.rawValue)")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.lightText)
                    
                    Spacer()
                    
                    Text("\(viewModel.favoriteIdeas.count) idea\(viewModel.favoriteIdeas.count == 1 ? "" : "s")")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.lightText)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.favoriteIdeas, id: \.id) { idea in
                        FavoriteIdeaCard(idea: idea) {
                            selectedIdea = idea
                        } onRemove: {
                            ideaToRemove = idea
                            showingRemoveAlert = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "heart")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.primary)
                }
                
                VStack(spacing: 12) {
                    Text("No Favorites Yet")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Your favorite ideas will appear here. Start by adding some ideas to your favorites from the main screen or all ideas list.")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
            Spacer()
        }
    }
}

struct FavoriteIdeaCard: View {
    @State private var idea: Idea
    let onTap: () -> Void
    let onRemove: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingRemoveAlert = false
    @State private var isVisible = true
    
    private let dataManager = DataManager.shared
    
    init(idea: Idea, onTap: @escaping () -> Void, onRemove: @escaping () -> Void) {
        self._idea = State(initialValue: idea)
        self.onTap = onTap
        self.onRemove = onRemove
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.error)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(idea.title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(2)
                
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
                    
                    Text("Added \(idea.dateAdded, style: .date)")
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
        .opacity(isVisible ? 1.0 : 0.0)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaUpdated"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                if let updatedIdea = dataManager.getIdea(withId: idea.id) {
                    idea = updatedIdea
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteToggled"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                if let isFavorite = notification.userInfo?["isFavorite"] as? Bool, !isFavorite {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isVisible = false
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesCleared"))) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                isVisible = false
            }
        }
    }
}

struct FavoritesSortMenu: View {
    @ObservedObject var viewModel: FavoritesViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Sort & Options")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button("Done") {
                    isPresented = false
                }
                .font(AppFonts.callout)
                .foregroundColor(AppColors.primary)
            }
            .padding(20)
            
            Divider()
            
            VStack(spacing: 0) {
                ForEach(FavoriteSortOption.allCases, id: \.self) { option in
                    Button(action: {
                        viewModel.setSortOption(option)
                    }) {
                        HStack {
                            Text(option.displayName)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            if viewModel.sortOption == option {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    if option != FavoriteSortOption.allCases.last {
                        Divider()
                            .padding(.leading, 20)
                    }
                }
            }
            
            Divider()
            
            Button(action: {
                viewModel.clearAllFavorites()
                isPresented = false
            }) {
                HStack {
                    Text("Clear All Favorites")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.error)
                    
                    Spacer()
                    
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.error)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            
            Spacer()
        }
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    FavoritesView()
}
