import SwiftUI

struct ProductCatalogView: View {
    @EnvironmentObject var productStore: ProductStore
    @EnvironmentObject var achievementManager: AchievementManager
    @State private var selectedTab: ProductStatus = .suitable
    @State private var showingAddProduct = false
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Product Catalog")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddProduct = true
                    }) {
                        Image(systemName: "plus")
                            .font(.playfairDisplay(size: 20, weight: .bold))
                            .foregroundColor(ColorManager.primaryBlue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ColorManager.secondaryText)
                    
                    TextField("Search products...", text: $searchText)
                        .font(.playfairDisplay(size: 16, weight: .regular))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack(spacing: 0) {
                    TabButton(
                        title: "Suitable",
                        isSelected: selectedTab == .suitable,
                        action: { selectedTab = .suitable }
                    )
                    
                    TabButton(
                        title: "Not Suitable",
                        isSelected: selectedTab == .unsuitable,
                        action: { selectedTab = .unsuitable }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        let allProducts = selectedTab == .suitable ?
                        productStore.suitableProducts :
                        productStore.unsuitableProducts
                        
                        let products = searchText.isEmpty ? allProducts :
                        allProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                        
                        if products.isEmpty {
                            EmptyStateView(status: selectedTab)
                                .padding(.top, 100)
                        } else {
                            ForEach(products) { product in
                                NavigationLink(destination: ProductDetailView(productId: product.id)
                                    .environmentObject(productStore)) {
                                    ProductRowView(product: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
                .environmentObject(productStore)
                .environmentObject(achievementManager)
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? ColorManager.primaryBlue : ColorManager.secondaryText)
                
                Rectangle()
                    .fill(isSelected ? ColorManager.primaryBlue : Color.clear)
                    .frame(height: 3)
                    .cornerRadius(1.5)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 8) {
                Text(product.category.icon)
                    .font(.system(size: 20))
                
                Circle()
                    .fill(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                    .frame(width: 12, height: 12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(product.name)
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    if product.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(ColorManager.primaryYellow)
                    }
                }
                
                Text(product.category.rawValue)
                    .font(.playfairDisplay(size: 11, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(product.status.shortName)
                .font(.playfairDisplay(size: 12, weight: .medium))
                .foregroundColor(ColorManager.whiteText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                )
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct EmptyStateView: View {
    let status: ProductStatus
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            VStack(spacing: 8) {
                Text("No Products Yet")
                    .font(.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Here will appear products that you mark as \(status.displayName.lowercased()). Add your first product to get started.")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
        }
    }
}
