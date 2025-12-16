import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: BeautyProductViewModel
    @State private var selectedCategory: ProductCategory?
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        ZStack {
            colorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if selectedCategory == nil {
                    categoriesGridView
                } else {
                    categoryProductsView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            if selectedCategory != nil {
                Button(action: {
                    selectedCategory = nil
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(colorManager.primaryWhite)
                }
            }
            
            Text(selectedCategory?.rawValue ?? "Categories")
                .font(.custom("PlayfairDisplay-Bold", size: 28))
                .foregroundColor(colorManager.primaryWhite)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .animation(.easeInOut, value: selectedCategory)
    }
    
    private var categoriesGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    CategoryTile(
                        category: category,
                        productCount: viewModel.productsByCategory(category).count
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 100)
        }
    }
    
    private var categoryProductsView: some View {
        ScrollView {
            if let category = selectedCategory {
                let products = viewModel.productsByCategory(category)
                
                if products.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: category.icon)
                            .font(.system(size: 60))
                            .foregroundColor(colorManager.primaryWhite.opacity(0.7))
                        
                        Text("No discoveries in this category yet.")
                            .font(.custom("PlayfairDisplay-Regular", size: 18))
                            .foregroundColor(colorManager.primaryWhite)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVStack(spacing: 15) {
                        ForEach(products) { product in
                            ProductCard(product: product, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct CategoryTile: View {
    let category: ProductCategory
    let productCount: Int
    let action: () -> Void
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: category.icon)
                    .font(.system(size: 40))
                    .foregroundColor(colorManager.accentText)
                
                VStack(spacing: 4) {
                    Text(category.rawValue)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                        .foregroundColor(colorManager.secondaryText)
                    
                    Text("\(productCount) product\(productCount == 1 ? "" : "s")")
                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                        .foregroundColor(colorManager.secondaryText.opacity(0.7))
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(colorManager.cardGradient)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoriesView(viewModel: BeautyProductViewModel())
}
