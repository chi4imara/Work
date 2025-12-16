import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var categoryToDelete: Category?
    @State private var showingDeleteAlert = false
    
    @Binding var selectedTab: Int
        
    var body: some View {
        NavigationStack {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Game Categories")
                            .font(FontManager.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Button(action: { showingNewCategoryAlert = true }) {
                            Image(systemName: "plus")
                                .font(FontManager.ubuntu(size: 28, weight: .bold))
                                .foregroundColor(ColorManager.primaryBlue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if viewModel.categories.isEmpty {
                        EmptyStateView(
                            title: "No Categories Yet",
                            message: "Create categories to organize your games",
                            buttonTitle: "Add Category",
                            action: { showingNewCategoryAlert = true }
                        )
                        
                        Spacer()
                    } else {
                        List {
                            ForEach(viewModel.categories) { category in
                                NavigationLink(destination: CategoryGamesView(categoryName: category.name, viewModel: viewModel, selectedTab: $selectedTab)) {
                                    CategoryRowView(category: category)
                                }
                                .listRowBackground(ColorManager.cardBackground)
                            }
                            .onDelete(perform: deleteCategories)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            TextField("Category name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Save") {
                if !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.addCategory(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines))
                    newCategoryName = ""
                }
            }
        } message: {
            Text("Enter a name for the new category")
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                categoryToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    viewModel.deleteCategory(category)
                }
                categoryToDelete = nil
            }
        } message: {
            if let category = categoryToDelete {
                if category.gameCount > 0 {
                    Text("Are you sure you want to delete \"\(category.name)\"? This will also delete all \(category.gameCount) game(s) in this category. This action cannot be undone.")
                } else {
                    Text("Are you sure you want to delete \"\(category.name)\"?")
                }
            }
        }
    }
    
    private func deleteCategories(offsets: IndexSet) {
        if let firstIndex = offsets.first, firstIndex < viewModel.categories.count {
            let category = viewModel.categories[firstIndex]
            categoryToDelete = category
            showingDeleteAlert = true
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(FontManager.ubuntu(size: 18, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("\(category.gameCount) games")
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct CategoryGamesView: View {
    @Environment(\.dismiss) var dismiss
    let categoryName: String
    @ObservedObject var viewModel: GameViewModel
    
    @Binding var selectedTab: Int
    
    private var categoryExists: Bool {
        viewModel.categories.contains { $0.name == categoryName }
    }
    
    private var categoryGames: [Game] {
        viewModel.games.filter { $0.category == categoryName }.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            if !categoryExists {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(ColorManager.warningColor.opacity(0.6))
                    
                    Text("Category Not Found")
                        .font(FontManager.ubuntu(size: 24, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text("This category has been deleted")
                        .font(FontManager.ubuntu(size: 16, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            } else if categoryGames.isEmpty {
                EmptyStateView(
                    title: "No Games in \(categoryName)",
                    message: "Add games to this category to see them here",
                    buttonTitle: "Add Game",
                    action: {
                        withAnimation {
                            dismiss()
                            selectedTab = 0
                        }
                    }
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(categoryGames) { game in
                            NavigationLink(destination: GameDetailView(game: game, viewModel: viewModel)) {
                                GameCardView(game: game) {
                                    viewModel.toggleFavorite(for: game.id)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
                
                VStack {
                    Spacer()
                    Text("Total Games: \(categoryGames.count)")
                        .font(FontManager.ubuntu(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                        .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $viewModel.showingAddGame) {
            GameFormView(viewModel: viewModel)
        }
    }
}
