import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var editingCategory: Category?
    @State private var editCategoryName = ""
    @State private var showingDeleteAlert = false
    @State private var categoryToDelete: Category?
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorManager.backgroundGradientStart,
                    ColorManager.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(ColorManager.orbColors[index % ColorManager.orbColors.count])
                    .frame(width: CGFloat.random(in: 25...55))
                    .position(
                        x: CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50)),
                        y: CGFloat.random(in: 100...(UIScreen.main.bounds.height - 200))
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 4...7))
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
            }
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoriesListView
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            addCategorySheet
        }
        .sheet(item: $editingCategory) { category in
            editCategorySheet(category: category)
        }
        .confirmationDialog("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    viewModel.deleteCategory(category)
                }
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this category?")
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(FontManager.ubuntuBold(28))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddCategory = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryBlue)
                    .frame(width: 40, height: 40)
                    .concaveCard(cornerRadius: 20, depth: 3, color: ColorManager.primaryYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.primaryYellow)
            
            VStack(spacing: 12) {
                Text("No categories")
                    .font(FontManager.ubuntuBold(24))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Add your first category")
                    .font(FontManager.ubuntu(16))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Button(action: {
                showingAddCategory = true
            }) {
                Text("Add Category")
                    .font(FontManager.ubuntuMedium(18))
                    .foregroundColor(ColorManager.primaryBlue)
                    .frame(width: 200, height: 50)
                    .concaveCard(cornerRadius: 25, depth: 4, color: ColorManager.primaryYellow)
            }
            
            Spacer()
        }
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.categories.sorted { $0.name < $1.name }) { category in
                    CategoryRowView(
                        category: category,
                        onEdit: {
                            editingCategory = category
                        },
                        onDelete: {
                            categoryToDelete = category
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
    
    private var addCategorySheet: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradientStart.ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Text("Add Category")
                        .font(FontManager.ubuntuBold(24))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .font(FontManager.ubuntuMedium(16))
                            .foregroundColor(ColorManager.primaryText)
                        
                        TextField("Enter category name", text: $newCategoryName)
                            .font(FontManager.ubuntu(16))
                            .foregroundColor(ColorManager.primaryBlue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 15) {
                        Button(action: addCategory) {
                            Text("Save Category")
                                .font(FontManager.ubuntuMedium(18))
                                .foregroundColor(ColorManager.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .concaveCard(cornerRadius: 25, depth: 4, color: ColorManager.primaryYellow)
                        }
                        
                        Button(action: {
                            newCategoryName = ""
                            showingAddCategory = false
                        }) {
                            Text("Cancel")
                                .font(FontManager.ubuntuMedium(16))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .concaveCard(cornerRadius: 22, depth: 2, color: ColorManager.buttonSecondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func editCategorySheet(category: Category) -> some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradientStart.ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Text("Edit Category")
                        .font(FontManager.ubuntuBold(24))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .font(FontManager.ubuntuMedium(16))
                            .foregroundColor(ColorManager.primaryText)
                        
                        TextField("Enter category name", text: $editCategoryName)
                            .font(FontManager.ubuntu(16))
                            .foregroundColor(ColorManager.primaryBlue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            saveEditedCategory(category)
                        }) {
                            Text("Save Changes")
                                .font(FontManager.ubuntuMedium(18))
                                .foregroundColor(ColorManager.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .concaveCard(cornerRadius: 25, depth: 4, color: ColorManager.primaryYellow)
                        }
                        
                        Button(action: {
                            editCategoryName = ""
                            editingCategory = nil
                        }) {
                            Text("Cancel")
                                .font(FontManager.ubuntuMedium(16))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .concaveCard(cornerRadius: 22, depth: 2, color: ColorManager.buttonSecondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                editCategoryName = category.name
            }
        }
    }
    
    private func addCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showError("Please enter a category name")
            return
        }
        
        guard !viewModel.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            showError("This category already exists")
            return
        }
        
        let newCategory = Category(name: trimmedName, icon: "folder.fill")
        viewModel.addCategory(newCategory)
        
        newCategoryName = ""
        showingAddCategory = false
    }
    
    private func saveEditedCategory(_ category: Category) {
        let trimmedName = editCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showError("Please enter a category name")
            return
        }
        
        guard !viewModel.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() && $0.id != category.id }) else {
            showError("This category already exists")
            return
        }
        
        var updatedCategory = category
        updatedCategory.name = trimmedName
        viewModel.updateCategory(updatedCategory)
        
        editCategoryName = ""
        editingCategory = nil
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}

struct CategoryRowView: View {
    let category: Category
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: category.icon)
                .font(.system(size: 24))
                .foregroundColor(ColorManager.primaryBlue)
                .frame(width: 30)
            
            Text(category.name)
                .font(FontManager.ubuntuMedium(16))
                .foregroundColor(ColorManager.primaryBlue)
            
            Spacer()
            
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .font(.system(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .concaveCard(cornerRadius: 12, depth: 3, color: ColorManager.cardBackground)
        .contextMenu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: onDelete) {
                Image(systemName: "trash")
            }
            .tint(.red)
        }
    }
}

#Preview {
    CategoriesView(viewModel: ShoppingListViewModel())
}
