import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: WeatherEntriesViewModel
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var showingDeleteAlert = false
    @State private var categoryToDelete: WeatherCategory?
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoriesListView
                }
            }
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            TextField("Category name", text: $newCategoryName)
            Button("Create") {
                createNewCategory()
            }
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
        } message: {
            Text("Enter a name for the new weather category.")
        }
        .alert("Delete Category", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    viewModel.deleteCategory(category)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this category? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Weather Categories")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: { showingNewCategoryAlert = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.buttonText)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppColors.buttonBackground)
                    )
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.md)
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(viewModel.categories, id: \.id) { category in
                    NavigationLink(destination: FilteredEntriesView(viewModel: viewModel, category: category, selectedTab: $selectedTab)) {
                        CategoryRowView(
                            category: category,
                            entryCount: viewModel.categoryEntryCount(category)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(action: {
                            viewModel.applyFilter(category: category)
                        }) {
                            Label("View Entries", systemImage: "eye")
                        }
                        
                        if viewModel.categoryEntryCount(category) == 0 {
                            Button(role: .destructive, action: {
                                categoryToDelete = category
                                showingDeleteAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        if viewModel.categoryEntryCount(category) == 0 {
                            Button(role: .destructive, action: {
                                categoryToDelete = category
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "tag")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.sm) {
                Text("No categories created yet")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Create categories to organize your weather entries")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingNewCategoryAlert = true }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Create First Category")
                        .font(AppFonts.headline)
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(AppColors.buttonBackground)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
    }
    
    private func createNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newCategory = WeatherCategory(name: trimmedName)
        viewModel.addCategory(newCategory)
        newCategoryName = ""
    }
}

struct CategoryRowView: View {
    let category: WeatherCategory
    let entryCount: Int
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Circle()
                .fill(AppColors.primaryPurple)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: categoryIcon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.buttonText)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(entryCount) \(entryCount == 1 ? "entry" : "entries")")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.textTertiary)
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var categoryIcon: String {
        switch category.name.lowercased() {
        case "sunny", "sun":
            return "sun.max.fill"
        case "rainy", "rain":
            return "cloud.rain.fill"
        case "cloudy", "cloud":
            return "cloud.fill"
        case "snowy", "snow":
            return "cloud.snow.fill"
        case "stormy", "storm":
            return "cloud.bolt.fill"
        case "windy", "wind":
            return "wind"
        default:
            return "cloud"
        }
    }
}

