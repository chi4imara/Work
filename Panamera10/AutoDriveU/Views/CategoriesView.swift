import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: ModificationViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.categorySummaries.isEmpty {
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
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("\(viewModel.categorySummaries.count) categories")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No Categories")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("Categories will appear after adding modifications.")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.categorySummaries) { summary in
                    NavigationLink(destination: CategoryDetailView(category: summary.category)
                        .environmentObject(viewModel)) {
                        CategoryCard(summary: summary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct CategoryCard: View {
    let summary: CategorySummary
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.categoryColor(for: summary.category).opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: categoryIcon(for: summary.category))
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppColors.categoryColor(for: summary.category))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(summary.category.displayName)
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.cardText)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "wrench.and.screwdriver")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.cardText.opacity(0.6))
                        
                        Text("\(summary.count) mods")
                            .font(FontManager.subheadline)
                            .foregroundColor(AppColors.cardText.opacity(0.8))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.cardText.opacity(0.6))
                        
                        Text("$\(Int(summary.totalBudget))")
                            .font(FontManager.subheadline)
                            .foregroundColor(AppColors.cardText.opacity(0.8))
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.cardText.opacity(0.4))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func categoryIcon(for category: ModificationCategory) -> String {
        switch category {
        case .exterior:
            return "car.fill"
        case .technical:
            return "wrench.and.screwdriver.fill"
        case .interior:
            return "carseat.right.fill"
        case .electrical:
            return "bolt.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}

struct CategoryDetailView: View {
    @EnvironmentObject var viewModel: ModificationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let category: ModificationCategory
    
    private var categoryModifications: [Modification] {
        viewModel.modifications.filter { $0.category == category }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if categoryModifications.isEmpty {
                    emptyStateView
                } else {
                    modificationsList
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryWhite)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(AppColors.primaryDarkBlue.opacity(0.8))
                    )
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(category.displayName)
                    .font(FontManager.title1)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("\(categoryModifications.count) modifications")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
            }
            
            Spacer()
            
            Color.clear
                .frame(width: 42, height: 42)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: categoryIcon(for: category))
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No Modifications")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("No modifications in this category yet.")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
    
    private var modificationsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(categoryModifications) { modification in
                    NavigationLink(destination: ModificationDetailView(modificationId: modification.id)
                        .environmentObject(viewModel)) {
                        CategoryModificationCard(modification: modification)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func categoryIcon(for category: ModificationCategory) -> String {
        switch category {
        case .exterior:
            return "car.fill"
        case .technical:
            return "wrench.and.screwdriver.fill"
        case .interior:
            return "carseat.right.fill"
        case .electrical:
            return "bolt.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}

struct CategoryModificationCard: View {
    let modification: Modification
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(AppColors.statusColor(for: modification.status))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(modification.name)
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.cardText)
                    .lineLimit(2)
                
                Text(modification.status.displayName)
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.statusColor(for: modification.status))
            }
            
            Spacer()
            
            Text("$\(Int(modification.budget))")
                .font(FontManager.headline)
                .foregroundColor(AppColors.cardText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    CategoriesView()
        .environmentObject(ModificationViewModel())
}
