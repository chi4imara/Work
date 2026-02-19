import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: CosmeticsViewModel
    var onCategorySelected: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoriesList
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Categories")
                    .font(.bellGothic(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                if !viewModel.categories.isEmpty {
                    Text("\(viewModel.categories.count) categories")
                        .font(.bellGothic(14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            if viewModel.selectedCategory != nil {
                Button {
                    viewModel.clearCategoryFilter()
                } label: {
                    Text("Clear Filter")
                        .font(.bellGothic(14, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(AppColors.errorRed)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "folder.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow.opacity(0.7))
            
            VStack(spacing: 12) {
                Text("No categories yet")
                    .font(.bellGothic(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Categories will be automatically created when you add products.")
                    .font(.bellGothic(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if !productTypeCategories.isEmpty {
                    categorySection(title: "Product Types", categories: productTypeCategories)
                }
                
                if !textureCategories.isEmpty {
                    categorySection(title: "Textures", categories: textureCategories)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var productTypeCategories: [Category] {
        viewModel.categories.filter { category in
            if case .productType = category.type {
                return true
            }
            return false
        }
    }
    
    private var textureCategories: [Category] {
        viewModel.categories.filter { category in
            if case .texture = category.type {
                return true
            }
            return false
        }
    }
    
    private func categorySection(title: String, categories: [Category]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.bellGothic(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(categories) { category in
                    CategoryCardView(
                        category: category,
                        isSelected: viewModel.selectedCategory?.id == category.id
                    ) {
                        if viewModel.selectedCategory?.id == category.id {
                            viewModel.clearCategoryFilter()
                        } else {
                            viewModel.selectCategory(category)
                            onCategorySelected?()
                        }
                    }
                }
            }
        }
    }
}

struct CategoryCardView: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isSelected ? AppColors.primaryText : AppColors.accentYellow)
                
                Text(category.name)
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text("\(category.count) item\(category.count == 1 ? "" : "s")")
                    .font(.bellGothic(12))
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.accentYellow : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? AppColors.accentYellow : AppColors.accentYellow.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var iconName: String {
        switch category.type {
        case .productType(let productType):
            switch productType {
            case .foundation: return "face.smiling"
            case .concealer: return "eye"
            case .blush: return "heart.circle"
            case .lipstick: return "mouth"
            case .eyeshadow: return "eye.circle"
            case .mascara: return "eye.trianglebadge.exclamationmark"
            case .eyeliner: return "pencil.line"
            case .bronzer: return "sun.max"
            case .highlighter: return "sparkles"
            case .primer: return "drop"
            case .powder: return "circle.dotted"
            case .lipgloss: return "mouth.fill"
            case .other: return "questionmark.circle"
            }
        case .texture(let texture):
            switch texture {
            case .creamy: return "drop.circle"
            case .liquid: return "drop.fill"
            case .dry: return "circle"
            case .powder: return "circle.dotted"
            case .gel: return "drop.triangle"
            case .matte: return "circle.fill"
            case .glossy: return "sparkle"
            }
        }
    }
}

#Preview {
    CategoriesView(viewModel: CosmeticsViewModel())
}
