import SwiftUI

struct CatalogView: View {
    @EnvironmentObject var itemStore: ItemStore
    @State private var showingAddItem = false
    @State private var showingFilterSheet = false
    @State private var showingMenuDialog = false
    @State private var showingSortDialog = false
    @State private var showingClearAlert = false
    @State private var itemToEdit: Item?
    @State private var selectedItemId: UUID?
    @State private var showingItemDetail = false
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HeaderView()
                
                if itemStore.items.isEmpty {
                    EmptyStateView()
                } else {
                    ItemListView()
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddEditItemView(item: nil)
                .environmentObject(itemStore)
        }
        .sheet(item: $itemToEdit) { item in
            AddEditItemView(item: item)
                .environmentObject(itemStore)
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheetView()
                .environmentObject(itemStore)
        }
        .confirmationDialog("Sort Items", isPresented: $showingSortDialog) {
            Button("By Date ↓") {
                itemStore.sortOption = .dateDescending
            }
            Button("A→Z") {
                itemStore.sortOption = .alphabetical
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Clear Catalog", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                itemStore.clearAllItems()
            }
        } message: {
            Text("Are you sure you want to delete all items? This action cannot be undone.")
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
    private func HeaderView() -> some View {
        HStack {
            Text("My Items")
                .font(.playfairTitleLarge(28))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingAddItem = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.buttonText)
                        .frame(width: 40, height: 40)
                        .background(Color.buttonPrimary)
                        .clipShape(Circle())
                }
                
                Button(action: { showingMenuDialog = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textSecondary)
                        .frame(width: 40, height: 40)
                        .background(Color.buttonSecondary)
                        .clipShape(Circle())
                }
                .confirmationDialog("Menu", isPresented: $showingMenuDialog, titleVisibility: .hidden) {
                    Button("Sort") {
                        showingSortDialog = true
                    }
                    Button("Filter by Category") {
                        showingFilterSheet = true
                    }
                    if !itemStore.selectedCategories.isEmpty {
                        Button("Reset Filter") {
                            itemStore.resetFilter()
                        }
                    }
                    Button("Clear Catalog", role: .destructive) {
                        showingClearAlert = true
                    }
                    Button("Cancel", role: .cancel) { }
                }
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
                Image(systemName: "archivebox")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.textSecondary)
                
                VStack(spacing: 12) {
                    Text("No Items Yet")
                        .font(.playfairHeading(24))
                        .foregroundColor(.textPrimary)
                    
                    Text("You haven't added any items yet.\nAdd your first item to get started.")
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
                    Text("Add First Item")
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
    private func ItemListView() -> some View {
        VStack(spacing: 0) {
            if !itemStore.selectedCategories.isEmpty {
                HStack {
                    Text("Filtered by: \(itemStore.selectedCategories.joined(separator: ", "))")
                        .font(.playfairCaption(14))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Button("Reset") {
                        itemStore.resetFilter()
                    }
                    .font(.playfairCaptionMedium(14))
                    .foregroundColor(.primaryYellow)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(itemStore.filteredAndSortedItems) { item in
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
            }
            
            HStack {
                Text("Total Items: \(itemStore.filteredAndSortedItems.count)")
                    .font(.playfairCaption(14))
                    .foregroundColor(.textSecondary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .padding(.bottom, 100)
    }
}

struct ItemCardView: View {
    let item: Item
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.playfairHeading(18))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Text("Category: \(item.category)")
                        .font(.playfairCaption(14))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Text(DateFormatter.displayDate.string(from: item.dateAdded))
                    .font(.playfairSmall(12))
                    .foregroundColor(.textTertiary)
            }
            
            if !item.story.isEmpty {
                Text(item.storyPreview)
                    .font(.playfairBody(14))
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                    .lineSpacing(2)
            }
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
            Button("Delete", role: .destructive) {
                showingDeleteAlert = true
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Edit") {
                onEdit()
            }
            .tint(.accentGreen)
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(item.name)\"?")
        }
    }
}

struct FilterSheetView: View {
    @EnvironmentObject var itemStore: ItemStore
    @Environment(\.dismiss) private var dismiss
    @State private var tempSelectedCategories: Set<String> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(itemStore.categories, id: \.id) { category in
                                HStack {
                                    Text(category.name)
                                        .font(.playfairBody(16))
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    if tempSelectedCategories.contains(category.name) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.primaryYellow)
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if tempSelectedCategories.contains(category.name) {
                                        tempSelectedCategories.remove(category.name)
                                    } else {
                                        tempSelectedCategories.insert(category.name)
                                    }
                                }
                                
                                if category.id != itemStore.categories.last?.id {
                                    Divider()
                                        .background(Color.cardBorder)
                                        .padding(.leading, 20)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    HStack(spacing: 16) {
                        Button {
                            tempSelectedCategories.removeAll()
                        } label: {
                            Text("Reset")
                                .font(.playfairBody(16))
                                .foregroundColor(.textPrimary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.buttonSecondary)
                                .cornerRadius(22)
                        }
                        
                        Button {
                            itemStore.selectedCategories = tempSelectedCategories
                            dismiss()
                        } label: {
                            Text("Apply")
                                .font(.playfairBody(16))
                                .foregroundColor(.buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.buttonPrimary)
                                .cornerRadius(22)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Filter Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
        .onAppear {
            tempSelectedCategories = itemStore.selectedCategories
        }
    }
}

extension DateFormatter {
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    CatalogView()
        .environmentObject(ItemStore())
}
