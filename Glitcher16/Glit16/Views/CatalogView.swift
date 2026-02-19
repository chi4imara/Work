import SwiftUI

struct ProductIdentifier: Identifiable {
    let id: UUID
}

struct CatalogView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State private var showingAddProduct = false
    @State private var selectedProduct: ProductIdentifier?
    
    var body: some View {
        ZStack {
            AppColorScheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFilterSection
                
                if productViewModel.filteredProducts.isEmpty {
                    emptyStateView
                } else {
                    productListView
                }
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
                .environmentObject(productViewModel)
        }
        .sheet(item: $selectedProduct) { productIdentifier in
            ProductDetailView(productId: productIdentifier.id)
                .environmentObject(productViewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Catalog")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: {
                showingAddProduct = true
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.primaryYellow)
                    .frame(width: 40, height: 40)
                    .background(Color.buttonSecondary)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchAndFilterSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                
                TextField("Search by name", text: $productViewModel.searchText)
                    .font(.playfairDisplay(16))
                    .foregroundColor(.textPrimary)
                
                if !productViewModel.searchText.isEmpty {
                    Button(action: {
                        productViewModel.clearSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
            
            HStack(spacing: 10) {
                Menu {
                    ForEach(productViewModel.categoryNames, id: \.self) { category in
                        Button(category) {
                            productViewModel.selectedCategory = category
                        }
                    }
                } label: {
                    HStack {
                        Text(productViewModel.selectedCategory)
                            .font(.playfairDisplay(14))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                }
                
                Menu {
                    ForEach(ProductViewModel.SortOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            productViewModel.sortOption = option
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 12))
                        Text("Sort")
                            .font(.playfairDisplay(14))
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text(productViewModel.products.isEmpty ?
                 "Catalog is empty. Add your first product by tapping \"+\"." :
                    "No products found matching your search.")
            .font(.playfairDisplay(18, weight: .medium))
            .foregroundColor(.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var productListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(productViewModel.filteredProducts) { product in
                    ProductCardView(product: product) {
                        selectedProduct = ProductIdentifier(id: product.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct ProductCardView: View {
    let product: Product
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(product.category)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(.textSecondary)
                    
                    Text("Valid until: \(product.formattedExpirationDate)")
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(product.isExpired ? .red : 
                                       product.isExpiringSoon ? .orange : .textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= product.rating ? "star.fill" : "star")
                                .font(.system(size: 12))
                                .foregroundColor(star <= product.rating ? .primaryYellow : .textSecondary)
                        }
                    }
                    
                    if product.isExpired {
                        Text("Expired")
                            .font(.playfairDisplay(10, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(4)
                    } else if product.isExpiringSoon {
                        Text("Expires Soon")
                            .font(.playfairDisplay(10, weight: .medium))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
            .padding(16)
            .background(AppColorScheme.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CatalogView()
}
