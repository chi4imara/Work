import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: ScentViewModel
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    categoriesList
                }
            }
        }
        .onAppear {
            viewModel.applyFilters()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Scent Categories")
                .font(.playfairDisplay(.bold, size: 28))
                .foregroundColor(AppColors.white)
            
            Text("Browse your collection by season")
                .font(.playfairDisplay(.regular, size: 16))
                .foregroundColor(AppColors.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.yellow)
            }
            
            VStack(spacing: 12) {
                Text("No Categories Yet")
                    .font(.playfairDisplay(.bold, size: 24))
                    .foregroundColor(AppColors.white)
                
                Text("Categories will appear after adding scents.")
                    .font(.playfairDisplay(.regular, size: 16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = .collection
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add First Scent")
                        .font(.playfairDisplay(.semiBold, size: 16))
                }
                .foregroundColor(AppColors.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.yellow.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.getCategories(), id: \.season) { category in
                    CategoryCardView(category: category) {
                        viewModel.setCategory(category.season)
                        withAnimation {
                            selectedTab = .collection
                        }
                    }
                }
                
                if viewModel.selectedCategory != nil {
                    ClearFiltersCard {
                        viewModel.clearFilters()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct CategoryCardView: View {
    let category: ScentCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.yellowGradient)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.season.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.season.displayName)
                        .font(.playfairDisplay(.bold, size: 20))
                        .foregroundColor(AppColors.white)
                    
                    Text("\(category.count) scent\(category.count == 1 ? "" : "s")")
                        .font(.playfairDisplay(.medium, size: 14))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.yellow)
            }
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.deepBlue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ClearFiltersCard: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.yellow.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.yellow)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Show All Scents")
                        .font(.playfairDisplay(.semiBold, size: 18))
                        .foregroundColor(AppColors.white)
                    
                    Text("Clear category filter")
                        .font(.playfairDisplay(.regular, size: 14))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
                
                Spacer()
            }
            .padding(20)
            .background(AppColors.cardGradient.opacity(0.7))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
