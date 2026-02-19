import SwiftUI

struct FilterView: View {
    @Binding var filterOptions: FilterOptions
    @State private var localFilters: FilterOptions
    @Environment(\.dismiss) private var dismiss
    let onApply: (FilterOptions) -> Void
    
    init(filterOptions: Binding<FilterOptions>, onApply: @escaping (FilterOptions) -> Void) {
        self._filterOptions = filterOptions
        self._localFilters = State(initialValue: filterOptions.wrappedValue)
        self.onApply = onApply
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        distanceFilterView
                        
                        priceRangeFilterView
                        
                        ratingFilterView
                        
                        serviceCategoriesFilterView
                        
                        discountFilterView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        localFilters = FilterOptions()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        filterOptions = localFilters
                        onApply(localFilters)
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                    .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private var distanceFilterView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Distance")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Within \(Int(localFilters.maxDistance)) km")
                        .font(.playfairRegular(size: 16))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                }
                
                Slider(value: $localFilters.maxDistance, in: 1...50, step: 1)
                    .accentColor(ColorTheme.primaryPurple)
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var priceRangeFilterView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price Range")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 8) {
                ForEach(PriceRange.allCases, id: \.self) { range in
                    Button(action: {
                        if localFilters.priceRange == range {
                            localFilters.priceRange = nil
                        } else {
                            localFilters.priceRange = range
                        }
                    }) {
                        HStack {
                            Image(systemName: localFilters.priceRange == range ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(ColorTheme.primaryPurple)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(range.rawValue)
                                    .font(.playfairSemiBold(size: 16))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Text(range.description)
                                    .font(.playfairRegular(size: 14))
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                            
                            Spacer()
                        }
                        .padding(12)
                        .background(localFilters.priceRange == range ? ColorTheme.primaryPurple.opacity(0.1) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var ratingFilterView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Minimum Rating")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(localFilters.minRating) ? "star.fill" : "star")
                                .font(.title3)
                                .foregroundColor(ColorTheme.accentOrange)
                        }
                    }
                    
                    Text("\(localFilters.minRating, specifier: "%.1f") and above")
                        .font(.playfairRegular(size: 16))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                }
                
                Slider(value: $localFilters.minRating, in: 0...5, step: 0.5)
                    .accentColor(ColorTheme.primaryPurple)
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var serviceCategoriesFilterView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Service Types")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(ServiceCategory.allCases, id: \.self) { category in
                    Button(action: {
                        if localFilters.serviceCategories.contains(category) {
                            localFilters.serviceCategories.remove(category)
                        } else {
                            localFilters.serviceCategories.insert(category)
                        }
                    }) {
                        HStack {
                            Image(systemName: category.icon)
                                .foregroundColor(ColorTheme.primaryPurple)
                            
                            Text(category.rawValue)
                                .font(.playfairRegular(size: 14))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                            
                            if localFilters.serviceCategories.contains(category) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(ColorTheme.primaryPurple)
                            }
                        }
                        .padding(12)
                        .background(
                            localFilters.serviceCategories.contains(category) ? 
                            ColorTheme.primaryPurple.opacity(0.1) : ColorTheme.cardBackground
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    localFilters.serviceCategories.contains(category) ? 
                                    ColorTheme.primaryPurple : ColorTheme.cardBorder,
                                    lineWidth: 1
                                )
                        )
                    }
                }
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var discountFilterView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Special Offers")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            Button(action: {
                localFilters.showDiscountsOnly.toggle()
            }) {
                HStack {
                    Image(systemName: localFilters.showDiscountsOnly ? "checkmark.square.fill" : "square")
                        .foregroundColor(ColorTheme.primaryPurple)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Show discounts only")
                            .font(.playfairSemiBold(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text("Only show salons with current promotions")
                            .font(.playfairRegular(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(ColorTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

#Preview {
    FilterView(filterOptions: .constant(FilterOptions())) { _ in }
}
