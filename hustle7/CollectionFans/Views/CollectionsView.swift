import SwiftUI

struct CollectionsView: View {
    @ObservedObject var store: CollectionStore
    @State private var showingCreateCollection = false
    @State private var showingSortMenu = false
    @State private var selectedCollection: Collection?
    @State private var showingDeleteAlert = false
    @State private var collectionToDelete: Collection?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if store.collections.isEmpty {
                        emptyStateView
                    } else {
                        collectionsListView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreateCollection) {
                CreateEditCollectionView(store: store, collection: selectedCollection)
            }
            .actionSheet(isPresented: $showingSortMenu) {
                sortActionSheet
            }
            .alert("Delete Collection", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let collection = collectionToDelete {
                        store.deleteCollection(collection)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this collection and all its items?")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Collections")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
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
                    selectedCollection = nil
                    showingCreateCollection = true
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
            
            Image(systemName: "folder")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 8) {
                Text("No collections yet")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text("Create your first collection to get started")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                selectedCollection = nil
                showingCreateCollection = true
            }) {
                Text("Create First Collection")
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
    
    private var collectionsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(store.sortedCollections) { collection in
                    NavigationLink(destination: CollectionItemsView(store: store, collectionId: collection.id)) {
                        CollectionCard(
                            collection: collection,
                            onTap: { },
                        onEdit: {
                            selectedCollection = collection
                            showingCreateCollection = true
                        },
                        onDelete: {
                            collectionToDelete = collection
                            showingDeleteAlert = true
                        }
                    )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort Collections"),
            buttons: [
                .default(Text("Alphabetical")) {
                    store.collectionSortOption = .alphabetical
                },
                .default(Text("Item Count")) {
                    store.collectionSortOption = .itemCount
                },
                .default(Text("Date Created")) {
                    store.collectionSortOption = .dateCreated
                },
                .cancel()
            ]
        )
    }
}

struct CollectionCard: View {
    let collection: Collection
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingActions = false
    
    var body: some View {
            HStack(spacing: 16) {
                Image(systemName: collection.category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primaryBlue)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(Color.lightBlue.opacity(0.2)))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(collection.name)
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Text("\(collection.itemCount) items")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
            )
    }
}

#Preview {
    CollectionsView(store: CollectionStore())
}
