import SwiftUI

struct MyStockView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var showingAddProduct = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My Stock")
                            .font(FontManager.bold(size: 28))
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddProduct = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(ColorManager.primaryYellow)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    SearchBar(text: $productStore.searchText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                    if productStore.products.isEmpty {
                        EmptyStockView()
                        
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    let categoryProducts = productStore.filteredProducts.filter { $0.category == category }
                                    
                                    if !categoryProducts.isEmpty {
                                        CategorySection(
                                            category: category,
                                            products: categoryProducts
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
                .environmentObject(productStore)
        }
    }
}

struct EmptyStockView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "cube.box")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No products added yet")
                    .font(FontManager.bold(size: 24))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Text("Tap ➕ to start tracking your cosmetics")
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.darkGray)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(category.displayName)
                    .font(FontManager.bold(size: 20))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Spacer()
                
                Text("\(products.count)")
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(ColorManager.lightGray)
                    .cornerRadius(12)
            }
            
            ForEach(products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductCard(product: product)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
    }
}

struct ProductCard: View {
    let product: Product
    
    var statusColor: Color {
        switch product.status {
        case .inUse:
            return ColorManager.statusInUse
        case .inStock:
            return ColorManager.statusInStock
        case .needToBuy:
            return ColorManager.statusNeedToBuy
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                    .lineLimit(1)
                
                Text(product.brand)
                    .font(FontManager.regular(size: 14))
                    .foregroundColor(ColorManager.darkGray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(product.quantity) pcs")
                    .font(FontManager.medium(size: 14))
                    .foregroundColor(ColorManager.darkGray)
                
                Text(product.status.displayName)
                    .font(FontManager.regular(size: 12))
                    .foregroundColor(statusColor)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(ColorManager.darkGray.opacity(0.6))
        }
        .padding(16)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorManager.darkGray.opacity(0.6))
            
            TextField("Search by name or category", text: $text)
                .font(FontManager.regular(size: 16))
                .foregroundColor(ColorManager.darkGray)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ColorManager.darkGray.opacity(0.6))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
    }
}

#Preview {
    MyStockView()
        .environmentObject(ProductStore())
}
