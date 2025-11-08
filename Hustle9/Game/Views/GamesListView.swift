import SwiftUI

struct GamesListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: GamesViewModel
    @State private var showingAddGame = false
    @State private var showingFilters = false
    @State private var selectedGames: Set<UUID> = []
    @State private var isSelectionMode = false
    @State private var gameToEdit: Game?
    @State private var gameToShow: Game?
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    private var columns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - 40
        
        if availableWidth > 600 {
            return [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ]
        } else { 
            return [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ]
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if viewModel.filteredGames.isEmpty {
                emptyStateView
            } else {
                gamesList
            }
            
            VStack {
                Spacer()
                
                Button {
                    showingAddGame = true
                } label: {
                    Text("Create new game")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.primaryText)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.green.opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 40)
        }
        .sheet(isPresented: $showingAddGame) {
            AddEditGameView(viewModel: viewModel)
        }
        .sheet(item: $gameToEdit) { game in
            AddEditGameView(game: game, viewModel: viewModel)
        }
        .sheet(item: $gameToShow) { game in
            GameDetailView(game: game, gamesViewModel: viewModel)
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(viewModel: viewModel)
        }
        .overlay(
            toastView,
            alignment: .bottom
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 8) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.accent)
                    }
                    
                    Text("My Games")
                        .font(AppFonts.title1)
                        .foregroundColor(AppColors.primaryText)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 10) {
                    Menu {
                        Button("Sort Alphabetically") {
                            viewModel.updateSortOption(.alphabetical)
                            showToast("Sorted alphabetically")
                        }
                        
                        Button("Sort by Date Added") {
                            viewModel.updateSortOption(.dateAdded)
                            showToast("Sorted by date")
                        }
                        
                        Button("Filter by Categories...") {
                            showingFilters = true
                        }
                        
                        Button("Reset Filters") {
                            viewModel.clearFilters()
                            showToast("Filters reset")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Games")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.isSearching.toggle()
                        if !viewModel.isSearching {
                            viewModel.updateSearchText("")
                        }
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryText)
                }
                
                Menu {
                    Button("Sort Alphabetically") {
                        viewModel.updateSortOption(.alphabetical)
                        showToast("Sorted alphabetically")
                    }
                    
                    Button("Sort by Date Added") {
                        viewModel.updateSortOption(.dateAdded)
                        showToast("Sorted by date")
                    }
                    
                    Button("Filter by Categories...") {
                        showingFilters = true
                    }
                    
                    Button("Reset Filters") {
                        viewModel.clearFilters()
                        showToast("Filters reset")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryText)
                }
                
                Button(action: {
                    showingAddGame = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var searchBarView: some View {
        HStack {
            TextField("Search games...", text: Binding(
                get: { viewModel.searchText },
                set: { viewModel.updateSearchText($0) }
            ))
            .font(AppFonts.body)
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.updateSearchText("")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    private var gamesList: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.filteredGames) { game in
                    ZStack {
                        NavigationLink(destination: GameDetailView(game: game, gamesViewModel: viewModel)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        GameCard(
                            game: game,
                            onTap: {
                                if isSelectionMode {
                                    toggleSelection(game)
                                } else {
                                    gameToShow = game
                                }
                            },
                            onEdit: {
                                gameToEdit = game
                            },
                            onDelete: {
                                viewModel.deleteGame(game)
                                showToast("Game deleted")
                            },
                            onToggleFavorite: {
                                viewModel.toggleFavorite(for: game)
                                showToast(!game.isFavorite ? "Added to favorites" : "Removed from favorites")
                            }
                        )
                        .overlay(
                            isSelectionMode ? 
                            HStack {
                                Spacer()
                                VStack {
                                    Image(systemName: selectedGames.contains(game.id) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedGames.contains(game.id) ? AppColors.accent : AppColors.secondaryText)
                                        .font(.title2)
                                    Spacer()
                                }
                                .padding(.trailing, 16)
                            } : nil
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .refreshable {
            viewModel.refreshData()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No games yet")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first game to get started")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddGame = true
            }) {
                Text("Add Game")
                    .font(AppFonts.buttonMedium)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.accent)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var selectionToolbar: some View {
        HStack {
            Button("Cancel") {
                isSelectionMode = false
                selectedGames.removeAll()
            }
            .font(AppFonts.buttonMedium)
            .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button("Delete Selected (\(selectedGames.count))") {
                let gamesToDelete = viewModel.filteredGames.filter { selectedGames.contains($0.id) }
                viewModel.deleteGames(gamesToDelete)
                showToast("\(gamesToDelete.count) games deleted")
                isSelectionMode = false
                selectedGames.removeAll()
            }
            .font(AppFonts.buttonMedium)
            .foregroundColor(AppColors.error)
            .disabled(selectedGames.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(AppColors.cardBackground)
                .overlay(
                    Rectangle()
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var toastView: some View {
        Group {
            if showingToast {
                Text(toastMessage)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.success)
                    )
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    private func toggleSelection(_ game: Game) {
        if selectedGames.contains(game.id) {
            selectedGames.remove(game.id)
        } else {
            selectedGames.insert(game.id)
        }
        
        if selectedGames.isEmpty {
            isSelectionMode = false
        }
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showingToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingToast = false
            }
        }
    }
}

#Preview {
    ZStack {
        BackgroundView()
        GamesListView()
            .environmentObject(GamesViewModel())
    }
}
