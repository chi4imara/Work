import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var brandStore: BrandStore

    private var favoriteBrands: [Brand] {
        brandStore.brands.filter { $0.rating == 5 }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.bauhaus(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    if !favoriteBrands.isEmpty {
                        Text("\(favoriteBrands.count)")
                            .font(.bauhaus(18, weight: .medium))
                            .foregroundColor(AppColors.primaryYellow)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.primaryWhite.opacity(0.2))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if favoriteBrands.isEmpty {
                    EmptyFavoritesView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(favoriteBrands) { brand in
                                NavigationLink(destination: BrandDetailView(brandId: brand.id, brandStore: brandStore)) {
                                    FavoriteBrandCardView(brand: brand)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "star")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            }
            
            Text("No favorites yet")
                .font(.bauhaus(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Brands with 5-star rating will appear here")
                .font(.bauhaus(16, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}

struct FavoriteBrandCardView: View {
    let brand: Brand
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(brand.name)
                        .font(.bauhaus(20, weight: .bold))
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                }
                
                Text(brand.category.displayName)
                    .font(.bauhaus(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                
                HStack {
                    StarRatingView(rating: brand.rating, interactive: false, color: AppColors.primaryYellow)
                    
                    Spacer()
                }
                
                if !brand.description.isEmpty {
                    Text(brand.description)
                        .font(.bauhaus(14, weight: .medium))
                        .foregroundColor(AppColors.darkGray.opacity(0.8))
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    FavoritesView()
}
