import SwiftUI

struct SheetItem: Identifiable {
    let id = UUID()
    let type: SheetType
    
    enum SheetType {
        case addCollection
    }
}

struct CollectionsView: View {
    @StateObject private var collectionsViewModel = CollectionsViewModel()
    @EnvironmentObject var movieListViewModel: MovieListViewModel
    @State private var editingCollection: MovieCollection?
    @State private var collectionToDelete: MovieCollection?
    @State private var showingDeleteAlert = false
    @State private var selectedCollection: MovieCollection?
    @State private var showingAddCollection: SheetItem?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if collectionsViewModel.collections.isEmpty {
                    emptyStateView
                } else {
                    collectionsGridView
                }
            }
        }
        .sheet(item: $showingAddCollection) { item in
            switch item.type {
            case .addCollection:
                AddEditCollectionView(
                    collectionsViewModel: collectionsViewModel
                )
            }
        }
        .sheet(item: $editingCollection) { collection in
            AddEditCollectionView(
                collectionsViewModel: collectionsViewModel,
                collectionToEdit: collection
            )
        }
        .sheet(item: $selectedCollection) { collection in
            CollectionDetailView(
                collectionsViewModel: collectionsViewModel,
                movieListViewModel: movieListViewModel,
                collectionId: collection.id
            )
        }
        .alert("Delete Collection", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let collection = collectionToDelete {
                    collectionsViewModel.deleteCollection(collection)
                }
            }
        } message: {
            Text("Are you sure you want to delete this collection? This action cannot be undone.")
        }
        .alert("Error", isPresented: $collectionsViewModel.showingError) {
            Button("OK") { }
        } message: {
            Text(collectionsViewModel.errorMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Collections")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddCollection = SheetItem(type: .addCollection) }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(AppColors.blueGradient)
                    )
                    .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var collectionsGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(collectionsViewModel.collections) { collection in
                    CollectionCardView(
                        collection: collection,
                        movieCount: collectionsViewModel.getMoviesForCollection(collection, allMovies: movieListViewModel.movies).count,
                        onTap: {
                            selectedCollection = collection
                        },
                        onEdit: {
                            editingCollection = collection
                        },
                        onDelete: {
                            collectionToDelete = collection
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            Text("No Collections")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Create your first collection to organize movies")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Button(action: { showingAddCollection = SheetItem(type: .addCollection) }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Create Collection")
                }
                .font(AppFonts.bodyMedium)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.blueGradient)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CollectionCardView: View {
    let collection: MovieCollection
    let movieCount: Int
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingMenu = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                if offset.width < 0 {
                    Button(action: onDelete) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Delete")
                                .font(AppFonts.caption)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(AppColors.error)
                    }
                    .frame(width: abs(offset.width))
                }
            }
            
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .fill(collection.color.colorValue)
                            .frame(width: 12, height: 12)
                        
                        Spacer()
                        
                        Menu {
                            Button(action: onEdit) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(action: onDelete) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(collection.name)
                            .font(AppFonts.title3)
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text(collection.description)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "film")
                            .font(.system(size: 12))
                            .foregroundColor(collection.color.colorValue)
                        
                        Text("\(movieCount) movies")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        if !collection.isCustom {
                            Text("Predefined")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.accent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(AppColors.accent.opacity(0.2))
                                )
                        }
                    }
                }
                .padding(16)
                .frame(height: 160)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    CollectionsView()
        .environmentObject(MovieListViewModel())
}
