import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: AccessoryViewModel
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.accessories.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    categoriesListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Accessory Categories")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryWhite)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.getCategoryCounts(), id: \.type) { categoryData in
                    CategoryCardView(
                        type: categoryData.type,
                        count: categoryData.count
                    ) {
                        withAnimation {
                            viewModel.filterByType(categoryData.type)
                            selectedTab = .catalog
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Categories Yet")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("Categories will appear after adding your first accessories.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                selectedTab = .add
            }) {
                Text("Add First Accessory")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryWhite)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

struct CategoryCardView: View {
    let type: AccessoryType
    let count: Int
    let onTap: () -> Void
    
    private var categoryIcon: String {
        switch type {
        case .glasses:
            return "eyeglasses"
        case .belt:
            return "circle.dotted"
        case .gloves:
            return "hand.raised"
        case .umbrella:
            return "umbrella"
        case .other:
            return "questionmark.circle"
        }
    }
    
    private var categoryColor: Color {
        switch type {
        case .glasses:
            return AppColors.primaryBlue
        case .belt:
            return AppColors.accentOrange
        case .gloves:
            return AppColors.accentGreen
        case .umbrella:
            return AppColors.primaryPurple
        case .other:
            return AppColors.darkGray
        }
    }
    
    var body: some View {
        Button(action: onTap) {
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
                    Text(type.displayName)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Text("\(count) \(count == 1 ? "item" : "items")")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            }
            .padding(20)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoriesView(viewModel: AccessoryViewModel(), selectedTab: .constant(.categories))
}
