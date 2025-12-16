import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: CategoriesViewModel
    @ObservedObject var combinationsViewModel: ScentCombinationsViewModel
    @Binding var selectedTab: TabSelection
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.combinations.isEmpty {
                    emptyStateView
                } else {
                    categoriesListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Aroma Categories")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "list.bullet.circle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.purpleGradientStart.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No data yet")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.darkGray)
                
                Text("Add at least one combination to see categories.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                selectedTab = .combinations
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add First Combination")
                }
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .frame(width: 220, height: 50)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.purpleGradientStart.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(ScentCategory.allCases, id: \.self) { category in
                    CategoryRowView(
                        category: category,
                        count: viewModel.categoryCounts[category] ?? 0
                    ) {
                        combinationsViewModel.setCategoryFilter(category)
                        selectedTab = .combinations
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CategoryRowView: View {
    let category: ScentCategory
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.darkGray)
                    
                    Text("\(count) combination\(count == 1 ? "" : "s")")
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.darkGray.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.darkGray.opacity(0.5))
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryColor: Color {
        switch category {
        case .warm: return Color.orange
        case .fresh: return Color.blue
        case .floral: return Color.pink
        case .sweet: return AppColors.yellowAccent
        case .other: return AppColors.purpleGradientStart
        }
    }
}

#Preview {
    CategoriesView(
        viewModel: CategoriesViewModel(),
        combinationsViewModel: ScentCombinationsViewModel(),
        selectedTab: .constant(.categories)
    )
}
