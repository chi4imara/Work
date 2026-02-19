import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State private var selectedProduct: Product?
    
    private var favoriteProducts: [Product] {
        productViewModel.products.filter { $0.rating >= 4 }
            .sorted { $0.rating > $1.rating }
    }
    
    var body: some View {
        ZStack {
            AppColorScheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if favoriteProducts.isEmpty {
                    emptyStateView
                } else {
                    favoritesListView
                }
            }
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(productId: product.id)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if !favoriteProducts.isEmpty {
                Text("\(favoriteProducts.count) items")
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "star.slash")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("No favorites yet")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("Products with 4 or 5 star ratings will appear here")
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(favoriteProducts) { product in
                    FavoriteProductCardView(product: product) {
                        selectedProduct = product
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

struct FavoriteProductCardView: View {
    let product: Product
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(product.name)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.primaryYellow)
                    }
                    
                    Text(product.category)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(.textSecondary)
                    
                    Text("Valid until: \(product.formattedExpirationDate)")
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(product.isExpired ? .red : 
                                       product.isExpiringSoon ? .orange : .textSecondary)
                }
                
                VStack(alignment: .trailing, spacing: 5) {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= product.rating ? "star.fill" : "star")
                                .font(.system(size: 14))
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
    FavoritesView()
        .environmentObject(ProductViewModel())
}
