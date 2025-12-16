import SwiftUI

struct ProductsInLocationView: View {
    let location: StorageLocation
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var searchViewModel = ProductsListViewModel()
    @State private var showingAddProduct = false
    
    var filteredProducts: [Product] {
        let locationProducts = appViewModel.storageLocations
            .first(where: { $0.id == location.id })?
            .products ?? []
        
        return searchViewModel.filteredProducts(from: locationProducts)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(location.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .lineLimit(2)
                            
                            if !location.description.isEmpty {
                                Text(location.description)
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(AppColors.secondaryText)
                                    .lineLimit(2)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddProduct = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(AppColors.primaryYellow)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                        VStack(spacing: 12) {
                            SearchBarView(
                                searchText: $searchViewModel.searchText,
                                placeholder: "Search products..."
                            )
                            
                            FilterButtonsView(selectedFilter: $searchViewModel.selectedFilter)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                }
                .padding(.top, 10)
                
                if filteredProducts.isEmpty && searchViewModel.searchText.isEmpty {
                    EmptyProductsView(showingAddProduct: $showingAddProduct)
                } else if filteredProducts.isEmpty {
                    NoSearchResultsView()
                } else {
                    ProductsList(
                        products: filteredProducts,
                        onDelete: { product in
                            appViewModel.deleteProduct(product)
                        },
                        onMove: { product in
                        }
                    )
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .sheet(isPresented: $showingAddProduct) {
            AddProductView(storageLocationId: location.id)
                .environmentObject(appViewModel)
        }
    }
}

struct EmptyProductsView: View {
    @Binding var showingAddProduct: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "cube.box")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("No products yet")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Add your first cosmetic product to this storage place.")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Button(action: {
                showingAddProduct = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("Add Product")
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

struct NoSearchResultsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 8) {
                Text("No results found")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Try adjusting your search or filters")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
    }
}

struct FilterButtonsView: View {
    @Binding var selectedFilter: ProductFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ProductFilter.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter,
                        action: {
                            selectedFilter = filter
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? AppColors.darkText : AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.primaryYellow : AppColors.secondaryButtonBackground)
                .cornerRadius(20)
        }
    }
}

struct ProductsList: View {
    let products: [Product]
    let onDelete: (Product) -> Void
    let onMove: (Product) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(products) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductCard(
                            product: product,
                            onDelete: { onDelete(product) },
                            onMove: { onMove(product) }
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

struct ProductCard: View {
    let product: Product
    let onDelete: () -> Void
    let onMove: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.darkText)
                        .lineLimit(2)
                    
                    Text(product.category.displayName)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.accentPurple)
                }
                
                Spacer()
                
                if product.isExpiringSoon {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(AppColors.warningRed)
                        .font(.system(size: 16))
                }
            }
            
            HStack {
                Text(product.brand)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.darkText.opacity(0.7))
                
                Spacer()
                
                if let expirationDate = product.expirationDate {
                    Text("Exp: \(expirationDate, formatter: DateFormatter.shortDate)")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(product.isExpiringSoon ? AppColors.warningRed : AppColors.darkText.opacity(0.6))
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Move") {
                onMove()
            }
            .tint(.blue)
            
            Button("Delete") {
                showingDeleteAlert = true
            }
            .tint(.red)
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(product.name)\"?")
        }
    }
}


#Preview {
    NavigationView {
        ProductsInLocationView(location: StorageLocation(name: "Test Location", description: "Test Description", icon: "box.fill"))
            .environmentObject(AppViewModel())
    }
}
