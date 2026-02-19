import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: CosmeticsViewModel
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.favoriteProducts.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorites")
                    .font(.bellGothic(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                if !viewModel.favoriteProducts.isEmpty {
                    Text(
                        "\(viewModel.favoriteProducts.count) favorite\(viewModel.favoriteProducts.count == 1 ? "" : "s")"
                    )
                    .font(.bellGothic(14))
                    .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.accentYellow)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow.opacity(0.7))
            
            VStack(spacing: 12) {
                Text("No favorites yet")
                    .font(.bellGothic(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(
                    "Add products to favorites by tapping the heart icon on product cards or detail pages."
                )
                .font(.bellGothic(16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favoriteProducts) { product in
                    NavigationLink(
                        destination: ProductDetailView(
                            productId: product.id,
                            viewModel: viewModel
                        )
                    ) {
                        FavoriteProductCardView(
                            product: product,
                            viewModel: viewModel
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

struct FavoriteProductCardView: View {
    let product: CosmeticProduct
    @ObservedObject var viewModel: CosmeticsViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Group {
                if let imageData = product.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .frame(width: 70, height: 70)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.bellGothic(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                if !product.shade.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "paintpalette")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.accentYellow)
                        
                        Text(product.shade)
                            .font(.bellGothic(14))
                            .foregroundColor(AppColors.accentYellow)
                    }
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "tag")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(product.productType.displayName)
                        .font(.bellGothic(12))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                if !product.suitableFor.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(product.suitableFor)
                            .font(.bellGothic(12))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentYellow)
                
                Button(action: { viewModel.toggleFavorite(for: product) }) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.errorRed)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.accentYellow.opacity(0.4), lineWidth: 2)
                )
        )
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.primaryText)
                        .padding(6)
                        .background(
                            Circle()
                                .fill(AppColors.accentYellow)
                        )
                    Spacer()
                }
                .padding(.trailing, 8)
                .padding(.top, 8)
            }
        )
    }
}

#Preview {
    FavoritesView(viewModel: CosmeticsViewModel())
}
