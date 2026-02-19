import SwiftUI

struct StockView: View {
    @ObservedObject var productViewModel: ProductViewModel
    @State private var selectedProductId: ProductID?
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Stock Levels")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if productViewModel.products.isEmpty {
                    EmptyStockView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            StockSection(
                                title: "Low Stock",
                                products: productViewModel.products(for: .low),
                                color: ColorTheme.lowStock,
                                icon: "exclamationmark.triangle.fill",
                                onProductTap: { product in
                                    selectedProductId = ProductID(id: product.id)
                                }
                            )
                            
                            StockSection(
                                title: "Medium Stock",
                                products: productViewModel.products(for: .medium),
                                color: ColorTheme.mediumStock,
                                icon: "minus.circle.fill",
                                onProductTap: { product in
                                    selectedProductId = ProductID(id: product.id)
                                }
                            )
                            
                            StockSection(
                                title: "Normal Stock",
                                products: productViewModel.products(for: .normal),
                                color: ColorTheme.normalStock,
                                icon: "checkmark.circle.fill",
                                onProductTap: { product in
                                    selectedProductId = ProductID(id: product.id)
                                }
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }
        }
        .sheet(item: $selectedProductId) { productId in
            ProductDetailView(productId: productId.id, productViewModel: productViewModel)
        }
    }
}

struct EmptyStockView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.green.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(ColorTheme.green)
            }
            
            VStack(spacing: 16) {
                Text("No Stock Data")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add products to monitor their stock levels")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct StockSection: View {
    let title: String
    let products: [Product]
    let color: Color
    let icon: String
    let onProductTap: (Product) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if !products.isEmpty {
                    Text("\(products.count)")
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            if products.isEmpty {
                EmptyStockSectionView(color: color)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(products.sorted(by: { $0.updatedAt > $1.updatedAt })) { product in
                        StockProductRow(product: product, sectionColor: color) {
                            onProductTap(product)
                        }
                    }
                }
            }
        }
    }
}

struct EmptyStockSectionView: View {
    let color: Color
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(color.opacity(0.6))
                
                Text("No products in this category")
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.vertical, 20)
            Spacer()
        }
        .background(ColorTheme.tertiaryBackground.opacity(0.3))
        .cornerRadius(8)
    }
}

struct StockProductRow: View {
    let product: Product
    let sectionColor: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(sectionColor.opacity(0.2))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: product.category.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(sectionColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(1)
                    
                    HStack {
                        Text(product.category.displayName)
                            .font(.playfairDisplay(14, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Spacer()
                        
                        StatusBadge(status: product.status)
                    }
                    
                    HStack {
                        Text("Last used: \(product.lastUsedText)")
                            .font(.playfairDisplay(12, weight: .regular))
                            .foregroundColor(ColorTheme.tertiaryText)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(product.stockLevel.displayName)
                        .font(.playfairDisplay(12, weight: .semibold))
                        .foregroundColor(sectionColor)
                    
                    StockLevelIndicator(level: product.stockLevel)
                }
            }
            .padding(16)
            .background(ColorTheme.cardGradient)
            .cornerRadius(12)
            .shadow(color: sectionColor.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StockProgressBar: View {
    let level: StockLevel
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(ColorTheme.tertiaryBackground)
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * progressValue, height: 4)
                    .cornerRadius(2)
            }
        }
        .frame(height: 4)
    }
    
    private var progressValue: CGFloat {
        switch level {
        case .low: return 0.25
        case .medium: return 0.6
        case .normal: return 1.0
        }
    }
}

#Preview {
    StockView(productViewModel: ProductViewModel())
}
