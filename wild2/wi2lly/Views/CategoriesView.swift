import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: WordsViewModel
    @Binding var selectedTab: Int
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var categoryToDelete: CategoryModel?
    @State private var categoryToRename: CategoryModel?
    @State private var renameCategoryName = ""
    @State private var showingDeleteAlert = false
    @State private var showingRenameAlert = false
    
    init(viewModel: WordsViewModel = WordsViewModel(), selectedTab: Binding<Int> = .constant(0)) {
        self.viewModel = viewModel
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.categories.isEmpty {
                        emptyStateView
                    } else {
                        categoriesListContent
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Add Category", isPresented: $showingAddCategory) {
            TextField("Category name", text: $newCategoryName)
            Button("Add") {
                addCategory()
            }
            .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
        } message: {
            Text("Enter a name for the new category")
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    viewModel.deleteCategory(category)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            if let category = categoryToDelete {
                Text(category.wordsCount > 0 ? 
                     "Cannot delete '\(category.name)' because it contains \(category.wordsCount) word(s). Move or delete the words first." :
                     "Are you sure you want to delete '\(category.name)'?")
            }
        }
        .alert("Rename Category", isPresented: $showingRenameAlert) {
            TextField("New name", text: $renameCategoryName)
            Button("Rename") {
                renameCategory()
            }
            .disabled(renameCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Button("Cancel", role: .cancel) {
                renameCategoryName = ""
            }
        } message: {
            Text("Enter a new name for the category")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Categories")
                    .font(.playfair(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Spacer()
                
                Button(action: { showingAddCategory = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color.theme.primaryYellow)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoriesListContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.categories) { category in
                    CategoryCardView(category: category, viewModel: viewModel) {
                        viewModel.selectedCategory = category
                        selectedTab = 0
                    }
                    .contextMenu {
                        Button(action: {
                            categoryToRename = category
                            renameCategoryName = category.name
                            showingRenameAlert = true
                        }) {
                            Label("Rename", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            categoryToDelete = category
                            showingDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .disabled(category.wordsCount > 0)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 5)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 80))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No categories created yet")
                    .font(.playfair(24, weight: .semibold))
                    .foregroundColor(Color.theme.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text("Create categories to organize your words")
                    .font(.playfair(16, weight: .regular))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddCategory = true }) {
                Text("Add First Category")
                    .font(.playfair(18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.theme.primaryBlue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func addCategory() {
        let categoryName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !categoryName.isEmpty else { return }
        
        if !viewModel.categories.contains(where: { $0.name.lowercased() == categoryName.lowercased() }) {
            let newCategory = CategoryModel(
                name: categoryName,
                colorIndex: viewModel.categories.count % ColorTheme.categoryColors.count
            )
            viewModel.addCategory(newCategory)
        }
        
        newCategoryName = ""
    }
    
    private func renameCategory() {
        guard let category = categoryToRename else { return }
        let newName = renameCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !newName.isEmpty else { return }
        
        if !viewModel.categories.contains(where: { $0.name.lowercased() == newName.lowercased() && $0.id != category.id }) {
            var updatedCategory = category
            updatedCategory.name = newName
            viewModel.updateCategory(updatedCategory)
        }
        
        renameCategoryName = ""
        categoryToRename = nil
    }
}

struct CategoryCardView: View {
    let category: CategoryModel
    @ObservedObject var viewModel: WordsViewModel
    let onTap: () -> Void
    
    var categoryColor: Color {
        ColorTheme.categoryColors[category.colorIndex % ColorTheme.categoryColors.count]
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(categoryColor)
                    .frame(width: 6, height: 60)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(category.name)
                            .font(.playfair(20, weight: .bold))
                            .foregroundColor(Color.theme.primaryBlue)
                        
                        Spacer()
                        
                        Text("\(category.wordsCount)")
                            .font(.playfair(16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(categoryColor)
                            .cornerRadius(12)
                    }
                    
                    HStack {
                        Text("\(category.wordsCount) word\(category.wordsCount == 1 ? "" : "s")")
                            .font(.playfair(14, weight: .medium))
                            .foregroundColor(Color.theme.textGray)
                        
                        Spacer()
                        
                        if let lastWord = category.lastWordAdded {
                            Text("Last: \(lastWord)")
                                .font(.playfair(14, weight: .medium))
                                .foregroundColor(Color.theme.textGray)
                                .lineLimit(1)
                        }
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.textGray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: categoryColor.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoriesView()
}
