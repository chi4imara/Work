import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @Binding var selectedTab: Int
    @State private var showingAddProduct = false
    @State private var showingFilters = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorTheme.backgroundGradient
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
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Cosmetics")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                
                if viewModel.currentFilter.isActive {
                    Text("Filtered results")
                        .font(.ubuntu(14))
                        .foregroundColor(ColorTheme.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    selectedTab = 2
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .medium))
                    Text("Add")
                        .font(.ubuntu(14, weight: .medium))
                }
                .foregroundColor(ColorTheme.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(ColorTheme.buttonGradient)
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTheme.textSecondary)
                    .font(.system(size: 16))
                
                TextField("Search by color, brand or type", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.white)
                    .accentColor(ColorTheme.lightBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(ColorTheme.cardBackground)
            .cornerRadius(12)
            
            Button(action: {
                withAnimation {
                    selectedTab = 3
                }
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 24))
                    .foregroundColor(viewModel.currentFilter.isActive ? ColorTheme.accent : ColorTheme.textSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paintpalette")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.textSecondary)
            
            Text(viewModel.products.isEmpty ?
                 "Catalog is empty. Add your first product to get started." :
                    "No products match the selected parameters.")
            .font(.ubuntu(18))
            .foregroundColor(ColorTheme.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            
            if !viewModel.products.isEmpty {
                Button("Reset Filters") {
                    viewModel.resetFilter()
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.lightBlue)
                .padding(.top, 10)
            }
            
            Spacer()
        }
    }
    
    private var productsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredProducts) { product in
                    NavigationLink(destination: ProductDetailView(product: product, viewModel: viewModel)) {
                        ProductCardView(product: product)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct ProductCardView: View {
    let product: CosmeticProduct
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorTheme.lightBlue)
                .frame(width: 4, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(product.name)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if product.label != .none {
                        Text(product.label.emoji)
                            .font(.system(size: 16))
                    }
                }
                
                Text(product.type.displayName)
                    .font(.ubuntu(12))
                    .foregroundColor(ColorTheme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(ColorTheme.accent.opacity(0.2))
                    .cornerRadius(6)
                
                Text(product.color)
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.textSecondary)
                    .lineLimit(2)
                
                if !product.brand.isEmpty {
                    Text(product.brand)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorTheme.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(ColorTheme.textSecondary)
        }
        .padding(16)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

