import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @State private var selectedCategory: Category?
    
    var body: some View {
        ZStack {
            AppColorScheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if productViewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoriesListView
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryProductsView(category: category)
                .environmentObject(productViewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("Categories will appear after adding products.")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(productViewModel.categories) { category in
                    CategoryCardView(category: category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

struct CategoryCardView: View {
    let category: Category
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Image(systemName: "folder.fill")
                    .font(.title2)
                    .foregroundColor(.primaryYellow)
                    .frame(width: 40, height: 40)
                    .background(Color.primaryYellow.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.name)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(category.productCount) product\(category.productCount == 1 ? "" : "s")")
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
            .background(AppColorScheme.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoriesView()
}
