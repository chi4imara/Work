import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var itemStore: ItemStore
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var selectedCategory: Category?
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HeaderView()
                
                if itemStore.categories.isEmpty {
                    EmptyStateView()
                } else {
                    CategoriesListView()
                }
            }
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            TextField("Category Name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Add") {
                addNewCategory()
            }
        } message: {
            Text("Enter the name for the new category")
        }
        .sheet(item: $selectedCategory) { category in
            CategoryItemsView(category: category)
                .environmentObject(itemStore)
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Text("Categories")
                .font(.playfairTitleLarge(28))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: { showingNewCategoryAlert = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.buttonText)
                    .frame(width: 40, height: 40)
                    .background(Color.buttonPrimary)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private func EmptyStateView() -> some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "tag")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.textSecondary)
                
                VStack(spacing: 12) {
                    Text("No Categories Yet")
                        .font(.playfairHeading(24))
                        .foregroundColor(.textPrimary)
                    
                    Text("Categories help organize your items.\nCreate your first category to get started.")
                        .font(.playfairBody(16))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
            }
            
            Button(action: { showingNewCategoryAlert = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add First Category")
                        .font(.playfairHeading(18))
                }
                .foregroundColor(.buttonText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.buttonPrimary)
                .cornerRadius(28)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func CategoriesListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(itemStore.categories, id: \.id) { category in
                    CategoryCardView(category: category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
    
    private func addNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            let newCategory = Category(name: trimmedName)
            itemStore.addCategory(newCategory)
        }
        newCategoryName = ""
    }
}

struct CategoryCardView: View {
    @EnvironmentObject var itemStore: ItemStore
    let category: Category
    let onTap: () -> Void
    
    @State private var showingDeleteAlert = false
    
    private var itemCount: Int {
        itemStore.itemCount(for: category)
    }
    
    private var canDelete: Bool {
        itemCount == 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.primaryYellow.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "tag.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.playfairHeading(18))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Text("\(itemCount) item\(itemCount == 1 ? "" : "s")")
                    .font(.playfairCaption(14))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textTertiary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
        .onTapGesture {
            onTap()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if canDelete {
                Button("Delete", role: .destructive) {
                    showingDeleteAlert = true
                }
            }
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                itemStore.deleteCategory(category)
            }
        } message: {
            Text("Are you sure you want to delete the category \"\(category.name)\"?")
        }
    }
}

struct CategoryItemsView: View {
    @EnvironmentObject var itemStore: ItemStore
    @Environment(\.dismiss) private var dismiss
    
    let category: Category
    
    @State private var showingAddItem = false
    @State private var itemToEdit: Item?
    @State private var selectedItemId: UUID?
    @State private var showingItemDetail = false
    
    private var categoryItems: [Item] {
        itemStore.items.filter { $0.category == category.name }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    if categoryItems.isEmpty {
                        CategoryEmptyStateView()
                    } else {
                        CategoryItemsListView()
                    }
                }
            }
            .navigationTitle(category.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddItem = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.buttonText)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingAddItem) {
            AddEditItemView(item: nil)
                .environmentObject(itemStore)
        }
        .sheet(item: $itemToEdit) { item in
            AddEditItemView(item: item)
                .environmentObject(itemStore)
        }
        .sheet(isPresented: $showingItemDetail, onDismiss: {
            selectedItemId = nil
        }) {
            if let itemId = selectedItemId {
                NavigationView {
                    ItemDetailView(itemId: itemId)
                        .environmentObject(itemStore)
                }
            }
        }
        .onChange(of: selectedItemId) { newValue in
            showingItemDetail = newValue != nil
        }
    }
    
    @ViewBuilder
    private func CategoryEmptyStateView() -> some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "archivebox")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.textSecondary)
                
                VStack(spacing: 12) {
                    Text("No Items in \(category.name)")
                        .font(.playfairHeading(24))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Add your first item to this category to get started.")
                        .font(.playfairBody(16))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
            }
            
            Button(action: { showingAddItem = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Item")
                        .font(.playfairHeading(18))
                }
                .foregroundColor(.buttonText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.buttonPrimary)
                .cornerRadius(28)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func CategoryItemsListView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(categoryItems.count) item\(categoryItems.count == 1 ? "" : "s")")
                    .font(.playfairCaption(14))
                    .foregroundColor(.textSecondary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(categoryItems) { item in
                        ItemCardView(item: item, onTap: {
                            selectedItemId = item.id
                        }, onEdit: {
                            itemToEdit = item
                        }, onDelete: {
                            itemStore.deleteItem(item)
                        })
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    CategoriesView()
        .environmentObject(ItemStore())
}
