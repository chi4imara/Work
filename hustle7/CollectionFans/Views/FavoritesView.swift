import SwiftUI

struct FavoritesView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var store: CollectionStore
    @State private var showingSortMenu = false
    @State private var showingClearAlert = false
    @State private var showingEditItem = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if store.favoriteItems.isEmpty {
                        emptyStateView
                    } else {
                        favoritesListView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditItem) {
                
                if let item = store.selectedItem, let collectionId = store.getCollectionId(for: item)
                
                
                {
                    CreateEditItemView(store: store, collectionId: collectionId, item: $store.selectedItem)
                }
            }
            .actionSheet(isPresented: $showingSortMenu) {
                sortActionSheet
            }
            .alert("Clear Favorites", isPresented: $showingClearAlert) {
                Button("Clear All", role: .destructive) {
                    store.clearFavorites()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to remove all items from favorites?")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if !store.favoriteItems.isEmpty {
                Button(action: { showingSortMenu = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primaryBlue)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.lightBlue.opacity(0.2)))
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
            
            Image(systemName: "star")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 8) {
                Text("No favorites yet")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text("Add items to favorites to see them here")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            Button {
                appState.selectedTab = 0
            } label: {
                Text("Browse Collections")
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
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(store.favoriteItems) { item in
                    FavoriteItemCard(
                        item: item,
                        collectionName: store.getCollectionName(for: item),
                        onTap: {
                            store.selectedItem = item
                            showingEditItem = true
                        },
                        onRemoveFromFavorites: {
                            if let collectionId = store.getCollectionId(for: item) {
                                store.toggleItemFavorite(item, in: collectionId)
                            }
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
            title: Text("Sort Favorites"),
            buttons: [
                .default(Text("By Collection")) {
                    store.favoriteSortOption = .collection
                },
                .default(Text("Date Added")) {
                    store.favoriteSortOption = .dateAdded
                },
                .default(Text("Alphabetical")) {
                    store.favoriteSortOption = .alphabetical
                },
                .default(Text("Clear All Favorites")) {
                    showingClearAlert = true
                },
                .cancel()
            ]
        )
    }
}

struct FavoriteItemCard: View {
    let item: Item
    let collectionName: String
    let onTap: () -> Void
    let onRemoveFromFavorites: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Button(action: onTap) {
                HStack(spacing: 16) {
                    Image(systemName: item.status.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(statusColor(for: item.status))
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.name)
                            .font(.titleSmall)
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                        
                        Text(collectionName)
                            .font(.captionMedium)
                            .foregroundColor(.textLight)
                            .lineLimit(1)
                        
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.accentOrange.opacity(0.3), lineWidth: 2)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: onRemoveFromFavorites) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.accentOrange)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                Spacer()
            }
            .padding(8)
        }
    }
    
    private func statusColor(for status: ItemStatus) -> Color {
        switch status {
        case .inCollection: return .statusInCollection
        case .wishlist: return .statusWishlist
        case .forTrade: return .statusForTrade
        }
    }
}

