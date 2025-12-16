import SwiftUI

struct AllProductsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var searchViewModel = ProductsListViewModel()
    
    var filteredProducts: [Product] {
        searchViewModel.filteredProducts(from: appViewModel.allProducts)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("All Products")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            if !appViewModel.allProducts.isEmpty {
                                Text("\(appViewModel.allProducts.count) items")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        if !appViewModel.allProducts.isEmpty {
                            VStack(spacing: 12) {
                                SearchBarView(
                                    searchText: $searchViewModel.searchText,
                                    placeholder: "Search by name, category or brand..."
                                )
                                
                                FilterButtonsView(selectedFilter: $searchViewModel.selectedFilter)
                                
                                if searchViewModel.selectedFilter == .category {
                                    CategoryFilterView(selectedCategory: $searchViewModel.selectedCategory)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                        }
                    }
                    .padding(.top, 10)
                    
                    if appViewModel.allProducts.isEmpty {
                        EmptyAllProductsView()
                    } else if filteredProducts.isEmpty {
                        NoSearchResultsView()
                    } else {
                        AllProductsList(
                            products: filteredProducts,
                            onDelete: { product in
                                appViewModel.deleteProduct(product)
                            }
                        )
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct EmptyAllProductsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "tray")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("No products added yet")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Add products through any storage place to see them here.")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
        }
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: ProductCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button(action: {
                    selectedCategory = nil
                }) {
                    Text("All Categories")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(selectedCategory == nil ? AppColors.darkText : AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedCategory == nil ? AppColors.primaryYellow : AppColors.secondaryButtonBackground)
                        .cornerRadius(20)
                }
                
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(selectedCategory == category ? AppColors.darkText : AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? AppColors.primaryYellow : AppColors.secondaryButtonBackground)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

struct AllProductsList: View {
    let products: [Product]
    let onDelete: (Product) -> Void
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(products) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        AllProductsCard(
                            product: product,
                            storageLocation: appViewModel.getStorageLocation(for: product.id),
                            onDelete: { onDelete(product) }
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

struct AllProductsCard: View {
    let product: Product
    let storageLocation: StorageLocation?
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.darkText)
                        .lineLimit(2)
                    
                    HStack {
                        Text(product.category.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.accentPurple)
                        
                        Text("•")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.darkText.opacity(0.5))
                        
                        Text(product.brand)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.darkText.opacity(0.7))
                    }
                }
                
                Spacer()
                
                VStack {
                    if product.isExpiringSoon {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(AppColors.warningRed)
                            .font(.system(size: 16))
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.darkText.opacity(0.5))
                }
            }
            
            if let location = storageLocation {
                HStack {
                    Image(systemName: location.icon)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.accentPurple.opacity(0.7))
                    
                    Text("Stored in: \(location.name)")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.darkText.opacity(0.6))
                    
                    Spacer()
                    
                    if let expirationDate = product.expirationDate {
                        Text("Exp: \(expirationDate, formatter: DateFormatter.shortDate)")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(product.isExpiringSoon ? AppColors.warningRed : AppColors.darkText.opacity(0.6))
                    }
                }
            }
            
            if product.isExpiringSoon {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.warningRed)
                    
                    Text(product.isExpired ? "Expired" : "Expiring soon")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.warningRed)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.warningRed.opacity(0.1))
                .cornerRadius(8)
            }
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
    AllProductsView()
        .environmentObject(AppViewModel())
}
