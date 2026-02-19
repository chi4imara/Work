import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Categories")
                        .font(.bellGothicBold(size: 24))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.fragrances.isEmpty {
                    EmptyStateView(message: "Categories will appear after adding fragrances.")
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            CategorySectionView(
                                title: "Seasons",
                                categories: viewModel.seasonCategories,
                                icon: "calendar"
                            )
                            
                            CategorySectionView(
                                title: "Styles",
                                categories: viewModel.styleCategories,
                                icon: "paintbrush"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
}

struct CategorySectionView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    let title: String
    let categories: [Category]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppColors.primaryYellow)
                    .font(.title2)
                
                Text(title)
                    .font(.bellGothicBold(size: 22))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(categories) { category in
                    NavigationLink(destination: CategoryFragrancesView(category: category)
                        .environmentObject(viewModel)) {
                        CategoryRowView(category: category)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
        )
    }
}

struct CategoryRowView: View {
    let category: Category
    
    var body: some View {
        HStack {
            Image(systemName: categoryIcon(for: category))
                .foregroundColor(AppColors.primaryYellow)
                .font(.title3)
                .frame(width: 24)
            
            Text(category.name)
                .font(.bellGothicRegular(size: 18))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Text("\(category.count)")
                .font(.bellGothicBold(size: 14))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.primaryYellow.opacity(0.3))
                )
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.textSecondary)
                .font(.caption)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.buttonSecondary)
        )
    }
    
    private func categoryIcon(for category: Category) -> String {
        switch category.type {
        case .season(let season):
            switch season {
            case .spring: return "leaf"
            case .summer: return "sun.max"
            case .autumn: return "leaf.fill"
            case .winter: return "snowflake"
            case .allSeasons: return "circle"
            }
        case .style(_):
            return "sparkles"
        }
    }
}

#Preview {
    CategoriesView()
        .environmentObject(FragranceViewModel())
}
