import SwiftUI

struct ProductCatalogView: View {
    @ObservedObject var viewModel: CosmeticBagViewModel
    @State private var searchText = ""
    @State private var selectedFilter: ProductStatus? = nil
    @State private var productToDelete: Product?
    @State private var showingDeleteAlert = false
    @State private var productToEdit: Product?
    
    var filteredProducts: [Product] {
        viewModel.getFilteredProducts(status: selectedFilter, searchText: searchText)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("All Products")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.theme.darkGray.opacity(0.6))
                            
                            TextField("Search products...", text: $searchText)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(Color.theme.darkGray)
                        }
                        .padding(16)
                        .background(Color.theme.primaryWhite)
                        .cornerRadius(12)
                        .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    FilterBar(selectedFilter: $selectedFilter)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    
                    if filteredProducts.isEmpty {
                        if viewModel.getAllProducts().isEmpty {
                            EmptyAllProductsView()
                        } else {
                            NoResultsView(searchText: searchText, selectedFilter: selectedFilter)
                        }
                    } else {
                        AllProductsList(
                            products: filteredProducts,
                            viewModel: viewModel,
                            onDelete: { product in
                                productToDelete = product
                                showingDeleteAlert = true
                            },
                            onEdit: { product in
                                productToEdit = product
                            }
                        )
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $productToEdit) { product in
            CreateProductView(viewModel: viewModel, cosmeticBagId: product.cosmeticBagId, productToEdit: product)
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let product = productToDelete {
                    viewModel.deleteProduct(product)
                }
            }
        } message: {
            Text("Are you sure you want to delete this product?")
        }
    }
}

struct EmptyAllProductsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "list.clipboard")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.theme.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("No products added yet")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    Text("Add products to your cosmetic bags to see them here.")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct NoResultsView: View {
    let searchText: String
    let selectedFilter: ProductStatus?
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.theme.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("No results found")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    if !searchText.isEmpty {
                        Text("No products match \"\(searchText)\"")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                    } else if selectedFilter != nil {
                        Text("No products with this status")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct AllProductsList: View {
    let products: [Product]
    let viewModel: CosmeticBagViewModel
    let onDelete: (Product) -> Void
    let onEdit: (Product) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(products) { product in
                    NavigationLink(destination: ProductDetailView(viewModel: viewModel, product: product)) {
                        AllProductsCard(
                            product: product,
                            viewModel: viewModel,
                            onDelete: { onDelete(product) },
                            onEdit: { onEdit(product) }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
}

struct AllProductsCard: View {
    let product: Product
    let viewModel: CosmeticBagViewModel
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var cosmeticBag: CosmeticBag? {
        viewModel.getCosmeticBag(by: product.cosmeticBagId)
    }
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                    Text("Edit")
                        .font(.ubuntu(11, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color.theme.accentOrange)
                .cornerRadius(12)
                .padding(.leading, 20)
                
                Spacer()
            }
            .opacity(offset > 10 ? min(offset / 80, 1.0) : 0.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: offset)
            
            HStack {
                Spacer()
                
                VStack {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                    Text("Delete")
                        .font(.ubuntu(11, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color.theme.accentRed)
                .cornerRadius(12)
                .padding(.trailing, 20)
            }
            .opacity(offset < -10 ? min(abs(offset) / 80, 1.0) : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: offset)
            
            HStack(spacing: 12) {
                Image(systemName: product.status.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(product.status == .available ? Color.theme.accentGreen : Color.theme.accentRed)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(Color.theme.darkGray)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text(product.category.displayName)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(Color.theme.darkGray.opacity(0.7))
                        
                        if let bag = cosmeticBag {
                            Text("•")
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(Color.theme.darkGray.opacity(0.5))
                            
                            Text(bag.name)
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(bag.colorTag.color)
                        }
                    }
                    
                    Text("Expires: \(product.expirationDate, formatter: DateFormatter.shortDate)")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.primaryPurple)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(product.volume)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.darkGray)
                    
                    Text(product.status.displayName)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(product.status == .available ? Color.theme.accentGreen : Color.theme.accentRed)
                }
            }
            .padding(16)
            .frame(height: 80)
            .background(Color.theme.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 6, x: 0, y: 3)
            .offset(x: offset, y: 0)
            .highPriorityGesture(
            DragGesture(minimumDistance: 30)
                .onChanged { value in
                    let translation: CGFloat = value.translation.width
                    if translation > 0 {
                        let ratio: CGFloat = translation / 200.0
                        let clampedRatio = ratio.clamped(to: 0.0...0.5)
                        let resistance: CGFloat = 1.0 - clampedRatio
                        offset = min(translation * resistance, 80)
                    } else {
                        let ratio: CGFloat = abs(translation) / 200.0
                        let clampedRatio = ratio.clamped(to: 0.0...0.5)
                        let resistance: CGFloat = 1.0 - clampedRatio
                        offset = max(translation * resistance, -80)
                    }
                }
                .onEnded { value in
                    let translation = value.translation.width
                    let velocity = value.predictedEndTranslation.width - value.translation.width
                    
                    let threshold: CGFloat = 50
                    let velocityThreshold: CGFloat = 300
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if abs(velocity) > velocityThreshold {
                            if velocity > 0 {
                                offset = 0
                                onEdit()
                            } else {
                                offset = 0
                                onDelete()
                            }
                        } else if translation > threshold {
                            offset = 0
                            onEdit()
                        } else if translation < -threshold {
                            offset = 0
                            onDelete()
                        } else {
                            offset = 0
                        }
                    }
                }
            )
        }
    }
}

#Preview {
    ProductCatalogView(viewModel: CosmeticBagViewModel())
}
