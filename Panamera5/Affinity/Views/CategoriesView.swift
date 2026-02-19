import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var brandStore: BrandStore

    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(.bauhaus(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if brandStore.categoriesWithCounts.isEmpty {
                    EmptyCategoriesView()
                } else {
                    CategoryListView(categoriesWithCounts: brandStore.categoriesWithCounts, brandStore: brandStore)
                }
            }
        }
    }
}

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("Categories will appear after adding brands.")
                .font(.bauhaus(18, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

struct CategoryListView: View {
    let categoriesWithCounts: [(category: BrandCategory, count: Int)]
    let brandStore: BrandStore
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(categoriesWithCounts, id: \.category) { item in
                    NavigationLink(destination: CategoryBrandsView(category: item.category, brandStore: brandStore)) {
                        CategoryCardView(category: item.category, count: item.count)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

struct CategoryCardView: View {
    let category: BrandCategory
    let count: Int
    
    private var countText: String {
        return count == 1 ? "1 brand" : "\(count) brands"
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.displayName)
                    .font(.bauhaus(20, weight: .bold))
                    .foregroundColor(AppColors.darkGray)
                
                Text(countText)
                    .font(.bauhaus(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.darkGray.opacity(0.6))
        }
        .padding()
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var categoryIcon: String {
        switch category {
        case .clothing:
            return "tshirt"
        case .cosmetics:
            return "paintbrush"
        case .accessories:
            return "bag"
        case .perfume:
            return "drop"
        case .other:
            return "star"
        }
    }
}

#Preview {
    CategoriesView()
}
