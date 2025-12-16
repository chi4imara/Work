import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack {
                    HStack {
                        Text("Categories")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showingAddCategory = true }) {
                            Image(systemName: "plus")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                    if dataManager.categories.isEmpty {
                        emptyStateView
                        
                        Spacer()
                    } else {
                        categoriesList
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView(categoryName: $newCategoryName) {
                if !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let category = Category(name: newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines))
                    dataManager.addCategory(category)
                    newCategoryName = ""
                    showingAddCategory = false
                }
            }
        }
    }
    
    private var categoriesList: some View {
        List {
            ForEach(dataManager.categories) { category in
                NavigationLink(destination: CategoryChallengesView(category: category)
                    .environmentObject(dataManager)) {
                    CategoryRowView(category: category)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteCategories)
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No categories created yet")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            Button {
                showingAddCategory = true
            } label: {
                Text("Create Category")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(40)
    }
    
    private func deleteCategories(offsets: IndexSet) {
        let categoriesToDelete = offsets.compactMap { index -> Category? in
            guard index < dataManager.categories.count else { return nil }
            return dataManager.categories[index]
        }
        
        for category in categoriesToDelete {
            dataManager.deleteCategory(category)
        }
    }
}

struct CategoryRowView: View {
    @EnvironmentObject var dataManager: DataManager
    let category: Category
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(dataManager.getChallengeCount(for: category)) challenges")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text("\(dataManager.getChallengeCount(for: category))")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppColors.primary.opacity(0.1))
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

struct AddCategoryView: View {
    @Binding var categoryName: String
    let onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TextField("Category Name", text: $categoryName)
                        .font(.ubuntu(16))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                    .foregroundColor(AppColors.primary)
                    .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct CategoryPickerView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedCategory: Category?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    Button(action: {
                        selectedCategory = nil
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text("All Categories")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            if selectedCategory == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    ForEach(dataManager.categories) { category in
                        Button(action: {
                            selectedCategory = category
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(category.name)
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                if selectedCategory?.id == category.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

#Preview {
    CategoriesView()
        .environmentObject(DataManager.shared)
}
