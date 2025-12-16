import SwiftUI

struct StorageLocationsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var searchViewModel = ProductsListViewModel()
    @State private var showingAddLocation = false
    
    var filteredLocations: [StorageLocation] {
        if searchViewModel.searchText.isEmpty {
            return appViewModel.storageLocations.sorted { $0.name < $1.name }
        } else {
            return appViewModel.storageLocations.filter { location in
                location.name.localizedCaseInsensitiveContains(searchViewModel.searchText) ||
                location.description.localizedCaseInsensitiveContains(searchViewModel.searchText)
            }.sorted { $0.name < $1.name }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("My Storage Places")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddLocation = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(AppColors.primaryYellow)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        SearchBarView(searchText: $searchViewModel.searchText, placeholder: "Search by name or type...")
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                    }
                    .padding(.top, 10)
                    
                    if !appViewModel.recentlyAddedProducts.isEmpty {
                        RecentlyAddedWidget()
                            .environmentObject(appViewModel)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                    }
                    
                    if appViewModel.storageLocations.isEmpty {
                        EmptyStorageView(showingAddLocation: $showingAddLocation)
                    } else {
                        StorageLocationsList(
                            locations: filteredLocations,
                            onDelete: { location in
                                appViewModel.deleteStorageLocation(location)
                            }
                        )
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddLocation) {
            AddStorageLocationView()
                .environmentObject(appViewModel)
        }
    }
}

struct EmptyStorageView: View {
    @Binding var showingAddLocation: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "archivebox")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("No storage places yet")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Create your first storage place — for example, \"Dresser\" or \"Travel makeup bag\".")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Button(action: {
                showingAddLocation = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("Add Place")
                        .font(.ubuntu(18, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.buttonBackground)
                .cornerRadius(16)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct StorageLocationsList: View {
    let locations: [StorageLocation]
    let onDelete: (StorageLocation) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(locations) { location in
                    NavigationLink(destination: ProductsInLocationView(location: location)) {
                        StorageLocationCard(
                            location: location,
                            onDelete: { onDelete(location) }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct StorageLocationCard: View {
    let location: StorageLocation
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: location.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(location.name)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.darkText)
                    .lineLimit(1)
                
                if !location.description.isEmpty {
                    Text(location.description)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.darkText.opacity(0.7))
                        .lineLimit(2)
                }
                
                Text("\(location.productCount) products")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.accentPurple)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.darkText.opacity(0.5))
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete") {
                showingDeleteAlert = true
            }
            .tint(.red)
        }
        .alert("Delete Storage Place", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(location.name)\"? All products inside will also be deleted.")
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField(placeholder, text: $searchText)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.secondaryButtonBackground)
        .cornerRadius(12)
    }
}

struct RecentlyAddedWidget: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "clock.badge.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.accentPurple)
                    
                    Text("Recently Added")
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.darkText)
                }
                
                Spacer()
                
                Text("\(appViewModel.recentlyAddedProducts.count)")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(appViewModel.recentlyAddedProducts.prefix(5), id: \.id) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            RecentlyAddedCard(product: product)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
        .padding(16)
        .background(AppColors.cardBackground.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct RecentlyAddedCard: View {
    let product: Product
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(AppColors.accentPurple.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: categoryIcon(for: product.category))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.accentPurple)
            }
            
            VStack(spacing: 2) {
                Text(product.name)
                    .font(.ubuntu(11, weight: .bold))
                    .foregroundColor(AppColors.darkText)
                    .lineLimit(1)
                    .frame(width: 80)
                
                Text(product.brand)
                    .font(.ubuntu(9, weight: .regular))
                    .foregroundColor(AppColors.darkText.opacity(0.6))
                    .lineLimit(1)
                    .frame(width: 80)
                
                Text(RelativeDateTimeFormatter().localizedString(for: product.createdAt, relativeTo: Date()))
                    .font(.ubuntu(8, weight: .regular))
                    .foregroundColor(AppColors.darkText.opacity(0.5))
            }
        }
        .frame(width: 90)
        .padding(8)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
    
    private func categoryIcon(for category: ProductCategory) -> String {
        switch category {
        case .lipstick, .lipgloss: return "mouth.fill"
        case .foundation, .concealer: return "face.smiling.fill"
        case .eyeshadow: return "eye.fill"
        case .mascara, .eyeliner: return "eye.trianglebadge.exclamationmark.fill"
        case .blush, .bronzer: return "face.dashed.fill"
        case .highlighter: return "sparkles"
        case .primer, .powder: return "circle.fill"
        case .skincare: return "drop.fill"
        case .other: return "star.fill"
        }
    }
}

#Preview {
    StorageLocationsView()
        .environmentObject(AppViewModel())
}
