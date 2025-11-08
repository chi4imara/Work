import SwiftUI

struct CollectionItemsView: View {
    @ObservedObject var store: CollectionStore
    let collectionId: UUID
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingCreateItem = false
    @State private var showingSortMenu = false
    @State private var selectedItem: Item?
    @State private var showingDeleteAlert = false
    @State private var itemToDelete: Item?
    
    private var collection: Collection? {
        store.getCollection(by: collectionId)
    }
    
    private var sortedItems: [Item] {
        guard let collection = collection else { return [] }
        return store.sortedItems(for: collection)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if sortedItems.isEmpty {
                    emptyStateView
                } else {
                    itemsListView
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreateItem) {
            CreateEditItemView(store: store, collectionId: collectionId, item: $selectedItem)
        }
        .actionSheet(isPresented: $showingSortMenu) {
            sortActionSheet
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let item = itemToDelete {
                    store.deleteItem(item, from: collectionId)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this item?")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(collection?.name ?? "Collection")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Text("\(sortedItems.count) items")
                    .font(.captionMedium)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingSortMenu = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primaryBlue)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.lightBlue.opacity(0.2)))
                }
                
                Button(action: {
                    selectedItem = nil
                        showingCreateItem = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.primaryBlue))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 8) {
                Text("No items in this collection")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text("Add your first item to get started")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                selectedItem = nil
                showingCreateItem = true
            }) {
                Text("Add First Item")
                    .font(.buttonMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primaryBlue)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    private var itemsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(sortedItems) { item in
                    ItemCard(
                        item: item,
                        collectionName: collection?.name ?? "",
                        onTap: {
                            selectedItem = item
                                showingCreateItem = true
                        },
                        onEdit: {
                            selectedItem = item
                            showingCreateItem = true
                        },
                        onDelete: {
                            itemToDelete = item
                            showingDeleteAlert = true
                        },
                        onToggleFavorite: {
                            store.toggleItemFavorite(item, in: collectionId)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort Items"),
            buttons: [
                .default(Text("Alphabetical")) {
                    store.itemSortOption = .alphabetical
                },
                .default(Text("Date Added")) {
                    store.itemSortOption = .dateAdded
                },
                .default(Text("Status")) {
                    store.itemSortOption = .status
                },
                .cancel()
            ]
        )
    }
}

struct ItemCard: View {
    let item: Item
    let collectionName: String
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onToggleFavorite: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
            Button(action: onTap) {
                HStack(spacing: 16) {
                    Image(systemName: item.status.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(statusColor(for: item.status))
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.name)
                                .font(.titleSmall)
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Button(action: onToggleFavorite) {
                                Image(systemName: item.isFavorite ? "star.fill" : "star")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(item.isFavorite ? .accentOrange : .textSecondary)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        HStack {
                            Text(item.status.rawValue)
                                .font(.captionMedium)
                                .foregroundColor(statusColor(for: item.status))
                            
                            if let condition = item.condition {
                                Text("• \(condition.rawValue)")
                                    .font(.captionMedium)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        if !item.description.isEmpty {
                            Text(item.description)
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
    }
    
    private func statusColor(for status: ItemStatus) -> Color {
        switch status {
        case .inCollection: return .statusInCollection
        case .wishlist: return .statusWishlist
        case .forTrade: return .statusForTrade
        }
    }
}

#Preview {
    CollectionItemsView(store: CollectionStore(), collectionId: UUID())
}
