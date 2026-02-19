import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @State private var showingAddProduct = false
    @State private var showingSortOptions = false
    @State private var selectedProductId: ProductID?
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if viewModel.filteredProducts.isEmpty {
                    emptyStateView
                } else {
                    productsList
                }
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView(viewModel: viewModel)
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
                Text("My Cosmetics")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                if !viewModel.products.isEmpty {
                    Text("\(viewModel.filteredProducts.count) products")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
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
                
                Button(action: {
                    withAnimation {
                        selectedTab = .add
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppColors.backgroundGradientStart)
                        .frame(width: 40, height: 40)
                        .background(AppColors.primaryYellow)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search by name or brand", text: $viewModel.searchText)
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
            
            Image(systemName: "paintbrush.pointed")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: 12) {
                Text("Your catalog is empty")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Tap + to add your first cosmetic product")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = .add
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Product")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.backgroundGradientStart)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.primaryYellow)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var productsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductCard(
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

struct ProductCard: View {
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
                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(product.isFavorite ? AppColors.accentOrange : AppColors.textSecondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
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

