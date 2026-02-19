import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel = TestsViewModel()
    @State private var selectedCategory: Category?
    @State private var selectedTestId: UUID?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if selectedCategory == nil {
                    categoriesGridView
                } else {
                    categoryTestsView
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedTestId.map { TestIdWrapper(id: $0) } },
            set: { selectedTestId = $0?.id }
        )) { wrapper in
            TestDetailView(testId: wrapper.id, viewModel: viewModel)
        }
    }
    
    private struct TestIdWrapper: Identifiable {
        let id: UUID
    }
    
    private var headerView: some View {
        HStack {
            if selectedCategory != nil {
                Button(action: { selectedCategory = nil }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.yellow)
                }
            }
            
            Text(selectedCategory?.displayName ?? "Categories")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if selectedCategory != nil {
                Text("\(testsForSelectedCategory.count) tests")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var categoriesGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryCard(
                        category: category,
                        count: viewModel.categoryStats[category] ?? 0
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var categoryTestsView: some View {
        Group {
            if testsForSelectedCategory.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(testsForSelectedCategory) { test in
                            TestCardView(test: test) {
                                selectedTestId = test.id
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: categoryIcon(for: selectedCategory ?? .skincare))
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.yellow.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No tests in this category")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("You haven't added any tests for \(selectedCategory?.displayName.lowercased() ?? "this category") yet.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    private var testsForSelectedCategory: [TestModel] {
        guard let selectedCategory = selectedCategory else { return [] }
        return viewModel.tests.filter { $0.category == selectedCategory }
            .sorted { $0.testDate > $1.testDate }
    }
    
    private func categoryIcon(for category: Category) -> String {
        switch category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .hair:
            return "scissors"
        case .body:
            return "figure.walk"
        case .fragrance:
            return "aqi.medium"
        }
    }
}

struct CategoryCard: View {
    let category: Category
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                Image(systemName: categoryIcon(for: category))
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(AppColors.yellow)
                
                VStack(spacing: 4) {
                    Text(category.displayName)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("\(count) test\(count == 1 ? "" : "s")")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func categoryIcon(for category: Category) -> String {
        switch category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .hair:
            return "scissors"
        case .body:
            return "figure.walk"
        case .fragrance:
            return "aqi.medium"
        }
    }
}

#Preview {
    CategoriesView()
}
