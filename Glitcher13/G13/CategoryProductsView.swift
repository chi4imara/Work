import SwiftUI

struct CategoryProductsView: View {
    let category: ProductCategory
    @ObservedObject var viewModel: ProductViewModel
    
    private var categoryProducts: [Product] {
        viewModel.products(for: category)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if categoryProducts.isEmpty {
                    EmptyStateCategoryProductsView(category: category)
                } else {
                    CategoryProductsListView(products: categoryProducts, viewModel: viewModel)
                }
            }
        }
        .navigationTitle(category.displayName)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct EmptyStateCategoryProductsView: View {
    let category: ProductCategory
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "flask")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mediumGray)
            
            Text("No products in \(category.displayName.lowercased()) category yet.")
                .font(.playfair(18, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct CategoryProductsListView: View {
    let products: [Product]
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(products) { product in
                    NavigationLink(destination: ProductDetailView(productId: product.id, viewModel: viewModel)) {
                        CategoryProductCardView(product: product)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct CategoryProductCardView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.playfair(18, weight: .semibold))
                        .foregroundColor(AppColors.blueText)
                        .lineLimit(2)
                    
                    Text(DateFormatter.shortDate.string(from: product.firstUseDate))
                        .font(.playfair(14, weight: .regular))
                        .foregroundColor(AppColors.mediumGray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    ResultBadge(result: product.result)
                    
                    if product.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.yellow)
                    }
                }
            }
            
            if !product.notes.isEmpty {
                Text(product.notes)
                    .font(.playfair(14, weight: .regular))
                    .foregroundColor(AppColors.darkGray)
                    .lineLimit(2)
            }
            
            HStack {
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mediumGray)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
    }
}

#Preview {
    NavigationView {
        CategoryProductsView(category: .skincare, viewModel: ProductViewModel())
    }
}
