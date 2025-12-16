import SwiftUI
import Combine

struct ProductsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedFilter: ProductFilter = .all
    
    private var filteredProducts: [ProductUsage] {
        let products = dataManager.getProductUsage()
        switch selectedFilter {
        case .all:
            return products
        case .frequent:
            return products.filter { $0.usageCount >= 3 }
        case .rare:
            return products.filter { $0.usageCount <= 2 }
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Products")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Refresh Data") {
                        dataManager.objectWillChange.send()
                    }
                    .font(.custom("PlayfairDisplay-Medium", size: 14))
                    .foregroundColor(AppColors.primaryText)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ProductFilter.allCases, id: \.self) { filter in
                            FilterButton(
                                title: filter.title,
                                isSelected: selectedFilter == filter
                            ) {
                                selectedFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
                
                if filteredProducts.isEmpty {
                    ProductsEmptyStateView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredProducts) { product in
                                ProductCardView(product: product, dataManager: dataManager)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
            }
        }
    }
}

enum ProductFilter: CaseIterable {
    case all, frequent, rare
    
    var title: String {
        switch self {
        case .all:
            return "All Products"
        case .frequent:
            return "Frequently Used"
        case .rare:
            return "Rarely Used"
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
                .font(.custom("PlayfairDisplay-Medium", size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AnyShapeStyle(AppColors.purpleGradient) : AnyShapeStyle(Color.clear)
                )
                .foregroundColor(isSelected ? .white : AppColors.primaryText)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(20)
        }
    }
}

struct ProductCardView: View {
    let product: ProductUsage
    @ObservedObject var dataManager: DataManager
    
    var body: some View {
        Button(action: {
            dataManager.selectedProduct = product.name
            dataManager.selectedCategory = nil
            NotificationCenter.default.post(name: NSNotification.Name("SwitchToMySalonTab"), object: nil)
        }) {
            HStack(spacing: 16) {
                Image(systemName: "waterbottle")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 40, height: 40)
                    .background(AppColors.accentYellow.opacity(0.2))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Used \(product.usageCount) time\(product.usageCount == 1 ? "" : "s")")
                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("Last used: \(DateFormatter.shortDate.string(from: product.lastUsed))")
                        .font(.custom("PlayfairDisplay-Regular", size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                VStack {
                    Text("\(product.usageCount)")
                        .font(.custom("PlayfairDisplay-Bold", size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("uses")
                        .font(.custom("PlayfairDisplay-Regular", size: 10))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(AppColors.accentYellow.opacity(0.2))
                .cornerRadius(8)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProductsEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "waterbottle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No products added yet. Add procedures to your journal to see them here.")
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ProductsView()
        .environmentObject(DataManager())
}
