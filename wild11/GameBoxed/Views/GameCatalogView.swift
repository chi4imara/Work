import SwiftUI

struct GameCatalogView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showingSearch = false
    @State private var showingMenu = false
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Game Catalog")
                            .font(FontManager.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        HStack {
                            Button(action: { showingSearch.toggle() }) {
                                Image(systemName: "magnifyingglass")
                                    .font(FontManager.ubuntu(size: 20, weight: .bold))
                                    .foregroundColor(ColorManager.primaryBlue)
                            }
                            
                            Button(action: { viewModel.showingAddGame = true }) {
                                Image(systemName: "plus")
                                    .font(FontManager.ubuntu(size: 20, weight: .bold))
                                    .foregroundColor(ColorManager.primaryBlue)
                            }
                            
                            Menu {
                                Button("Filter by Category") {
                                    viewModel.showingCategoryFilter = true
                                }
                                
                                Menu("Sort By") {
                                    ForEach(GameViewModel.SortOption.allCases, id: \.self) { option in
                                        Button(option.rawValue) {
                                            viewModel.sortOption = option
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(FontManager.ubuntu(size: 20, weight: .bold))
                                    .foregroundColor(ColorManager.primaryBlue)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if showingSearch {
                        SearchBarView(searchText: $viewModel.searchText, isActive: $showingSearch)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    }
                    
                    if viewModel.filteredGames.isEmpty {
                        EmptyStateView(
                            title: viewModel.games.isEmpty ? "Catalog is Empty" : "No Matches Found",
                            message: viewModel.games.isEmpty ? "Start building your game collection" : "Try adjusting your search or filters",
                            buttonTitle: viewModel.games.isEmpty ? "Add Game" : "Clear Filters",
                            action: {
                                if viewModel.games.isEmpty {
                                    viewModel.showingAddGame = true
                                } else {
                                    viewModel.clearFilters()
                                }
                            }
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredGames) { game in
                                    NavigationLink(destination: GameDetailView(game: game, viewModel: viewModel)) {
                                        GameCardView(game: game) {
                                            viewModel.toggleFavorite(for: game.id)
                                            showToast("Added to Favorites")
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)
                        }
                        
                        Text("Total Games: \(viewModel.filteredGames.count)")
                            .font(FontManager.ubuntu(size: 14, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                            .padding(.bottom, 16)
                            .padding(.top, 5)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $viewModel.showingAddGame) {
            GameFormView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showingCategoryFilter) {
            CategoryFilterView(viewModel: viewModel)
        }
        .overlay(
            ToastView(message: toastMessage, isShowing: $showingToast)
                .animation(.easeInOut, value: showingToast),
            alignment: .top
        )
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
        showingToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showingToast = false
        }
    }
}

struct GameCardView: View {
    let game: Game
    let onFavorite: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(game.name)
                    .font(FontManager.ubuntu(size: 18, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Category: \(game.category)")
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
                
                Text(game.description)
                    .font(FontManager.ubuntu(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if game.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(ColorManager.primaryYellow)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardBackground)
                .shadow(color: ColorManager.shadowColor, radius: 4, x: 0, y: 2)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Favorite") {
                onFavorite()
            }
            .tint(ColorManager.primaryYellow)
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isActive: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorManager.secondaryText)
                
                TextField("Search games...", text: $searchText)
                    .font(FontManager.ubuntu(size: 16, weight: .regular))
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorManager.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(ColorManager.cardBackground)
            )
            
            Button("Cancel") {
                searchText = ""
                isActive = false
            }
            .font(FontManager.ubuntu(size: 16, weight: .medium))
            .foregroundColor(ColorManager.primaryBlue)
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text(title)
                    .font(FontManager.ubuntu(size: 24, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(message)
                    .font(FontManager.ubuntu(size: 16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Text(buttonTitle)
                    .font(FontManager.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.whiteText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.primaryBlue)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        if isShowing {
            Text(message)
                .font(FontManager.ubuntu(size: 14, weight: .medium))
                .foregroundColor(ColorManager.whiteText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorManager.primaryBlue)
                )
                .padding(.top, 60)
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

#Preview {
    GameCatalogView(viewModel: GameViewModel())
}
