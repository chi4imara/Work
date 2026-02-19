import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var selectedCategory: ProductCategory?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                VStack {
                    HStack {
                        Text("Categories")
                            .font(FontManager.bold(size: 28))
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if productStore.products.isEmpty {
                        EmptyCategoriesView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(productStore.categorySummaries, id: \.category) { summary in
                                    NavigationLink(destination: CategoryDetailView(category: summary.category)) {
                                        CategoryCard(summary: summary)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No categories yet")
                    .font(FontManager.bold(size: 24))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Text("Add some products to see them organized by categories")
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategoryCard: View {
    let summary: CategorySummary
    
    var categoryIcon: String {
        switch summary.category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .haircare:
            return "scissors"
        case .bodycare:
            return "figure.walk"
        case .fragrance:
            return "aqi.medium"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    var categoryColor: Color {
        switch summary.category {
        case .skincare:
            return ColorManager.primaryBlue
        case .makeup:
            return ColorManager.softPink
        case .haircare:
            return ColorManager.accentPurple
        case .bodycare:
            return ColorManager.primaryYellow
        case .fragrance:
            return ColorManager.statusInUse
        case .other:
            return ColorManager.darkGray
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: categoryIcon)
                    .font(.title2)
                    .foregroundColor(categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(summary.category.displayName)
                    .font(FontManager.bold(size: 18))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Text("\(summary.count) products")
                    .font(FontManager.regular(size: 14))
                    .foregroundColor(ColorManager.darkGray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                let inUseCount = summary.products.filter { $0.status == .inUse }.count
                let inStockCount = summary.products.filter { $0.status == .inStock }.count
                let needToBuyCount = summary.products.filter { $0.status == .needToBuy }.count
                
                if inUseCount > 0 {
                    StatusBadge(count: inUseCount, color: ColorManager.statusInUse, text: "In Use")
                }
                if inStockCount > 0 {
                    StatusBadge(count: inStockCount, color: ColorManager.statusInStock, text: "In Stock")
                }
                if needToBuyCount > 0 {
                    StatusBadge(count: needToBuyCount, color: ColorManager.statusNeedToBuy, text: "Need to Buy")
                }
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ColorManager.darkGray.opacity(0.6))
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct StatusBadge: View {
    let count: Int
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text("\(count)")
                .font(FontManager.medium(size: 12))
                .foregroundColor(color)
        }
    }
}

struct CategoryDetailView: View {
    let category: ProductCategory
    @EnvironmentObject var productStore: ProductStore
    
    var categoryProducts: [Product] {
        productStore.productsForCategory(category)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if categoryProducts.isEmpty {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "tray")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
                    
                    
                    Text("No products in this category")
                        .font(FontManager.medium(size: 18))
                        .foregroundColor(ColorManager.darkGray)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(categoryProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 10)
                }
            }
        }
        .navigationTitle(category.displayName)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    CategoriesView()
        .environmentObject(ProductStore())
}
