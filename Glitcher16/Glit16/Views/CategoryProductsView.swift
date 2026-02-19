import SwiftUI

struct CategoryProductsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    let category: Category
    @State private var selectedProduct: Product?
    
    private var categoryProducts: [Product] {
        productViewModel.getProductsForCategory(category.name)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColorScheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if categoryProducts.isEmpty {
                        emptyStateView
                    } else {
                        productsListView
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(productId: product.id)
                .environmentObject(productViewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("\(categoryProducts.count) product\(categoryProducts.count == 1 ? "" : "s")")
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("No products in this category yet.")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var productsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(categoryProducts) { product in
                    CategoryProductCardView(product: product) {
                        selectedProduct = product
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

struct CategoryProductCardView: View {
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
    CategoryProductsView(category: Category(name: "Lipstick", productCount: 3))
        .environmentObject(ProductViewModel())
}
