import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: SeriesViewModel
    @State private var showingAddSeries = false
    @State private var showingFilterMenu = false
    @State private var showingFilterSheet = false
    @State private var editingSeries: Series?
    @State private var selectedSeries: Series?
    @State private var showingCategories = false
    @State private var selectedCategoryFilter: SeriesCategory? = nil
    @State private var selectedCustomCategoryFilter: CustomCategory? = nil
    @State private var searchText = ""
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Series")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddSeries = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primaryBlue)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    Button(action: {
                        showingFilterMenu = true
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primaryBlue)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if !viewModel.series.isEmpty {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)
                        
                        TextField("Search series...", text: $searchText)
                            .font(.bodyLarge)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.lightBlue, lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
                
                if !viewModel.series.isEmpty && (selectedCategoryFilter != nil || selectedCustomCategoryFilter != nil) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            if let categoryFilter = selectedCategoryFilter {
                                FilterChip(
                                    title: categoryFilter.displayName,
                                    onRemove: {
                                        selectedCategoryFilter = nil
                                    }
                                )
                            }
                            
                            if let customCategoryFilter = selectedCustomCategoryFilter {
                                FilterChip(
                                    title: customCategoryFilter.name,
                                    onRemove: {
                                        selectedCustomCategoryFilter = nil
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
                }
                
                if viewModel.series.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "tv.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text("You don't have any series yet")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showingAddSeries = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add First Series")
                            }
                            .font(.titleSmall)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.primaryBlue)
                            .cornerRadius(12)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            if viewModel.selectedFilter == .all || viewModel.selectedFilter == .watching {
                                seriesSection(
                                    title: "Watching Now",
                                    series: filteredWatchingSeries,
                                    isEmpty: filteredWatchingSeries.isEmpty
                                )
                            }
                            
                            if viewModel.selectedFilter == .all || viewModel.selectedFilter == .waiting {
                                seriesSection(
                                    title: "Waiting for New Seasons",
                                    series: filteredWaitingSeries,
                                    isEmpty: filteredWaitingSeries.isEmpty
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddSeries) {
            AddEditSeriesView(viewModel: viewModel, editingSeries: nil)
        }
        .sheet(item: $editingSeries) { series in
            AddEditSeriesView(viewModel: viewModel, editingSeries: series)
        }
        .sheet(item: $selectedSeries) { series in
            SeriesDetailView(viewModel: viewModel, seriesId: series.id)
        }
        .sheet(isPresented: $showingCategories) {
            CategoriesView(viewModel: viewModel, selectedTab: $selectedTab)
        }
        .actionSheet(isPresented: $showingFilterMenu) {
            ActionSheet(
                title: Text("Menu"),
                buttons: [
                    .default(Text("Filter")) {
                        showingFilterSheet = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterView(
                selectedCategoryFilter: $selectedCategoryFilter,
                selectedCustomCategoryFilter: $selectedCustomCategoryFilter,
                viewModel: viewModel
            )
        }
    }
    
    @ViewBuilder
    private func seriesSection(title: String, series: [Series], isEmpty: Bool) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(series.count)")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.lightBlue.opacity(0.3))
                    .cornerRadius(8)
            }
            
            if isEmpty {
                Text("No series in this category")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(series) { seriesItem in
                        SeriesCard(
                            series: seriesItem,
                            onEdit: {
                                editingSeries = seriesItem
                            },
                            onDelete: {
                                viewModel.deleteSeries(seriesItem)
                            },
                            onTap: {
                                selectedSeries = seriesItem
                            }
                        )
                    }
                }
            }
        }
    }
    
    private var filteredWatchingSeries: [Series] {
        var series = viewModel.watchingSeries
        
        if !searchText.isEmpty {
            series = series.filter { series in
                series.title.localizedCaseInsensitiveContains(searchText) ||
                series.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let categoryFilter = selectedCategoryFilter {
            series = series.filter { $0.category == categoryFilter && $0.customCategoryId == nil }
        }
        
        if let customCategoryFilter = selectedCustomCategoryFilter {
            series = series.filter { $0.customCategoryId == customCategoryFilter.id }
        }
        
        return series
    }
    
    private var filteredWaitingSeries: [Series] {
        var series = viewModel.waitingSeries
        
        if !searchText.isEmpty {
            series = series.filter { series in
                series.title.localizedCaseInsensitiveContains(searchText) ||
                series.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let categoryFilter = selectedCategoryFilter {
            series = series.filter { $0.category == categoryFilter && $0.customCategoryId == nil }
        }
        
        if let customCategoryFilter = selectedCustomCategoryFilter {
            series = series.filter { $0.customCategoryId == customCategoryFilter.id }
        }
        
        return series
    }
}

struct FilterChip: View {
    let title: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.bodyMedium)
                .foregroundColor(.primaryBlue)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primaryBlue)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.primaryBlue.opacity(0.1))
        .cornerRadius(16)
    }
}
