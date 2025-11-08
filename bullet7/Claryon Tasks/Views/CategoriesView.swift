import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: CleaningZoneViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var editingCategory: Category?
    @State private var editingCategoryName = ""
    @State private var showingNameError = false
    @State private var showingDuplicateError = false
    @State private var categoryToDelete: Category?
    
    var sortedCategories: [Category] {
        viewModel.categories.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Zone Categories")
                            .font(Font.titleLarge)
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        Button(action: { showingAddCategory = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(.accentYellow)
                        }
                    }
                    .padding()
                    
                    if sortedCategories.isEmpty {
                        EmptyStateCategoriesView(onAddCategory: { showingAddCategory = true })
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(sortedCategories) { category in
                                CategoryRowView(
                                    category: category,
                                    isEditing: editingCategory?.id == category.id,
                                    editingName: $editingCategoryName,
                                    onStartEditing: {
                                        editingCategory = category
                                        editingCategoryName = category.name
                                    },
                                    onSaveEdit: {
                                        saveEditedCategory()
                                    },
                                    onCancelEdit: {
                                        editingCategory = nil
                                        editingCategoryName = ""
                                    },
                                    onDelete: {
                                        categoryToDelete = category
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                    
                }
                .padding(.bottom, 100)
                
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategorySheet(
                categoryName: $newCategoryName,
                onSave: addNewCategory,
                onCancel: {
                    showingAddCategory = false
                    newCategoryName = ""
                }
            )
        }
        .alert("Delete Category", isPresented: .constant(categoryToDelete != nil)) {
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
                Text("Are you sure you want to delete \"\(category.name)\"? This won't affect existing zones.")
            }
        }
        .alert("Error", isPresented: $showingNameError) {
            Button("OK") { showingNameError = false }
        } message: {
            Text("Please enter a category name.")
        }
        .alert("Error", isPresented: $showingDuplicateError) {
            Button("OK") { showingDuplicateError = false }
        } message: {
            Text("This category already exists.")
        }
    }
    
    private func addNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showingNameError = true
            return
        }
        
        guard !viewModel.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            showingDuplicateError = true
            return
        }
        
        let newCategory = Category(name: trimmedName)
        viewModel.addCategory(newCategory)
        
        showingAddCategory = false
        newCategoryName = ""
    }
    
    private func saveEditedCategory() {
        let trimmedName = editingCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showingNameError = true
            return
        }
        
        guard let category = editingCategory else { return }
        
        guard !viewModel.categories.contains(where: { $0.id != category.id && $0.name.lowercased() == trimmedName.lowercased() }) else {
            showingDuplicateError = true
            return
        }
        
        var updatedCategory = category
        updatedCategory.name = trimmedName
        viewModel.updateCategory(updatedCategory)
        
        editingCategory = nil
        editingCategoryName = ""
    }
}

struct EmptyStateCategoriesView: View {
    let onAddCategory: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.accentYellow)
            
            VStack(spacing: 10) {
                Text("No categories")
                    .font(.titleMedium)
                    .foregroundColor(.primaryWhite)
                
                Text("Add your first category")
                    .font(.bodyMedium)
                    .foregroundColor(.secondaryText)
            }
            
            Button(action: onAddCategory) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Category")
                }
                .font(.bodyLarge)
                .foregroundColor(.primaryPurple)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.accentYellow)
                .cornerRadius(25)
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    let isEditing: Bool
    @Binding var editingName: String
    let onStartEditing: () -> Void
    let onSaveEdit: () -> Void
    let onCancelEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("Category name", text: $editingName)
                    .font(.bodyMedium)
                    .foregroundColor(.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save", action: onSaveEdit)
                    .font(.bodySmall)
                    .foregroundColor(.successGreen)
                
                Button("Cancel", action: onCancelEdit)
                    .font(.bodySmall)
                    .foregroundColor(.warningRed)
            } else {
                Text(category.name)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryWhite)
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .onTapGesture {
            if !isEditing {
                onStartEditing()
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete", role: .destructive, action: onDelete)
        }
    }
}

struct AddCategorySheet: View {
    @Binding var categoryName: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TextField("Category name", text: $categoryName)
                        .font(.bodyMedium)
                        .foregroundColor(.primaryWhite)
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onCancel)
                        .foregroundColor(.accentYellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: onSave)
                        .foregroundColor(.accentYellow)
                        .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    CategoriesView(viewModel: CleaningZoneViewModel())
}
