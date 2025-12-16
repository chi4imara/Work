import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddCategory = false
    @State private var editingCategory: Category?
    @State private var showingDeleteAlert = false
    @State private var categoryToDelete: Category?
    @State private var deleteErrorMessage = ""
    @State private var showingDeleteError = false
    
    private var sortedCategories: [Category] {
        dataManager.categories.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Categories")
                        .font(.appTitle(28))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: { showingAddCategory = true }) {
                        Image(systemName: "plus")
                            .font(.appTitle(28))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if sortedCategories.isEmpty {
                    EmptyStateView(
                        icon: "folder",
                        title: "No Categories Yet",
                        subtitle: "Create categories to organize your gifts",
                        buttonTitle: "Create Category",
                        buttonAction: { showingAddCategory = true }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(sortedCategories) { category in
                                CategoryRowView(
                                    category: category,
                                    onEdit: { editingCategory = category },
                                    onDelete: { attemptDelete(category) }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddEditCategoryView(isPresented: $showingAddCategory)
        }
        .sheet(item: $editingCategory) { category in
            AddEditCategoryView(category: category, isPresented: .constant(true)) {
                editingCategory = nil
            }
        }
        .alert("Cannot Delete Category", isPresented: $showingDeleteError) {
            Button("OK") { }
        } message: {
            Text(deleteErrorMessage)
        }
        .alert("Delete Category?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    dataManager.deleteCategory(category)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private func attemptDelete(_ category: Category) {
        if dataManager.canDeleteCategory(category) {
            categoryToDelete = category
            showingDeleteAlert = true
        } else {
            deleteErrorMessage = "Cannot delete category: there are gifts using this category"
            showingDeleteError = true
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    let onEdit: () -> Void
    let onDelete: () -> Void
    @EnvironmentObject var dataManager: DataManager
    
    private var giftCount: Int {
        dataManager.gifts.filter { $0.categoryId == category.id }.count
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.iconName)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primaryPurple)
                .frame(width: 40, height: 40)
                .background(AppColors.primaryPurple.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.appHeadline(18))
                    .foregroundColor(AppColors.secondaryText)
                
                Text("\(giftCount) gift\(giftCount == 1 ? "" : "s")")
                    .font(.appCaption(14))
                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(AppColors.editBlue)
                        .font(.system(size: 16))
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(AppColors.deleteRed)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .swipeActions(edge: .trailing) {
            Button("Delete") {
                onDelete()
            }
            .tint(AppColors.deleteRed)
        }
        .swipeActions(edge: .leading) {
            Button("Edit") {
                onEdit()
            }
            .tint(AppColors.editBlue)
        }
    }
}

struct AddEditCategoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    
    let category: Category?
    
    @State private var name = ""
    @State private var selectedIcon = "folder"
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    private let availableIcons = [
        "folder", "heart", "star", "gift", "book", "headphones",
        "tshirt", "paintbrush", "gamecontroller", "camera",
        "music.note", "film", "sportscourt", "car", "house",
        "leaf", "pawprint", "birthday.cake", "cup.and.saucer"
    ]
    
    private var isEditing: Bool {
        category != nil
    }
    
    private var navigationTitle: String {
        isEditing ? "Edit Category" : "New Category"
    }
    
    init(category: Category? = nil, isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil) {
        self.category = category
        self._isPresented = isPresented
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .font(.appHeadline(16))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Enter category name", text: $name)
                            .font(.appBody(16))
                            .foregroundColor(AppColors.secondaryText)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Icon")
                            .font(.appHeadline(16))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                            ForEach(availableIcons, id: \.self) { iconName in
                                Button(action: {
                                    selectedIcon = iconName
                                }) {
                                    Image(systemName: iconName)
                                        .font(.system(size: 20))
                                        .foregroundColor(selectedIcon == iconName ? AppColors.primaryBlue : AppColors.secondaryText)
                                        .frame(width: 44, height: 44)
                                        .background(
                                            selectedIcon == iconName ? 
                                            AppColors.primaryText : 
                                            AppColors.cardBackground.opacity(0.7)
                                        )
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    selectedIcon == iconName ? 
                                                    AppColors.primaryBlue : 
                                                    Color.clear, 
                                                    lineWidth: 2
                                                )
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCategory()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private func setupInitialValues() {
        if let category = category {
            name = category.name
            selectedIcon = category.iconName
        }
    }
    
    private func saveCategory() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            validationMessage = "Please enter a category name"
            showingValidationError = true
            return
        }
        
        if trimmedName.count > 40 {
            validationMessage = "Category name must be 40 characters or less"
            showingValidationError = true
            return
        }
        
        let existingNames = dataManager.categories
            .filter { $0.id != category?.id } 
            .map { $0.name.lowercased() }
        
        if existingNames.contains(trimmedName.lowercased()) {
            validationMessage = "A category with this name already exists"
            showingValidationError = true
            return
        }
        
        if let existingCategory = category {
            var updatedCategory = existingCategory
            updatedCategory.name = trimmedName
            updatedCategory.iconName = selectedIcon
            dataManager.updateCategory(updatedCategory)
        } else {
            let newCategory = Category(name: trimmedName, iconName: selectedIcon)
            dataManager.addCategory(newCategory)
        }
        
        dismiss()
    }
    
    private func dismiss() {
        if let onDismiss = onDismiss {
            onDismiss()
        } else {
            isPresented = false
        }
    }
}
