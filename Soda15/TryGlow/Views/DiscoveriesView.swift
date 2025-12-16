import SwiftUI

struct DiscoveriesView: View {
    @ObservedObject var viewModel: BeautyProductViewModel
    @State private var showingAddProduct = false
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        ZStack {
            colorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.products.isEmpty {
                    emptyStateView
                } else {
                    contentView
                }
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            HStack {
                Text("My Discoveries")
                    .font(.custom("PlayfairDisplay-Bold", size: 28))
                    .foregroundColor(colorManager.primaryWhite)
                
                Spacer()
                
                Button(action: {
                    showingAddProduct = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(colorManager.primaryWhite)
                        .shadow(color: .black.opacity(0.2), radius: 2)
                }
            }
            
            categoryFilters
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryFilterButton(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    viewModel.selectedCategory = nil
                }
                
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        title: category.rawValue,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(colorManager.primaryWhite.opacity(0.7))
            
            Text("Here will be your new finds. Add your first product to start the diary!")
                .font(.custom("PlayfairDisplay-Regular", size: 18))
                .foregroundColor(colorManager.primaryWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingAddProduct = true
            }) {
                Text("New Discovery")
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(colorManager.secondaryText)
                    .frame(width: 200, height: 50)
                    .background(colorManager.primaryWhite)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
            
            Spacer()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.filteredProducts()) { product in
                    ProductCard(product: product, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("PlayfairDisplay-Medium", size: 14))
                .foregroundColor(isSelected ? colorManager.secondaryText : colorManager.primaryWhite)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? colorManager.primaryWhite : colorManager.primaryWhite.opacity(0.2))
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct ProductCard: View {
    let product: BeautyProduct
    @ObservedObject var viewModel: BeautyProductViewModel
    @State private var showingDetails = false
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        Button(action: {
            showingDetails = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                            .foregroundColor(colorManager.secondaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text(product.category.rawValue)
                            .font(.custom("PlayfairDisplay-Regular", size: 14))
                            .foregroundColor(colorManager.accentText)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingEdit = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                            .foregroundColor(colorManager.accentText)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text(product.description)
                    .font(.custom("PlayfairDisplay-Regular", size: 14))
                    .foregroundColor(colorManager.secondaryText.opacity(0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= product.rating ? "star.fill" : "star")
                                .font(.system(size: 12))
                                .foregroundColor(colorManager.primaryYellow)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: product.category.icon)
                        .font(.system(size: 16))
                        .foregroundColor(colorManager.accentText)
                }
            }
            .padding(16)
            .background(colorManager.cardGradient)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture {
            showingDeleteAlert = true
        }
        .sheet(isPresented: $showingDetails) {
            ProductDetailView(product: product, viewModel: viewModel)
        }
        .sheet(isPresented: $showingEdit) {
            EditProductView(product: product, viewModel: viewModel)
        }
        .alert("Delete this discovery?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteProduct(product)
            }
        }
    }
}

#Preview {
    DiscoveriesView(viewModel: BeautyProductViewModel())
}
