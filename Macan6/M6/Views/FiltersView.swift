import SwiftUI

struct FiltersView: View {
    @StateObject private var viewModel = TestsViewModel()
    @State private var selectedTestId: UUID?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                filterControlsView
                
                if viewModel.filteredTests.isEmpty && hasActiveFilters {
                    emptyResultsView
                } else {
                    resultsView
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
            Text("Filters")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if hasActiveFilters {
                Button("Clear All") {
                    viewModel.clearFilters()
                }
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(AppColors.yellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var filterControlsView: some View {
        VStack(spacing: 20) {
            FilterSection(title: "Skin/Hair Type") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SkinType.allCases, id: \.self) { skinType in
                            FilterChip(
                                title: skinType.displayName,
                                isSelected: viewModel.selectedSkinType == skinType
                            ) {
                                viewModel.selectedSkinType = viewModel.selectedSkinType == skinType ? nil : skinType
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            FilterSection(title: "Category") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Category.allCases, id: \.self) { category in
                            FilterChip(
                                title: category.displayName,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            FilterSection(title: "Status") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(TestStatus.allCases, id: \.self) { status in
                            FilterChip(
                                title: status.displayName,
                                isSelected: viewModel.selectedStatus == status,
                                icon: status.icon
                            ) {
                                viewModel.selectedStatus = viewModel.selectedStatus == status ? nil : status
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.horizontal, -20)
            }
        }
        .padding(.bottom, 20)
    }
    
    private var resultsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Results")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(viewModel.filteredTests.count) test\(viewModel.filteredTests.count == 1 ? "" : "s")")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredTests) { test in
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
    
    private var emptyResultsView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.yellow.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No matching tests")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Try adjusting your filters to find what you're looking for.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button {
                viewModel.clearFilters()
            } label: {
                Text("Clear Filters")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.accentText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.yellow)
                    .cornerRadius(20)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
    }
    
    private var hasActiveFilters: Bool {
        viewModel.selectedCategory != nil ||
        viewModel.selectedSkinType != nil ||
        viewModel.selectedStatus != nil
    }
}

struct FilterSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            content
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let icon: String?
    let onTap: () -> Void
    
    init(title: String, isSelected: Bool, icon: String? = nil, onTap: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.icon = icon
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                
                Text(title)
                    .font(.playfairDisplay(14, weight: .medium))
            }
            .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AppColors.yellow : AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? AppColors.yellow : AppColors.gridColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView()
}
