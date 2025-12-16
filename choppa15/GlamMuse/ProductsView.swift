import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @State private var showingCreateProduct = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchView
                
                if viewModel.filteredProducts.isEmpty {
                    emptyStateView
                } else {
                    productsListView
                }
            }
        }
        .sheet(isPresented: $showingCreateProduct) {
            CreateEditProductView(viewModel: viewModel)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(productId: product.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("My Products")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Cosmetic products catalog")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    private var searchView: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search products...", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground.opacity(0.2))
            .cornerRadius(12)
            
            Button(action: { showingCreateProduct = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Product")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("Catalog is empty")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add products you use for makeup")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingCreateProduct = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Product")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(width: 200, height: 44)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var productsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductCard(product: product) {
                        selectedProduct = product
                    } onEdit: {
                    } onDelete: {
                        viewModel.deleteProduct(product)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ProductCard: View {
    let product: Product
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var cardHeight: CGFloat = 0
    
    private let actionWidth: CGFloat = 120
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                        onEdit()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "pencil")
                                .font(.system(size: 20, weight: .medium))
                            Text("Edit")
                                .font(.ubuntu(12, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(width: actionWidth / 2)
                        .frame(maxHeight: .infinity)
                        .background(Color.blue)
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                        onDelete()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .medium))
                            Text("Delete")
                                .font(.ubuntu(12, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(width: actionWidth / 2)
                        .frame(maxHeight: .infinity)
                        .background(Color.red)
                    }
                }
                .frame(height: cardHeight > 0 ? cardHeight : nil)
                .cornerRadius(12)
                .opacity(offset < 0 ? 1 : 0)
                
                Button(action: {
                    if offset == 0 {
                        onTap()
                    } else {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                    }
                }) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.name)
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.darkText)
                                    .lineLimit(2)
                                
                                Text(product.category.rawValue)
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(AppColors.accent)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(AppColors.accent.opacity(0.1))
                                    .cornerRadius(6)
                            }
                            
                            Spacer()
                            
                            Text(DateFormatter.shortDate.string(from: product.dateAdded))
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.darkText.opacity(0.6))
                        }
                        
                        if !product.shade.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Shade/Number:")
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(AppColors.darkText.opacity(0.7))
                                
                                Text(product.shade)
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.darkText)
                            }
                        }
                        
                        if !product.comment.isEmpty {
                            Text(product.comment)
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.darkText.opacity(0.8))
                                .lineLimit(2)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .background(
                        GeometryReader { cardGeometry in
                            Color.clear
                                .onAppear {
                                    cardHeight = cardGeometry.size.height
                                }
                                .onChange(of: cardGeometry.size.height) { newHeight in
                                    cardHeight = newHeight
                                }
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: cardHeight > 0 ? cardHeight : nil)
    }
}

#Preview {
    ProductsView()
}
