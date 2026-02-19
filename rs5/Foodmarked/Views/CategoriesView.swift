import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var selectedCategory: ProductCategory?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Categories")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(ProductCategory.allCases, id: \.self) { category in
                            CategoryCard(
                                category: category,
                                count: productStore.products.filter { $0.category == category }.count,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if let selectedCategory = selectedCategory {
                        CategoryProductsView(category: selectedCategory)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct CategoryCard: View {
    let category: ProductCategory
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(category.icon)
                    .font(.system(size: 40))
                
                Text(category.rawValue)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("\(count) items")
                    .font(.playfairDisplay(size: 12, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AnyShapeStyle(category.color.opacity(0.2)) : AnyShapeStyle(ColorManager.cardGradient))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? category.color : Color.clear, lineWidth: 2)
                    )
                    .shadow(color: category.color.opacity(0.2), radius: isSelected ? 8 : 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryProductsView: View {
    @EnvironmentObject var productStore: ProductStore
    let category: ProductCategory
    
    var categoryProducts: [Product] {
        productStore.products.filter { $0.category == category }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(category.icon) \(category.rawValue)")
                    .font(.playfairDisplay(size: 20, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(categoryProducts.count) items")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(.horizontal, 20)
            
            if categoryProducts.isEmpty {
                Text("No products in this category")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(categoryProducts) { product in
                        NavigationLink(destination: ProductDetailView(productId: product.id)
                            .environmentObject(productStore)) {
                            CategoryProductRow(product: product)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 20)
    }
}

struct CategoryProductRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                .frame(width: 10, height: 10)
            
            Text(product.name)
                .font(.playfairDisplay(size: 15, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if product.isFavorite {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(ColorManager.primaryYellow)
            }
            
            Text(product.status.shortName)
                .font(.playfairDisplay(size: 11, weight: .medium))
                .foregroundColor(ColorManager.whiteText)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}
