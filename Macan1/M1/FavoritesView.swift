import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @State private var selectedProductId: ProductID?
    @State private var showingSortOptions = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if viewModel.favoriteProducts.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
        }
        .sheet(item: $selectedProductId) { productId in
            ProductDetailView(productId: productId.id, viewModel: viewModel)
        }
        .actionSheet(isPresented: $showingSortOptions) {
            sortActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorites")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                if !viewModel.favoriteProducts.isEmpty {
                    Text("\(viewModel.favoriteProducts.count) favorite products")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: { showingSortOptions = true }) {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 40, height: 40)
                    .background(AppColors.cardBackground)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search favorites", text: $viewModel.searchText)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textPrimary)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: 12) {
                Text("No favorites yet")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Mark products as favorites on the main screen to see them here")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.favoriteProducts) { product in
                    FavoriteProductCard(
                        product: product,
                        onTap: { selectedProductId = ProductID(id: product.id) },
                        onFavoriteToggle: { viewModel.toggleFavorite(product) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort by"),
            buttons: SortOption.allCases.map { option in
                .default(Text(option.rawValue)) {
                    if viewModel.sortOption == option {
                        viewModel.isAscending.toggle()
                    } else {
                        viewModel.sortOption = option
                        viewModel.isAscending = true
                    }
                }
            } + [.cancel()]
        )
    }
}

struct FavoriteProductCard: View {
    let product: CosmeticProduct
    let onTap: () -> Void
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(product.statusColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: product.type.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(product.statusColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text("\(product.brand) — \(product.type.rawValue)")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                    
                    if !product.shade.isEmpty {
                        Text(product.shade)
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(AppColors.textTertiary)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= product.rating ? "star.fill" : "star")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.primaryYellow)
                            }
                        }
                        
                        Spacer()
                        
                        Text(expirationText)
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(product.statusColor)
                    }
                }
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentOrange)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.accentOrange.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var expirationText: String {
        let days = product.daysUntilExpiration
        if days < 0 {
            return "Expired"
        } else if days == 0 {
            return "Expires today"
        } else if days < 30 {
            return "\(days) days left"
        } else {
            let months = days / 30
            return "\(months) months left"
        }
    }
}

#Preview {
    FavoritesView(viewModel: CosmeticViewModel())
}
