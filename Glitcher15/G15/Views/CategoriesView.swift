import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: ItemsViewModel
    @State private var selectedCategory: ItemCategory?
    
    var categorizedItems: [ItemCategory: [Item]] {
        viewModel.getItemsByCategory()
    }
    
    var body: some View {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if categorizedItems.isEmpty {
                        emptyStateView
                        
                        Spacer()
                    } else {
                        categoriesListView
                    }
                }
            }
        .sheet(item: $selectedCategory) { category in
            CategoryItemsView(category: category, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(FontManager.playfairBold(size: 28))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("Categories will appear after adding items.")
                .font(FontManager.playfairMedium(size: 18))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(categorizedItems.keys.sorted(by: { $0.displayName < $1.displayName })), id: \.self) { category in
                    CategoryCardView(
                        category: category,
                        itemCount: categorizedItems[category]?.count ?? 0
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
}

struct CategoryCardView: View {
    let category: ItemCategory
    let itemCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: categoryIcon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.yellow)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppColors.yellow.opacity(0.2))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(FontManager.playfairSemiBold(size: 18))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(itemCount) item\(itemCount == 1 ? "" : "s")")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.yellow.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryIcon: String {
        switch category {
        case .documents:
            return "doc.text"
        case .cosmetics:
            return "paintbrush"
        case .gadgets:
            return "iphone"
        case .accessories:
            return "bag"
        case .products:
            return "cart"
        case .other:
            return "questionmark.circle"
        }
    }
}
