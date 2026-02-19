import SwiftUI

struct SearchView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var searchText = ""
    @State private var selectedStatus: ProductStatusFilter = .all
    
    enum ProductStatusFilter: String, CaseIterable {
        case all = "All"
        case suitable = "Suitable"
        case unsuitable = "Not Suitable"
        
        var status: ProductStatus? {
            switch self {
            case .all:
                return nil
            case .suitable:
                return .suitable
            case .unsuitable:
                return .unsuitable
            }
        }
    }
    
    var filteredProducts: [Product] {
        var products = productStore.products
        
        if let status = selectedStatus.status {
            products = products.filter { $0.status == status }
        }
        
        if !searchText.isEmpty {
            products = products.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return products.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Search")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.horizontal ,20)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(ColorManager.secondaryText)
                        
                        TextField("Search products...", text: $searchText)
                            .font(.playfairDisplay(size: 16, weight: .regular))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ProductStatusFilter.allCases, id: \.self) { filter in
                                FilterButton(
                                    title: filter.rawValue,
                                    isSelected: selectedStatus == filter,
                                    action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedStatus = filter
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 5)
                
                if filteredProducts.isEmpty {
                    EmptySearchView(hasSearchText: !searchText.isEmpty)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredProducts) { product in
                                NavigationLink(destination: ProductDetailView(productId: product.id)
                                    .environmentObject(productStore)) {
                                    SearchProductRowView(product: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfairDisplay(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? ColorManager.whiteText : ColorManager.primaryText)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(isSelected ? ColorManager.primaryBlue : Color.white)
                        .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                )
        }
    }
}

struct SearchProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(product.status.displayName)
                    .font(.playfairDisplay(size: 12, weight: .regular))
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

struct EmptySearchView: View {
    let hasSearchText: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: hasSearchText ? "magnifyingglass" : "tray")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            VStack(spacing: 8) {
                Text(hasSearchText ? "No Results Found" : "Start Searching")
                    .font(.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(hasSearchText ? 
                     "Try adjusting your search or filter to find what you're looking for." :
                     "Search for products in your list or use filters to narrow down results.")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
        }
    }
}
