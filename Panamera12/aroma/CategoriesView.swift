import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @State private var selectedFilter: FragranceFilter?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Categories")
                        .font(.bauhausBold(28))
                        .foregroundColor(.appPrimaryBlue)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if viewModel.seasonCategories.isEmpty && viewModel.occasionCategories.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 30) {
                            if !viewModel.seasonCategories.isEmpty {
                                CategorySectionView(
                                    title: "Seasons",
                                    categories: viewModel.seasonCategories,
                                    icon: "calendar",
                                    onCategoryTap: { category in
                                        if case .season(let season) = category.type {
                                            selectedFilter = .season(season)
                                        }
                                    }
                                )
                            }
                            
                            if !viewModel.occasionCategories.isEmpty {
                                CategorySectionView(
                                    title: "Occasions",
                                    categories: viewModel.occasionCategories,
                                    icon: "clock",
                                    onCategoryTap: { category in
                                        if case .occasion(let occasion) = category.type {
                                            selectedFilter = .occasion(occasion)
                                        }
                                    }
                                )
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .fullScreenCover(item: Binding<FragranceFilter?>(
            get: { selectedFilter },
            set: { selectedFilter = $0 }
        )) { filter in
            FilteredFragrancesView(filter: filter, viewModel: viewModel)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "square.grid.3x3")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.appPrimaryBlue.opacity(0.3))
            
            VStack(spacing: 15) {
                Text("No categories yet.")
                    .font(.bauhausMedium(22))
                    .foregroundColor(.appPrimaryBlue)
                
                Text("Categories will be formed automatically as you add fragrances.")
                    .font(.bauhausLight(16))
                    .foregroundColor(.appTextGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategorySectionView: View {
    let title: String
    let categories: [Category]
    let icon: String
    let onCategoryTap: (Category) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.appPrimaryYellow)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.bauhausBold(22))
                    .foregroundColor(.appPrimaryBlue)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(categories, id: \.name) { category in
                    CategoryCardView(category: category) {
                        onCategoryTap(category)
                    }
                }
            }
        }
    }
}

struct CategoryCardView: View {
    let category: Category
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text("\(category.count)")
                    .font(.bauhausBold(24))
                    .foregroundColor(.appPrimaryBlue)
                
                Text(category.name)
                    .font(.bauhausLight(14))
                    .foregroundColor(.appTextGray)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension FragranceFilter: Identifiable {
    var id: String {
        switch self {
        case .all:
            return "all"
        case .favorites:
            return "favorites"
        case .season(let season):
            return "season_\(season.rawValue)"
        case .occasion(let occasion):
            return "occasion_\(occasion)"
        case .search(let query):
            return "search_\(query)"
        }
    }
}

#Preview {
    CategoriesView(viewModel: FragranceViewModel())
}
