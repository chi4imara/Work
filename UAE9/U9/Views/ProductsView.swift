import SwiftUI

struct ProductsView: View {
    @ObservedObject var productViewModel: ProductViewModel
    @State private var showingAddProduct = false
    @State private var selectedProductId: ProductID?
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Products")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddProduct = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(ColorTheme.lightBlue)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if productViewModel.products.isEmpty {
                    EmptyStateView {
                        showingAddProduct = true
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if let recentProduct = productViewModel.recentlyUpdatedProduct {
                                RecentlyUpdatedSection(product: recentProduct) {
                                    selectedProductId = ProductID(id: recentProduct.id)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                            }
                            
                            ProductsListSection(
                                products: productViewModel.products,
                                onProductTap: { product in
                                    selectedProductId = ProductID(id: product.id)
                                }
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddEditProductView(productViewModel: productViewModel)
        }
        .sheet(item: $selectedProductId) { productId in
            ProductDetailView(productId: productId.id, productViewModel: productViewModel)
        }
    }
}

struct EmptyStateView: View {
    let onAddProduct: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.lightBlue.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "drop.circle")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(ColorTheme.lightBlue)
            }
            
            VStack(spacing: 16) {
                Text("Add Your First Product")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Start organizing your grooming essentials")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onAddProduct) {
                Text("Add Product")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorTheme.buttonGradient)
                    .cornerRadius(12)
                    .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 60)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct RecentlyUpdatedSection: View {
    let product: Product
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Updated")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(statusColor(for: product.status).opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: product.category.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(statusColor(for: product.status))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text(product.category.displayName)
                            .font(.playfairDisplay(14, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        HStack {
                            StatusBadge(status: product.status)
                            Spacer()
                            Text(product.lastUsedText)
                                .font(.playfairDisplay(12, weight: .regular))
                                .foregroundColor(ColorTheme.tertiaryText)
                        }
                    }
                    
                    Spacer()
                    
                    StockLevelIndicator(level: product.stockLevel)
                }
                .padding(16)
                .cardStyle()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func statusColor(for status: ProductStatus) -> Color {
        switch status {
        case .inUse: return ColorTheme.inUse
        case .runningOut: return ColorTheme.runningOut
        }
    }
}

struct ProductsListSection: View {
    let products: [Product]
    let onProductTap: (Product) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Products")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVStack(spacing: 12) {
                ForEach(products.sorted(by: { $0.updatedAt > $1.updatedAt })) { product in
                    ProductRowView(product: product) {
                        onProductTap(product)
                    }
                }
            }
        }
    }
}

struct ProductRowView: View {
    let product: Product
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(statusColor(for: product.status).opacity(0.2))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: product.category.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(statusColor(for: product.status))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(1)
                    
                    Text(product.category.displayName)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    HStack {
                        StatusBadge(status: product.status)
                        Spacer()
                        Text(product.lastUsedText)
                            .font(.playfairDisplay(12, weight: .regular))
                            .foregroundColor(ColorTheme.tertiaryText)
                    }
                }
                
                Spacer()
                
                StockLevelIndicator(level: product.stockLevel)
            }
            .padding(16)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func statusColor(for status: ProductStatus) -> Color {
        switch status {
        case .inUse: return ColorTheme.inUse
        case .runningOut: return ColorTheme.runningOut
        }
    }
}

struct StatusBadge: View {
    let status: ProductStatus
    
    var body: some View {
        Text(status.displayName)
            .font(.playfairDisplay(12, weight: .medium))
            .foregroundColor(ColorTheme.primaryText)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.3))
            .cornerRadius(6)
    }
    
    private var statusColor: Color {
        switch status {
        case .inUse: return ColorTheme.inUse
        case .runningOut: return ColorTheme.runningOut
        }
    }
}

struct StockLevelIndicator: View {
    let level: StockLevel
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<3) { index in
                Rectangle()
                    .fill(barColor(for: index))
                    .frame(width: 4, height: 8)
                    .cornerRadius(2)
            }
        }
    }
    
    private func barColor(for index: Int) -> Color {
        let activeLevel = level.priority
        if index < activeLevel {
            switch level {
            case .low: return ColorTheme.lowStock
            case .medium: return ColorTheme.mediumStock
            case .normal: return ColorTheme.normalStock
            }
        } else {
            return ColorTheme.tertiaryText.opacity(0.3)
        }
    }
}

#Preview {
    ProductsView(productViewModel: ProductViewModel())
}
