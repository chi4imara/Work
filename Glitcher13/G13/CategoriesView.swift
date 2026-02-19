import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(.playfair(28, weight: .bold))
                        .foregroundColor(AppColors.blueText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.categoriesInfo.isEmpty {
                    EmptyStateCategoriesView()
                } else {
                    CategoriesListView(viewModel: viewModel)
                }
            }
        }
    }
}

struct EmptyStateCategoriesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mediumGray)
            
            Text("Categories will appear after adding products.")
                .font(.playfair(18, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct CategoriesListView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.categoriesInfo, id: \.category) { categoryInfo in
                    NavigationLink(destination: CategoryProductsView(category: categoryInfo.category, viewModel: viewModel)) {
                        CategoryCardView(categoryInfo: categoryInfo)
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

struct CategoryCardView: View {
    let categoryInfo: CategoryInfo
    
    private var categoryColor: Color {
        switch categoryInfo.category {
        case .skincare:
            return AppColors.green
        case .makeup:
            return AppColors.yellow
        case .cleansing:
            return AppColors.mediumBlue
        case .fragrance:
            return AppColors.purple
        case .other:
            return AppColors.mediumGray
        }
    }
    
    private var categoryIcon: String {
        switch categoryInfo.category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .cleansing:
            return "bubbles.and.sparkles.fill"
        case .fragrance:
            return "aqi.medium"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(categoryInfo.category.displayName)
                    .font(.playfair(18, weight: .semibold))
                    .foregroundColor(AppColors.blueText)
                
                Text("\(categoryInfo.productCount) product\(categoryInfo.productCount == 1 ? "" : "s")")
                    .font(.playfair(14, weight: .regular))
                    .foregroundColor(AppColors.mediumGray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.mediumGray)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
    }
}

#Preview {
    NavigationView {
        CategoriesView(viewModel: ProductViewModel())
    }
}
