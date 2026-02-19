import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: ScentViewModel
    @Binding var selectedTab: TabItem
    @Environment(\.dismiss) private var dismiss
    
    @State private var brandFilter: String
    @State private var selectedSeasons: Set<Season>
    
    init(viewModel: ScentViewModel, selectedTab: Binding<TabItem>) {
        self.viewModel = viewModel
        _brandFilter = State(initialValue: viewModel.filter.brand)
        _selectedSeasons = State(initialValue: viewModel.filter.seasons)
        self._selectedTab = selectedTab
    }
    
    private var hasActiveFilters: Bool {
        !brandFilter.isEmpty || !selectedSeasons.isEmpty
    }
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 24) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        brandFilterSection
                        
                        seasonFilterSection
                        
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
                .opacity(0)
                .disabled(true)
                
                Spacer()
                
                Text("Filters")
                    .font(.playfairDisplay(.bold, size: 24))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                if hasActiveFilters {
                    Button(action: clearAllFilters) {
                        Text("Clear")
                            .font(.playfairDisplay(.medium, size: 16))
                            .foregroundColor(AppColors.yellow)
                    }
                } else {
                    Button(action: {}) {
                        Text("Clear")
                            .font(.playfairDisplay(.medium, size: 16))
                            .foregroundColor(.clear)
                    }
                    .disabled(true)
                }
            }
            
            Text("Filter your scent collection")
                .font(.playfairDisplay(.regular, size: 14))
                .foregroundColor(AppColors.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var brandFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Brand")
                .font(.playfairDisplay(.bold, size: 20))
                .foregroundColor(AppColors.white)
            
            TextField("e.g., Diptyque", text: $brandFilter)
                .font(.playfairDisplay(.regular, size: 16))
                .foregroundColor(AppColors.white)
                .padding(16)
                .background(AppColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private var seasonFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Seasons")
                .font(.playfairDisplay(.bold, size: 20))
                .foregroundColor(AppColors.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Season.allCases, id: \.self) { season in
                    SeasonFilterButton(
                        season: season,
                        isSelected: selectedSeasons.contains(season)
                    ) {
                        toggleSeason(season)
                    }
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: applyFilters) {
                HStack {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Apply Filters")
                        .font(.playfairDisplay(.semiBold, size: 18))
                }
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.buttonGradient)
                .cornerRadius(28)
                .shadow(color: AppColors.yellow.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            if hasActiveFilters {
                Button(action: resetFilters) {
                    Text("Reset Filters")
                        .font(.playfairDisplay(.medium, size: 16))
                        .foregroundColor(AppColors.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(AppColors.cardGradient)
                        .cornerRadius(24)
                }
            }
        }
        .padding(.bottom, 40)
    }
    
    private func toggleSeason(_ season: Season) {
        if selectedSeasons.contains(season) {
            selectedSeasons.remove(season)
        } else {
            selectedSeasons.insert(season)
        }
    }
    
    private func applyFilters() {
        var newFilter = viewModel.filter
        newFilter.brand = brandFilter.trimmingCharacters(in: .whitespacesAndNewlines)
        newFilter.seasons = selectedSeasons
        
        viewModel.setFilter(newFilter)
        dismiss()
        
        withAnimation {
            selectedTab = .collection
        }
    }
    
    private func resetFilters() {
        brandFilter = ""
        selectedSeasons.removeAll()
        
        viewModel.clearFilters()
        dismiss()
        
        withAnimation {
            selectedTab = .collection
        }
    }
    
    private func clearAllFilters() {
        brandFilter = ""
        selectedSeasons.removeAll()
    }
}

struct SeasonFilterButton: View {
    let season: Season
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AnyShapeStyle(AppColors.yellowGradient) : AnyShapeStyle(AppColors.white.opacity(0.1)))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: season.icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.white : AppColors.white.opacity(0.7))
                }
                
                Text(season.displayName)
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(isSelected ? AppColors.white : AppColors.white.opacity(0.7))
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppColors.yellow)
                }
            }
            .padding(16)
            .background(
                isSelected ? 
                AnyShapeStyle(AppColors.cardGradient) :
                    AnyShapeStyle(AppColors.cardGradient.opacity(0.5))
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? 
                        AppColors.yellow.opacity(0.5) : 
                        AppColors.white.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
