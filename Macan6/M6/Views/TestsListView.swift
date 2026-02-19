import SwiftUI

struct TestsListView: View {
    @StateObject private var viewModel = TestsViewModel()
    @State private var showingAddTest = false
    @State private var showingSortMenu = false
    @State private var selectedTest: TestModel?
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if viewModel.filteredTests.isEmpty {
                    emptyStateView
                } else {
                    testsListView
                }
            }
        }
        .sheet(isPresented: $showingAddTest) {
            AddTestView(viewModel: viewModel)
        }
        .sheet(item: $selectedTest) { test in
            TestDetailView(testId: test.id, viewModel: viewModel)
        }
        .actionSheet(isPresented: $showingSortMenu) {
            sortActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Tests")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddTest = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.yellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search by name or brand", text: $viewModel.searchText)
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.primaryText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            
            HStack(spacing: 12) {
                Button(action: { showingSortMenu = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort")
                            .font(.playfairDisplay(14, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
                }
                
                if viewModel.selectedCategory != nil || viewModel.selectedSkinType != nil || viewModel.selectedStatus != nil {
                    Button(action: { viewModel.clearFilters() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark")
                            Text("Clear")
                                .font(.playfairDisplay(14, weight: .medium))
                        }
                        .foregroundColor(AppColors.yellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppColors.yellow.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                Text("\(viewModel.filteredTests.count) tests")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.yellow.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(viewModel.tests.isEmpty ? "No tests yet" : "No matching tests")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(viewModel.tests.isEmpty ? 
                     "You haven't added any tests yet. Tap + to start keeping your beauty diary." :
                     "Try adjusting your search or filters to find what you're looking for.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if viewModel.tests.isEmpty {
                Button(action: { showingAddTest = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("Add New Test")
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.accentText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.yellow)
                    .cornerRadius(20)
                }
                .padding(.top, 20)
            }
            
            Spacer()
        }
    }
    
    private var testsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredTests) { test in
                    TestCardView(test: test) {
                        selectedTest = test
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort Tests"),
            buttons: SortOption.allCases.map { option in
                .default(Text(option.displayName)) {
                    if viewModel.sortOption == option {
                        viewModel.isAscending.toggle()
                    } else {
                        viewModel.sortOption = option
                        viewModel.isAscending = false
                    }
                }
            } + [.cancel()]
        )
    }
}

struct TestCardView: View {
    let test: TestModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(test.productName)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        Text(test.brand)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: test.status.icon)
                        .font(.system(size: 20))
                        .foregroundColor(statusColor(for: test.status))
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(test.category.displayName)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.yellow)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.yellow.opacity(0.2))
                            .cornerRadius(6)
                        
                        Text(test.skinType.displayName)
                            .font(.playfairDisplay(12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= test.rating ? "star.fill" : "star")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.yellow)
                            }
                        }
                        
                        Text(DateFormatter.shortDate.string(from: test.testDate))
                            .font(.playfairDisplay(12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(16)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func statusColor(for status: TestStatus) -> Color {
        switch status {
        case .recommend:
            return AppColors.success
        case .notSuitable:
            return AppColors.error
        case .testing:
            return AppColors.warning
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    TestsListView()
}
