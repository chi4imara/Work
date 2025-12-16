import SwiftUI

struct CategoriesView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var editingCategory: Category?
    @State private var editingCategoryName = ""
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridOverlay()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if categoryViewModel.sortedCategories.isEmpty {
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
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 40, height: 40)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(20)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .opacity(0)
            .disabled(true)
            
            Spacer()
            
            Text("Categories")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
            
            Button(action: {
                showingAddCategory = true
                newCategoryName = ""
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 40, height: 40)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(20)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 15) {
                Text("No categories")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                
                Text("Add your first category")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddCategory = true
                newCategoryName = ""
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Category")
                }
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(AppColors.primaryBlue)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(categoryViewModel.sortedCategories) { category in
                    CategoryRowView(
                        category: category,
                        isEditing: editingCategory?.id == category.id,
                        editingName: $editingCategoryName,
                        onEdit: {
                            editingCategory = category
                            editingCategoryName = category.name
                        },
                        onSave: {
                            saveEditedCategory(category)
                        },
                        onCancel: {
                            editingCategory = nil
                            editingCategoryName = ""
                        },
                        onDelete: {
                            categoryViewModel.deleteCategory(category)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
    
    private var addCategorySheet: some View {
        VStack(spacing: 30) {
            Text("Add Category")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
                .padding(.top, 30)
            
            TextField("Enter category name", text: $newCategoryName)
                .font(.ubuntu(16))
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(AppColors.backgroundWhite)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 20)
            
            HStack(spacing: 15) {
                Button("Cancel") {
                    showingAddCategory = false
                    newCategoryName = ""
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.lightGray)
                .cornerRadius(25)
                
                Button {
                    addNewCategory()
                } label: {
                    Text("Add")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(25)
                }
                .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 20)
        }
        .background(AppColors.lightGray)
        .presentationDetents([.height(200)])
    }
    
    private var backButtonView: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Back to Recipe List")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.primaryBlue)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private func addNewCategory() {
        let success = categoryViewModel.addCategory(newCategoryName)
        
        if success {
            showingAddCategory = false
            newCategoryName = ""
        } else {
            if newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                validationMessage = "Please enter a category name"
            } else {
                validationMessage = "This category already exists"
            }
            showingValidationAlert = true
        }
    }
    
    private func saveEditedCategory(_ category: Category) {
        let success = categoryViewModel.updateCategory(category, newName: editingCategoryName)
        
        if success {
            editingCategory = nil
            editingCategoryName = ""
        } else {
            if editingCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                validationMessage = "Please enter a category name"
            } else {
                validationMessage = "This category already exists"
            }
            showingValidationAlert = true
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
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("Category name", text: $editingName)
                    .font(.ubuntu(16))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.primaryYellow, lineWidth: 2)
                    )
                
                HStack(spacing: 10) {
                    Button(action: onCancel) {
                        Image(systemName: "xmark")
                            .foregroundColor(AppColors.accentOrange)
                            .frame(width: 30, height: 30)
                            .background(AppColors.backgroundWhite)
                            .cornerRadius(15)
                    }
                    
                    Button(action: onSave) {
                        Image(systemName: "checkmark")
                            .foregroundColor(AppColors.accentGreen)
                            .frame(width: 30, height: 30)
                            .background(AppColors.backgroundWhite)
                            .cornerRadius(15)
                    }
                }
            } else {
                Text(category.name)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.darkGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        onEdit()
                    }
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(AppColors.accentOrange)
                        .frame(width: 30, height: 30)
                        .background(AppColors.backgroundWhite)
                        .cornerRadius(15)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this category?")
        }
    }
}

#Preview {
    CategoriesView(categoryViewModel: CategoryViewModel())
}
