import SwiftUI

struct BrandCatalogView: View {
    @EnvironmentObject var brandStore: BrandStore
    @State private var showingAddBrand = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Catalog")
                        .font(.bauhaus(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddBrand = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.primaryYellow)
                            .frame(width: 40, height: 40)
                            .background(AppColors.primaryWhite.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                SearchBar(text: $brandStore.searchText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                if brandStore.filteredBrands.isEmpty {
                    EmptyStateView()
                } else {
                    BrandListView(brands: brandStore.filteredBrands, brandStore: brandStore)
                }
            }
        }
        .sheet(isPresented: $showingAddBrand) {
            AddBrandView(brandStore: brandStore)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search by brand", text: $text)
                .font(.bauhaus(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.2))
        .cornerRadius(15)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("Catalog is empty. Add your first brand.")
                .font(.bauhaus(18, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

struct BrandListView: View {
    let brands: [Brand]
    let brandStore: BrandStore
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(brands) { brand in
                    NavigationLink(destination: BrandDetailView(brandId: brand.id, brandStore: brandStore)) {
                        BrandCardView(brand: brand)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

struct BrandCardView: View {
    let brand: Brand
    
    var body: some View {
        HStack(spacing: 15) {
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
    BrandCatalogView()
}
