import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @State private var localFilter = FragranceFilter()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Filters")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        typeFilterSection
                        seasonFilterSection
                        brandFilterSection
                        atmosphereFilterSection
                        actionButtons
                    }
                    .padding(20)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            localFilter = viewModel.currentFilter
        }
    }
    
    private var typeFilterSection: some View {
        FilterSection(title: "Type") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(FragranceType.allCases, id: \.self) { type in
                    FilterToggleButton(
                        title: type.displayName,
                        icon: type == .daytime ? "sun.max.fill" : "moon.fill",
                        isSelected: localFilter.types.contains(type)
                    ) {
                        toggleType(type)
                    }
                }
            }
        }
    }
    
    private var seasonFilterSection: some View {
        FilterSection(title: "Season") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Season.allCases, id: \.self) { season in
                    FilterToggleButton(
                        title: season.displayName,
                        icon: season.icon,
                        isSelected: localFilter.seasons.contains(season)
                    ) {
                        toggleSeason(season)
                    }
                }
            }
        }
    }
    
    private var brandFilterSection: some View {
        FilterSection(title: "Brand") {
            let availableBrands = viewModel.getAllBrands()
            
            if availableBrands.isEmpty {
                Text("No brands available")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.tertiaryText)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(availableBrands, id: \.self) { brand in
                        FilterToggleButton(
                            title: brand,
                            icon: "tag.fill",
                            isSelected: localFilter.brands.contains(brand)
                        ) {
                            toggleBrand(brand)
                        }
                    }
                }
            }
        }
    }
    
    private var atmosphereFilterSection: some View {
        FilterSection(title: "Atmosphere") {
            let availableAtmospheres = viewModel.getAllAtmospheres()
            
            if availableAtmospheres.isEmpty {
                Text("No atmospheres available")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.tertiaryText)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(availableAtmospheres, id: \.self) { atmosphere in
                        FilterToggleButton(
                            title: atmosphere,
                            icon: "sparkles",
                            isSelected: localFilter.atmospheres.contains(atmosphere)
                        ) {
                            toggleAtmosphere(atmosphere)
                        }
                    }
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: applyFilters) {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Apply Filters")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
            
            if localFilter.isActive {
                Button(action: resetFilters) {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text("Reset Filters")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.borderPrimary, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private func toggleType(_ type: FragranceType) {
        if localFilter.types.contains(type) {
            localFilter.types.remove(type)
        } else {
            localFilter.types.insert(type)
        }
    }
    
    private func toggleSeason(_ season: Season) {
        if localFilter.seasons.contains(season) {
            localFilter.seasons.remove(season)
        } else {
            localFilter.seasons.insert(season)
        }
    }
    
    private func toggleBrand(_ brand: String) {
        if localFilter.brands.contains(brand) {
            localFilter.brands.remove(brand)
        } else {
            localFilter.brands.insert(brand)
        }
    }
    
    private func toggleAtmosphere(_ atmosphere: String) {
        if localFilter.atmospheres.contains(atmosphere) {
            localFilter.atmospheres.remove(atmosphere)
        } else {
            localFilter.atmospheres.insert(atmosphere)
        }
    }
    
    private func applyFilters() {
        viewModel.applyFilter(localFilter)
    }
    
    private func resetFilters() {
        localFilter.reset()
        viewModel.resetFilter()
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
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct FilterToggleButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .lineLimit(1)
            }
            .foregroundColor(isSelected ? AppColors.buttonText : AppColors.primaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(isSelected ? AppColors.accentYellow : AppColors.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.clear : AppColors.borderPrimary, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView(viewModel: FragranceViewModel())
}
