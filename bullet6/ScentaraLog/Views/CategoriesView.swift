import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: ScentDiaryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var editingCategory: String?
    @State private var editedCategoryName = ""
    @State private var showingAddError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Scent Categories")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddCategory = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(AppColors.primaryPurple)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top)
                    
                    if viewModel.categories.isEmpty {
                        emptyStateView
                    } else {
                        categoriesListView
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .alert("Add Category", isPresented: $showingAddCategory) {
            TextField("Category name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Add") {
                addCategory()
            }
        } message: {
            Text("Enter the name for the new category")
        }
        .alert("Error", isPresented: $showingAddError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "folder.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryPurple.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No categories")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add the first one")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Button(action: {
                showingAddCategory = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Category")
                }
                .font(AppFonts.headline)
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.buttonBackground)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var categoriesListView: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.categories, id: \.self) { category in
                CategoryRow(
                    category: category,
                    isEditing: editingCategory == category,
                    editedName: $editedCategoryName,
                    onEdit: { startEditing(category) },
                    onSave: { saveEdit() },
                    onCancel: { cancelEdit() },
                    onDelete: { deleteCategory(category) }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private func addCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            errorMessage = "Enter category name"
            showingAddError = true
        } else if viewModel.categories.contains(trimmedName) {
            errorMessage = "This category already exists"
            showingAddError = true
        } else {
            viewModel.addCategory(trimmedName)
        }
        
        newCategoryName = ""
    }
    
    private func startEditing(_ category: String) {
        editingCategory = category
        editedCategoryName = category
    }
    
    private func saveEdit() {
        guard let oldName = editingCategory else { return }
        
        let trimmedName = editedCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedName.isEmpty && trimmedName != oldName {
            viewModel.updateCategory(oldName: oldName, newName: trimmedName)
        }
        
        cancelEdit()
    }
    
    private func cancelEdit() {
        editingCategory = nil
        editedCategoryName = ""
    }
    
    private func deleteCategory(_ category: String) {
        viewModel.deleteCategory(category)
    }
}

struct CategoryRow: View {
    let category: String
    let isEditing: Bool
    @Binding var editedName: String
    let onEdit: () -> Void
    let onSave: () -> Void
    let onCancel: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("Category name", text: $editedName)
                    .font(AppFonts.body)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save", action: onSave)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryPurple)
                
                Button("Cancel", action: onCancel)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
            } else {
                Text(category)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onEdit()
                    }
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.destructiveButton)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient.cardGradient)
                .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
        )
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This category will be removed from the list but will remain in existing entries.")
        }
    }
}

#Preview {
    NavigationView {
        CategoriesView(viewModel: ScentDiaryViewModel())
    }
}
