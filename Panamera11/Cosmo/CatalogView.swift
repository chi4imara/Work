import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: CosmeticsViewModel
    @State private var showingAddProduct = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
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
            AddEditProductView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Cosmetics")
                    .font(.bellGothic(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                if !viewModel.filteredProducts.isEmpty {
                    Text("\(viewModel.filteredProducts.count) products")
                        .font(.bellGothic(14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Button(action: { showingAddProduct = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                    Text("Add Product")
                        .font(.bellGothic(14, weight: .bold))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.accentYellow)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search by name, shade, or use...", text: $viewModel.searchText)
                .font(.bellGothic(16))
                .foregroundColor(AppColors.primaryText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.clearSearch() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow.opacity(0.7))
            
            VStack(spacing: 12) {
                Text("Catalog is empty")
                    .font(.bellGothic(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first product to get started.")
                    .font(.bellGothic(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddProduct = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                    Text("Add Product")
                        .font(.bellGothic(16, weight: .bold))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.accentYellow)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var productsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredProducts) { product in
                    NavigationLink(destination: ProductDetailView(productId: product.id, viewModel: viewModel)) {
                        ProductCardView(product: product, viewModel: viewModel)
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

struct ProductCardView: View {
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
            .frame(width: 60, height: 60)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.bellGothic(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                if !product.shade.isEmpty {
                    Text(product.shade)
                        .font(.bellGothic(14))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                if !product.suitableFor.isEmpty {
                    Text(product.suitableFor)
                        .font(.bellGothic(12))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Button(action: { viewModel.toggleFavorite(for: product) }) {
                Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundColor(product.isFavorite ? AppColors.accentYellow : AppColors.secondaryText)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.accentYellow.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    CatalogView(viewModel: CosmeticsViewModel())
}
