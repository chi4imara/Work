import SwiftUI

struct CategoriesView: View {
    @ObservedObject var store: FirstExperienceStore
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var editingCategory: Category?
    @State private var editingCategoryName = ""
    @State private var showingDeleteAlert = false
    @State private var categoryToDelete: Category?
    @State private var deleteErrorMessage = ""
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if store.categories.isEmpty {
                        emptyStateView
                    } else {
                        categoriesList
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Add Category", isPresented: $showingAddCategory) {
            TextField("Category name", text: $newCategoryName)
                .onChange(of: newCategoryName) { newValue in
                    if newValue.count > 30 {
                        newCategoryName = String(newValue.prefix(30))
                    }
                }
            
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            
            Button("Save") {
                addNewCategory()
            }
            .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        } message: {
            Text("Enter a name for the new category (max 30 characters)")
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                categoryToDelete = nil
                deleteErrorMessage = ""
            }
            
            if deleteErrorMessage.isEmpty {
                Button("Delete", role: .destructive) {
                    deleteCategoryConfirmed()
                }
            } else {
                Button("OK") {
                    categoryToDelete = nil
                    deleteErrorMessage = ""
                }
            }
        } message: {
            if deleteErrorMessage.isEmpty {
                Text("Are you sure you want to delete this category? This action cannot be undone.")
            } else {
                Text(deleteErrorMessage)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Categories")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Button(action: {
                    showingAddCategory = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.pureWhite)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.pureWhite.opacity(0.1))
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(store.categories.sorted(by: { $0.name < $1.name }), id: \.id) { category in
                    CategoryRowView(
                        category: category,
                        isEditing: editingCategory?.id == category.id,
                        editingName: $editingCategoryName,
                        onEdit: {
                            startEditing(category)
                        },
                        onSave: {
                            saveEditedCategory(category)
                        },
                        onCancel: {
                            cancelEditing()
                        },
                        onDelete: {
                            deleteCategory(category)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
            .padding(.top, 8)
        }
        .id(refreshID)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.pureWhite.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "tag.fill")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.pureWhite.opacity(0.7))
            }
            
            VStack(spacing: 12) {
                Text("No Categories Yet")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.pureWhite)
                
                Text("Create categories to organize your first experiences")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.pureWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddCategory = true
            }) {
                Text("Add Category")
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func addNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty && trimmedName.count <= 30 else {
            return
        }
        
        guard !store.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            return
        }
        
        let newCategory = Category(name: trimmedName)
        store.addCategory(newCategory)
        newCategoryName = ""
        
        refreshID = UUID()
    }
    
    private func startEditing(_ category: Category) {
        editingCategory = category
        editingCategoryName = category.name
    }
    
    private func saveEditedCategory(_ category: Category) {
        let trimmedName = editingCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty && trimmedName.count <= 30 else {
            return
        }
        
        guard !store.categories.contains(where: { $0.id != category.id && $0.name.lowercased() == trimmedName.lowercased() }) else {
            return
        }
        
        var updatedCategory = category
        updatedCategory.name = trimmedName
        store.updateCategory(updatedCategory)
        
        editingCategory = nil
        editingCategoryName = ""
        
        refreshID = UUID()
    }
    
    private func cancelEditing() {
        editingCategory = nil
        editingCategoryName = ""
    }
    
    private func deleteCategory(_ category: Category) {
        categoryToDelete = category
        
        if store.canDeleteCategory(category) {
            deleteErrorMessage = ""
            showingDeleteAlert = true
        } else {
            deleteErrorMessage = "Cannot delete category while it's being used in experiences"
            showingDeleteAlert = true
        }
    }
    
    private func deleteCategoryConfirmed() {
        guard let category = categoryToDelete else { return }
        
        let success = store.deleteCategory(category)
        if !success {
            deleteErrorMessage = "Cannot delete category while it's being used in experiences"
            showingDeleteAlert = true
        } else {
            categoryToDelete = nil
            refreshID = UUID()
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    let isEditing: Bool
    @Binding var editingName: String
    
    let onEdit: () -> Void
    let onSave: () -> Void
    let onCancel: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        HStack(spacing: 13) {
            if isEditing {
                TextField("Category name", text: $editingName)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.darkGray)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: editingName) { newValue in
                        if newValue.count > 30 {
                            editingName = String(newValue.prefix(30))
                        }
                    }
                
                HStack(spacing: 8) {
                    Button("Save") {
                        onSave()
                    }
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.accentYellow)
                    
                    Button("Cancel") {
                        onCancel()
                    }
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.mediumGray)
                    .padding(.trailing, 4)
                }
            } else {
                    HStack {
                        Image(systemName: "tag.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.lightPurple)
                        
                        Text(category.name)
                            .font(FontManager.body)
                            .foregroundColor(AppColors.darkGray)
                        
                        Spacer()
                        
                        Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.mediumGray.opacity(0.6))
                    }
                        .buttonStyle(PlainButtonStyle())
                }
                .padding(16)
                .frame(maxWidth: .infinity)
            }
        }
        .cardBackground()
        .offset(x: dragOffset.width, y: 0)
        .background(
            HStack {
                Spacer()
                Button {
                    onDelete()
                } label: {
                    Text("Delete")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .frame(height: 60)
                        .background(Color.red)
                        .cornerRadius(16)
                    
                }
            }
            .opacity(dragOffset.width < -50 ? 1 : 0)
        )
        .highPriorityGesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    if value.translation.width < 0 && !isEditing {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if value.translation.width < -100 {
                            dragOffset = CGSize(width: -80, height: 0)
                        } else {
                            dragOffset = .zero
                        }
                    }
                }
        )
        .onChange(of: isEditing) { editing in
            if editing {
                withAnimation(.spring()) {
                    dragOffset = .zero
                }
            }
        }
    }
}


