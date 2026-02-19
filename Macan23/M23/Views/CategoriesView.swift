import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: HabitsViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            AnimatedBubblesBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.habits.isEmpty {
                    emptyStateView
                } else {
                    categoriesList
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Categories")
                .font(.ubuntu(size: 32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(HabitCategory.allCases, id: \.self) { category in
                    CategoryCardView(
                        category: category,
                        count: viewModel.categoryCounts[category] ?? 0
                    ) {
                        viewModel.selectCategory(category)
                        withAnimation {
                            selectedTab = 0
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "square.grid.3x3")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentBlue.opacity(0.6))
            
            Text("Categories will appear after adding your first habits.")
                .font(.ubuntu(size: 18))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct CategoryCardView: View {
    let category: HabitCategory
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.accent.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: categoryIcon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.ubuntu(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(count) habit\(count == 1 ? "" : "s")")
                        .font(.ubuntu(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Text("\(count)")
                    .font(.ubuntu(size: 16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .frame(minWidth: 30, minHeight: 30)
                    .background(AppColors.accent.opacity(0.3))
                    .cornerRadius(15)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryIcon: String {
        switch category {
        case .morning:
            return "sunrise.fill"
        case .day:
            return "sun.max.fill"
        case .evening:
            return "sunset.fill"
        case .weekend:
            return "calendar"
        }
    }
}
