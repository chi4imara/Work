import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.playfair(28, weight: .bold))
                        .foregroundColor(AppColors.blueText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.favoriteProducts.isEmpty {
                    EmptyStateFavoritesView()
                } else {
                    FavoritesListView(viewModel: viewModel)
                }
            }
        }
    }
}

struct EmptyStateFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mediumGray)
            
            Text("No favorite products yet.")
                .font(.playfair(18, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct FavoritesListView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.favoriteProducts) { product in
                    NavigationLink(destination: ProductDetailView(productId: product.id, viewModel: viewModel)) {
                        FavoriteProductCardView(product: product)
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

struct FavoriteProductCardView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.playfair(18, weight: .semibold))
                        .foregroundColor(AppColors.blueText)
                        .lineLimit(2)
                    
                    Text(product.category.displayName)
                        .font(.playfair(14, weight: .medium))
                        .foregroundColor(AppColors.mediumBlue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    ResultBadge(result: product.result)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.yellow)
                }
            }
            
            HStack {
                Text(DateFormatter.shortDate.string(from: product.firstUseDate))
                    .font(.playfair(12, weight: .regular))
                    .foregroundColor(AppColors.mediumGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mediumGray)
            }
            
            if !product.notes.isEmpty {
                Text(product.notes)
                    .font(.playfair(14, weight: .regular))
                    .foregroundColor(AppColors.darkGray)
                    .lineLimit(2)
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
        FavoritesView(viewModel: ProductViewModel())
    }
}
