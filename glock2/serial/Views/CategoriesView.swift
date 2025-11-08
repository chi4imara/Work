import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: SeriesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory: SeriesCategory?
    @State private var selectedCustomCategory: CustomCategory?
    @State private var showingCustomCategories = false
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .opacity(0)
                    .disabled(true)
                    
                    Spacer()
                    
                    Text("Categories")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Button("Custom") {
                        showingCustomCategories = true
                    }
                    .font(.bodyLarge)
                    .foregroundColor(.primaryBlue)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                
                
                if viewModel.series.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "folder.fill.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text("You don't have any series yet")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            withAnimation {
                                selectedTab = .home
                            }
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
                        LazyVStack(spacing: 16) {
                            ForEach(Array(viewModel.getAllCategories().enumerated()), id: \.offset) { index, categoryData in
                                if let customCategory = categoryData.customCategory {
                                    CustomCategoryRowView(
                                        category: customCategory,
                                        count: categoryData.count
                                    ) {
                                        selectedCustomCategory = customCategory
                                    }
                                } else {
                                    CategoryRow(
                                        category: categoryData.category,
                                        count: categoryData.count
                                    ) {
                                        selectedCategory = categoryData.category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategorySeriesView(viewModel: viewModel, category: category)
        }
        .sheet(item: $selectedCustomCategory) { customCategory in
            CustomCategorySeriesView(viewModel: viewModel, customCategory: customCategory)
        }
        .sheet(isPresented: $showingCustomCategories) {
            CustomCategoriesView(viewModel: viewModel)
        }
    }
}

struct CategoryRow: View {
    let category: SeriesCategory
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.primaryBlue.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: categoryIcon(for: category))
                        .font(.system(size: 20))
                        .foregroundColor(.primaryBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                    
                    Text("\(count) series")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func categoryIcon(for category: SeriesCategory) -> String {
        switch category {
        case .drama:
            return "theatermasks"
        case .comedy:
            return "face.smiling"
        case .sciFi:
            return "sparkles"
        case .other:
            return "tv"
        case .custom:
            return "folder"
        }
    }
}

struct CategorySeriesView: View {
    @ObservedObject var viewModel: SeriesViewModel
    let category: SeriesCategory
    
    @Environment(\.presentationMode) var presentationMode
    @State private var editingSeries: Series?
    @State private var selectedSeries: Series?
    
    private var seriesInCategory: [Series] {
        viewModel.seriesByCategory(category)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.bodyLarge)
                        .foregroundColor(.primaryBlue)
                        
                        Spacer()
                        
                        Text(category.displayName)
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Text("Back")
                            .font(.bodyLarge)
                            .foregroundColor(.clear)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if seriesInCategory.isEmpty {
                        VStack(spacing: 24) {
                            Spacer()
                            
                            Image(systemName: "tv.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.textSecondary)
                            
                            Text("No series in this category yet")
                                .font(.titleMedium)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(seriesInCategory) { series in
                                    SeriesCard(
                                        series: series,
                                        onEdit: {
                                            editingSeries = series
                                        },
                                        onDelete: {
                                            viewModel.deleteSeries(series)
                                        },
                                        onTap: {
                                            selectedSeries = series
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $editingSeries) { series in
            AddEditSeriesView(viewModel: viewModel, editingSeries: series)
        }
        .sheet(item: $selectedSeries) { series in
            SeriesDetailView(viewModel: viewModel, seriesId: series.id)
        }
    }
}

struct CustomCategoryRowView: View {
    let category: CustomCategory
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(categoryColor(for: category.color).opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 20))
                        .foregroundColor(categoryColor(for: category.color))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.name)
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                    
                    Text("\(count) series")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func categoryColor(for colorName: String) -> Color {
        switch colorName {
        case "primaryBlue":
            return .primaryBlue
        case "accentGreen":
            return .accentGreen
        case "accentOrange":
            return .accentOrange
        case "accentRed":
            return .accentRed
        default:
            return .primaryBlue
        }
    }
}

struct CustomCategorySeriesView: View {
    @ObservedObject var viewModel: SeriesViewModel
    let customCategory: CustomCategory
    
    @Environment(\.presentationMode) var presentationMode
    @State private var editingSeries: Series?
    @State private var selectedSeries: Series?
    
    private var seriesInCategory: [Series] {
        viewModel.series.filter { $0.customCategoryId == customCategory.id }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bodyLarge)
                    .foregroundColor(.primaryBlue)
                    
                    Spacer()
                    
                    Text(customCategory.name)
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Text("Back")
                        .font(.bodyLarge)
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if seriesInCategory.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "tv.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text("No series in this category yet")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(seriesInCategory) { series in
                                SeriesCard(
                                    series: series,
                                    onEdit: {
                                        editingSeries = series
                                    },
                                    onDelete: {
                                        viewModel.deleteSeries(series)
                                    },
                                    onTap: {
                                        selectedSeries = series
                                    }
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
        .sheet(item: $editingSeries) { series in
            AddEditSeriesView(viewModel: viewModel, editingSeries: series)
        }
        .sheet(item: $selectedSeries) { series in
            SeriesDetailView(viewModel: viewModel, seriesId: series.id)
        }
    }
}

extension SeriesCategory: Identifiable {
    var id: String { self.rawValue }
}
