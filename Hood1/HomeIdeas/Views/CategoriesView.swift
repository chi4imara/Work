import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: IdeasViewModel
    @State private var showingAddCategory = false
    @State private var showingRenameAlert = false
    @State private var showingDeleteAlert = false
    @State private var categoryToRename: Category?
    @State private var categoryToDelete: Category?
    @State private var newCategoryName = ""
    
    var body: some View {
        return ZStack {
            VStack(spacing: 0) {
                if viewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoriesListView
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView(viewModel: viewModel)
        }
        .alert("Rename Category", isPresented: $showingRenameAlert, presenting: categoryToRename) { category in
            TextField("Category name", text: $newCategoryName)
            Button("Save") {
                if !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    var updatedCategory = category
                    updatedCategory.name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                    viewModel.updateCategory(updatedCategory)
                }
                newCategoryName = ""
            }
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
        } message: { category in
            Text("Enter a new name for '\(category.name)'")
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert, presenting: categoryToDelete) { category in
            Button("Delete", role: .destructive) {
                viewModel.deleteCategory(category)
            }
            Button("Cancel", role: .cancel) { }
        } message: { category in
            Text("Are you sure you want to delete '\(category.name)'? Ideas using this category will be marked as 'Deleted Category'.")
        }
    }
    
    
    private var categoriesListView: some View {
        return ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.categories) { category in
                    CategoryCardView(category: category) {
                        categoryToRename = category
                        newCategoryName = category.name
                        showingRenameAlert = true
                    } onDelete: {
                        categoryToDelete = category
                        showingDeleteAlert = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var emptyStateView: some View {
        return VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No Categories")
                .font(.theme.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Text("Add categories to organize your ideas better")
                .font(.theme.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Add First Category") {
                showingAddCategory = true
            }
            .font(.theme.buttonMedium)
            .foregroundColor(AppColors.textPrimary)
            .padding(.horizontal, 25)
            .padding(.vertical, 12)
            .background(AppColors.primaryOrange)
            .cornerRadius(20)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategoryCardView: View {
    let category: Category
    let onRename: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryOrange.opacity(0.2))
                    .frame(width: 45, height: 45)
                
                Image(systemName: category.isDefault ? "star.fill" : "folder.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.primaryOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.theme.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                if category.isDefault {
                    Text("Default Category")
                        .font(.theme.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            Menu {
                Button("Rename") {
                    onRename()
                }
                
                if !category.isDefault {
                    Button("Delete", role: .destructive) {
                        onDelete()
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(8)
            }
        }
        .padding(15)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .contextMenu {
            Button("Rename") {
                onRename()
            }
            
            if !category.isDefault {
                Button("Delete", role: .destructive) {
                    onDelete()
                }
            }
        }
    }
}

struct AddCategoryView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var categoryName = ""
    @State private var nameError = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text("New Category")
                        .font(.theme.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveCategory()
                    }
                    .font(.theme.buttonMedium)
                    .foregroundColor(AppColors.primaryOrange)
                    .disabled(!isFormValid)
                }
                .padding(4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category Name")
                        .font(.theme.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    TextField("Enter category name", text: $categoryName)
                        .font(.theme.body)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(nameError.isEmpty ? AppColors.cardBorder : AppColors.error, lineWidth: 1)
                        )
                        .onChange(of: categoryName) { _ in
                            validateName()
                        }
                    
                    if !nameError.isEmpty {
                        Text(nameError)
                            .font(.theme.caption2)
                            .foregroundColor(AppColors.error)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var isFormValid: Bool {
        !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        nameError.isEmpty
    }
    
    private func validateName() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            nameError = "Category name is required"
        } else if viewModel.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) {
            nameError = "Category already exists"
        } else {
            nameError = ""
        }
    }
    
    private func saveCategory() {
        validateName()
        
        guard isFormValid else { return }
        
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        let newCategory = Category(name: trimmedName, isDefault: false)
        
        viewModel.addCategory(newCategory)
        dismiss()
    }
}

#Preview {
    CategoriesView()
        .environmentObject(IdeasViewModel())
}
