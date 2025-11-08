import SwiftUI

struct CustomCategoriesView: View {
    @ObservedObject var viewModel: SeriesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddCategory = false
    @State private var editingCategory: CustomCategory?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.bodyLarge)
                        .foregroundColor(.primaryBlue)
                        
                        Spacer()
                        
                        Text("Custom Categories")
                            .font(.titleSmall)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button("Add") {
                            showingAddCategory = true
                        }
                        .font(.bodyLarge)
                        .foregroundColor(.primaryBlue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if viewModel.customCategories.isEmpty {
                        VStack(spacing: 24) {
                            Spacer()
                            
                            Image(systemName: "folder.badge.plus")
                                .font(.system(size: 60))
                                .foregroundColor(.textSecondary)
                            
                            Text("No custom categories yet")
                                .font(.titleMedium)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text("Create your own categories to organize your series")
                                .font(.bodyLarge)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                showingAddCategory = true
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Create First Category")
                                }
                                .font(.titleSmall)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.primaryBlue)
                                .cornerRadius(12)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.customCategories, id: \.id) { category in
                                CustomCategoryManagementRow(
                                    category: category,
                                    seriesCount: viewModel.series.filter { $0.customCategoryId == category.id }.count,
                                    onEdit: {
                                        editingCategory = category
                                    },
                                    onDelete: {
                                        viewModel.deleteCustomCategory(category)
                                    }
                                )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddCategory) {
            AddEditCustomCategoryView(viewModel: viewModel, editingCategory: nil)
        }
        .sheet(item: $editingCategory) { category in
            AddEditCustomCategoryView(viewModel: viewModel, editingCategory: category)
        }
    }
}

struct CustomCategoryManagementRow: View {
    let category: CustomCategory
    let seriesCount: Int
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(categoryColor(for: category.color).opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(categoryColor(for: category.color))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.titleSmall)
                    .foregroundColor(.textPrimary)
                
                Text("\(seriesCount) series")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryBlue)
                        .frame(width: 32, height: 32)
                        .background(Color.lightBlue.opacity(0.3))
                        .clipShape(Circle())
                }
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.accentRed)
                        .frame(width: 32, height: 32)
                        .background(Color.accentRed.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this category? Series in this category will be moved to 'Other'.")
        }
    }
    
    private func categoryColor(for colorName: String) -> Color {
        switch colorName {
        case "primaryBlue":
            return .primaryBlue
        case "accentGreen":
            return .accentGreen
        case "accentOrange":
            return .accentOrange
        case "accentRed":
            return .accentRed
        default:
            return .primaryBlue
        }
    }
}

struct AddEditCustomCategoryView: View {
    @ObservedObject var viewModel: SeriesViewModel
    let editingCategory: CustomCategory?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedIcon: String = "tv"
    @State private var selectedColor: String = "primaryBlue"
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let availableIcons = ["tv", "film", "theatermasks", "face.smiling", "sparkles", "heart", "star", "flame", "leaf", "gamecontroller"]
    private let availableColors = [
        ("primaryBlue", "Blue"),
        ("accentGreen", "Green"),
        ("accentOrange", "Orange"),
        ("accentRed", "Red")
    ]
    
    private var isEditing: Bool {
        editingCategory != nil
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.bodyLarge)
                        .foregroundColor(.primaryBlue)
                        
                        Spacer()
                        
                        Text(isEditing ? "Edit Category" : "New Category")
                            .font(.titleSmall)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveCategory()
                        }
                        .font(.bodyLarge)
                        .foregroundColor(canSave ? .primaryBlue : .textSecondary)
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category Name")
                                    .font(.titleSmall)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("Enter category name", text: $name)
                                    .font(.bodyLarge)
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.lightBlue, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Icon")
                                    .font(.titleSmall)
                                    .foregroundColor(.textPrimary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                                    ForEach(availableIcons, id: \.self) { icon in
                                        Button(action: {
                                            selectedIcon = icon
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(selectedIcon == icon ? categoryColor(for: selectedColor) : Color.lightBlue.opacity(0.3))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: icon)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(selectedIcon == icon ? .white : .textSecondary)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Color")
                                    .font(.titleSmall)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: 12) {
                                    ForEach(availableColors, id: \.0) { colorName, displayName in
                                        Button(action: {
                                            selectedColor = colorName
                                        }) {
                                            VStack(spacing: 4) {
                                                Circle()
                                                    .fill(categoryColor(for: colorName))
                                                    .frame(width: 40, height: 40)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(selectedColor == colorName ? Color.black : Color.clear, lineWidth: 2)
                                                    )
                                                
                                                Text(displayName)
                                                    .font(.captionSmall)
                                                    .foregroundColor(.textSecondary)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if let category = editingCategory {
                name = category.name
                selectedIcon = category.icon
                selectedColor = category.color
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveCategory() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter category name"
            showingError = true
            return
        }
        
        if let editingCategory = editingCategory {
            var updatedCategory = editingCategory
            updatedCategory.name = trimmedName
            updatedCategory.icon = selectedIcon
            updatedCategory.color = selectedColor
            
            viewModel.updateCustomCategory(updatedCategory)
        } else {
            let newCategory = CustomCategory(
                name: trimmedName,
                icon: selectedIcon,
                color: selectedColor
            )
            
            viewModel.addCustomCategory(newCategory)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func categoryColor(for colorName: String) -> Color {
        switch colorName {
        case "primaryBlue":
            return .primaryBlue
        case "accentGreen":
            return .accentGreen
        case "accentOrange":
            return .accentOrange
        case "accentRed":
            return .accentRed
        default:
            return .primaryBlue
        }
    }
}
