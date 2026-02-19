import SwiftUI

struct CategoriesView: View {
    @ObservedObject var productViewModel: ProductViewModel
    @State private var selectedProductId: ProductID?
    @State private var expandedCategory: ProductCategory?
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Categories")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if productViewModel.products.isEmpty {
                    EmptyCategoriesView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(ProductCategory.allCases) { category in
                                let products = productViewModel.products(for: category)
                                if !products.isEmpty {
                                    CategorySection(
                                        category: category,
                                        products: products,
                                        stats: productViewModel.categoryStats(for: category),
                                        isExpanded: expandedCategory == category,
                                        onToggle: {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                expandedCategory = expandedCategory == category ? nil : category
                                            }
                                        },
                                        onProductTap: { product in
                                            selectedProductId = ProductID(id: product.id)
                                        }
                                    )
                                }
                            }
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

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.orange.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "folder.circle")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(ColorTheme.orange)
            }
            
            VStack(spacing: 16) {
                Text("No Categories")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add products to see them organized by categories")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategorySection: View {
    let category: ProductCategory
    let products: [Product]
    let stats: (total: Int, inUse: Int, runningOut: Int)
    let isExpanded: Bool
    let onToggle: () -> Void
    let onProductTap: (Product) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(categoryColor.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: category.icon)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(categoryColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.displayName)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Text("\(stats.total)")
                                    .font(.playfairDisplay(14, weight: .semibold))
                                    .foregroundColor(ColorTheme.lightBlue)
                                Text("total")
                                    .font(.playfairDisplay(14, weight: .regular))
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                            
                            if stats.runningOut > 0 {
                                HStack(spacing: 4) {
                                    Text("\(stats.runningOut)")
                                        .font(.playfairDisplay(14, weight: .semibold))
                                        .foregroundColor(ColorTheme.runningOut)
                                    Text("running out")
                                        .font(.playfairDisplay(14, weight: .regular))
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorTheme.secondaryText)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(16)
                .cardStyle()
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(products.sorted(by: { $0.name < $1.name })) { product in
                        CategoryProductRow(product: product) {
                            onProductTap(product)
                        }
                    }
                }
                .padding(.top, 8)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .cream: return ColorTheme.lightBlue
        case .oil: return ColorTheme.orange
        case .shampoo: return ColorTheme.green
        case .balm: return ColorTheme.yellow
        case .gel: return ColorTheme.red
        case .other: return ColorTheme.secondaryText
        }
    }
}

struct CategoryProductRow: View {
    let product: Product
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.name)
                        .font(.playfairDisplay(15, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(1)
                    
                    HStack {
                        Text(product.status.displayName)
                            .font(.playfairDisplay(12, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Spacer()
                        
                        Text(product.lastUsedText)
                            .font(.playfairDisplay(12, weight: .regular))
                            .foregroundColor(ColorTheme.tertiaryText)
                    }
                }
                
                Spacer()
                
                StockLevelIndicator(level: product.stockLevel)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(ColorTheme.tertiaryBackground.opacity(0.5))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var statusColor: Color {
        switch product.status {
        case .inUse: return ColorTheme.inUse
        case .runningOut: return ColorTheme.runningOut
        }
    }
}

#Preview {
    CategoriesView(productViewModel: ProductViewModel())
}
