import SwiftUI

struct ExperimentsView: View {
    @ObservedObject var viewModel: ProductViewModel
    @State private var showingAddProduct = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Experiments")
                        .font(.playfair(28, weight: .bold))
                        .foregroundColor(AppColors.blueText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddProduct = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(AppColors.yellow)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.mediumGray)
                    
                    TextField("Search by product", text: $viewModel.searchText)
                        .font(.playfair(16))
                        .foregroundColor(AppColors.blueText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardGradient)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                if viewModel.filteredProducts.isEmpty {
                    EmptyStateView()
                } else {
                    ProductListView(viewModel: viewModel)
                }
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView(viewModel: viewModel)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "flask")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mediumGray)
            
            Text("You haven't tried any new products yet. Add your first one.")
                .font(.playfair(18, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct ProductListView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredProducts) { product in
                    NavigationLink(destination: ProductDetailView(productId: product.id, viewModel: viewModel)) {
                        ProductCardView(product: product)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.playfair(18, weight: .semibold))
                        .foregroundColor(AppColors.blueText)
                        .lineLimit(2)
                    
                    Text(product.category.displayName)
                        .font(.playfair(14, weight: .medium))
                        .foregroundColor(AppColors.mediumBlue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    ResultBadge(result: product.result)
                    
                    if product.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.yellow)
                    }
                }
            }
            
            HStack {
                Text(DateFormatter.shortDate.string(from: product.firstUseDate))
                    .font(.playfair(12, weight: .regular))
                    .foregroundColor(AppColors.mediumGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.mediumGray)
            }
            
            if !product.notes.isEmpty {
                Text(product.notes)
                    .font(.playfair(14, weight: .regular))
                    .foregroundColor(AppColors.darkGray)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
    }
}

struct ResultBadge: View {
    let result: ProductResult
    
    private var color: Color {
        switch result {
        case .liked:
            return AppColors.likedColor
        case .neutral:
            return AppColors.neutralColor
        case .disliked:
            return AppColors.dislikedColor
        }
    }
    
    var body: some View {
        Text(result.displayName)
            .font(.playfair(12, weight: .semibold))
            .foregroundColor(AppColors.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
            )
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    NavigationView {
        ExperimentsView(viewModel: ProductViewModel())
    }
}
