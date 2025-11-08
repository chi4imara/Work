import SwiftUI

struct CategoriesView: View {
    @ObservedObject var store: VictoryStore
    @State private var showingAddCategory = false
    @State private var editingCategory: Category?
    @State private var editingCategoryName = ""
    @State private var showingDeleteAlert = false
    @State private var categoryToDelete: Category?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .opacity(0)
                    }
                    .disabled(true)
                    
                    Text("Categories")
                        .font(AppFonts.navigationTitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button {
                        showingAddCategory = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryYellow)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                
                if store.categories.isEmpty {
                    EmptyStateView(
                        iconName: "folder",
                        title: "No Categories",
                        subtitle: "Create your first category to organize your victories",
                        buttonTitle: "Add Category"
                    ) {
                        showingAddCategory = true
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(store.categories) { category in
                                CategoryRowView(
                                    category: category,
                                    isEditing: editingCategory?.id == category.id,
                                    editingName: $editingCategoryName,
                                    onEdit: {
                                        editingCategory = category
                                        editingCategoryName = category.name
                                    },
                                    onSave: {
                                        saveCategory(category)
                                    },
                                    onCancel: {
                                        editingCategory = nil
                                        editingCategoryName = ""
                                    },
                                    onDelete: {
                                        categoryToDelete = category
                                        showingDeleteAlert = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView(store: store) { _ in }
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                categoryToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    store.deleteCategory(category)
                    categoryToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete this category? Victories using this category will no longer have a category assigned.")
        }
    }
    
    private func saveCategory(_ category: Category) {
        let trimmedName = editingCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else { return }
        guard !store.categories.contains(where: { $0.id != category.id && $0.name.lowercased() == trimmedName.lowercased() }) else { return }
        
        let updatedCategory = Category(id: category.id, name: trimmedName)
        store.updateCategory(updatedCategory)
        
        editingCategory = nil
        editingCategoryName = ""
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
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "folder.fill")
                .font(.title3)
                .foregroundColor(AppColors.primaryYellow)
                .frame(width: 24)
            
            if isEditing {
                TextField("Category name", text: $editingName)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.horizontal)
                    .padding(.vertical, 3)
                    .background(.black.opacity(0.4))
                    .cornerRadius(12)
                
                Button("Save") {
                    onSave()
                }
                .font(AppFonts.headline)
                .foregroundColor(AppColors.success)
                
                Button("Cancel") {
                    onCancel()
                }
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textSecondary)
            } else {
                Text(category.name)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.error)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    CategoriesView(store: VictoryStore())
}
