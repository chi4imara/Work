import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.categoriesWithCount.isEmpty {
                    EmptyStateView(
                        title: "No categories yet",
                        subtitle: "Categories will appear after adding recipes",
                        systemImage: "folder"
                    )
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.categoriesWithCount, id: \.category.id) { categoryData in
                                NavigationLink(destination: CategoryRecipesView(
                                    category: categoryData.category,
                                    viewModel: viewModel
                                )) {
                                    CategoryCardView(
                                        category: categoryData.category,
                                        count: categoryData.count
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
    }
}

struct CategoryCardView: View {
    let category: RecipeCategory
    let count: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category.displayName)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("\(count) recipe\(count == 1 ? "" : "s")")
                    .font(.ubuntu(14))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(ColorManager.secondaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardGradient)
        )
    }
}

#Preview {
    CategoriesView(viewModel: RecipeViewModel())
}
