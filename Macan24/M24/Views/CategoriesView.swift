import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: BreakfastViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.breakfasts.isEmpty {
                        emptyStateView
                    } else {
                        categoriesList
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Breakfast Categories")
                .font(.playfairDisplay(size: 32, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.getCategoriesWithCounts(), id: \.category) { categoryData in
                    CategoryCardView(
                        category: categoryData.category,
                        count: categoryData.count
                    ) {
                        viewModel.filterByCategory(categoryData.category)
                        withAnimation {
                            selectedTab = 0
                        }
                    }
                }
                
                ForEach(BreakfastCategory.allCases.filter { category in
                    !viewModel.getCategoriesWithCounts().contains { $0.category == category }
                }, id: \.self) { category in
                    CategoryCardView(
                        category: category,
                        count: 0
                    ) {
                        
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 80))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Categories will appear after adding first breakfasts")
                    .font(.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text("Start by adding your first breakfast to see categories here")
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.textGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategoryCardView: View {
    let category: BreakfastCategory
    let count: Int
    let action: () -> Void
    
    private var categoryIcon: String {
        switch category {
        case .weekday:
            return "briefcase.fill"
        case .weekend:
            return "house.fill"
        case .holiday:
            return "star.fill"
        case .outdoor:
            return "leaf.fill"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .weekday:
            return AppColors.primaryBlue
        case .weekend:
            return AppColors.accentGreen
        case .holiday:
            return AppColors.primaryYellow
        case .outdoor:
            return AppColors.accentOrange
        }
    }
    
    var body: some View {
        Button(action: count > 0 ? action : {}) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: categoryIcon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.playfairDisplay(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text("\(count) breakfast\(count == 1 ? "" : "s")")
                        .font(.playfairDisplay(size: 16))
                        .foregroundColor(AppColors.textGray)
                }
                
                Spacer()
                
                if count > 0 {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.textGray.opacity(0.6))
                } else {
                    Text("Empty")
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textGray.opacity(0.6))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.softGray)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.backgroundWhite.opacity(count > 0 ? 0.95 : 0.7))
                    .shadow(
                        color: AppColors.primaryBlue.opacity(count > 0 ? 0.1 : 0.05),
                        radius: count > 0 ? 10 : 5,
                        x: 0,
                        y: count > 0 ? 4 : 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(categoryColor.opacity(0.3), lineWidth: count > 0 ? 2 : 1)
            )
        }
        .disabled(count == 0)
        .buttonStyle(PlainButtonStyle())
    }
}
