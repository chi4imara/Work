import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @State private var tempFilterOptions = FilterOptions()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        brandFilterSection
                        
                        typeFilterSection
                        
                        statusFilterSection
                        
                        ratingFilterSection
                        
                        actionButtonsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            tempFilterOptions = viewModel.filterOptions
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Filters")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            if viewModel.filterOptions.isActive {
                Button(action: clearAllFilters) {
                    Text("Clear All")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.statusRed)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.cardBackground)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.statusRed.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var brandFilterSection: some View {
        FilterSection(title: "Brands", icon: "building.2") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(viewModel.availableBrands, id: \.self) { brand in
                    FilterChip(
                        title: brand,
                        isSelected: tempFilterOptions.selectedBrands.contains(brand)
                    ) {
                        toggleBrandSelection(brand)
                    }
                }
            }
        }
    }
    
    private var typeFilterSection: some View {
        FilterSection(title: "Product Types", icon: "tag") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(ProductType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.rawValue,
                        icon: type.icon,
                        isSelected: tempFilterOptions.selectedTypes.contains(type)
                    ) {
                        toggleTypeSelection(type)
                    }
                }
            }
        }
    }
    
    private var statusFilterSection: some View {
        FilterSection(title: "Expiration Status", icon: "calendar.badge.exclamationmark") {
            VStack(spacing: 12) {
                ForEach(ExpirationStatus.allCases, id: \.self) { status in
                    FilterChip(
                        title: status.rawValue,
                        icon: statusIcon(for: status),
                        isSelected: tempFilterOptions.selectedStatuses.contains(status),
                        color: statusColor(for: status)
                    ) {
                        toggleStatusSelection(status)
                    }
                }
            }
        }
    }
    
    private var ratingFilterSection: some View {
        FilterSection(title: "Rating", icon: "star") {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Minimum Rating")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: { tempFilterOptions.minRating = star }) {
                                Image(systemName: star <= tempFilterOptions.minRating ? "star.fill" : "star")
                                    .font(.system(size: 24))
                                    .foregroundColor(star <= tempFilterOptions.minRating ? AppColors.primaryYellow : AppColors.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(tempFilterOptions.minRating)+ stars")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Maximum Rating")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: { tempFilterOptions.maxRating = star }) {
                                Image(systemName: star <= tempFilterOptions.maxRating ? "star.fill" : "star")
                                    .font(.system(size: 24))
                                    .foregroundColor(star <= tempFilterOptions.maxRating ? AppColors.primaryYellow : AppColors.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text("Up to \(tempFilterOptions.maxRating) stars")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: applyFilters) {
                HStack {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .medium))
                    Text("Apply Filters")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.backgroundGradientStart)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.primaryYellow)
                .cornerRadius(12)
            }
            
            Button(action: resetFilters) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                    Text("Reset Filters")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
            }
        }
        .padding(.top, 20)
    }
        
    private func toggleBrandSelection(_ brand: String) {
        if tempFilterOptions.selectedBrands.contains(brand) {
            tempFilterOptions.selectedBrands.remove(brand)
        } else {
            tempFilterOptions.selectedBrands.insert(brand)
        }
    }
    
    private func toggleTypeSelection(_ type: ProductType) {
        if tempFilterOptions.selectedTypes.contains(type) {
            tempFilterOptions.selectedTypes.remove(type)
        } else {
            tempFilterOptions.selectedTypes.insert(type)
        }
    }
    
    private func toggleStatusSelection(_ status: ExpirationStatus) {
        if tempFilterOptions.selectedStatuses.contains(status) {
            tempFilterOptions.selectedStatuses.remove(status)
        } else {
            tempFilterOptions.selectedStatuses.insert(status)
        }
    }
    
    private func statusIcon(for status: ExpirationStatus) -> String {
        switch status {
        case .active:
            return "checkmark.circle"
        case .expiringSoon:
            return "exclamationmark.triangle"
        case .expired:
            return "xmark.circle"
        }
    }
    
    private func statusColor(for status: ExpirationStatus) -> Color {
        switch status {
        case .active:
            return AppColors.statusGreen
        case .expiringSoon:
            return AppColors.statusYellow
        case .expired:
            return AppColors.statusRed
        }
    }
    
    private func applyFilters() {
        viewModel.filterOptions = tempFilterOptions
    }
    
    private func resetFilters() {
        tempFilterOptions.reset()
        viewModel.filterOptions.reset()
    }
    
    private func clearAllFilters() {
        tempFilterOptions.reset()
        viewModel.filterOptions.reset()
    }
}

struct FilterSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text(title)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct FilterChip: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let color: Color?
    let action: () -> Void
    
    init(title: String, icon: String? = nil, isSelected: Bool, color: Color? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(chipForegroundColor)
                }
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(chipForegroundColor)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(chipBackgroundColor)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(chipBorderColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var chipBackgroundColor: Color {
        if isSelected {
            return color ?? AppColors.primaryYellow
        } else {
            return AppColors.cardBackground
        }
    }
    
    private var chipForegroundColor: Color {
        if isSelected {
            return AppColors.backgroundGradientStart
        } else {
            return AppColors.textPrimary
        }
    }
    
    private var chipBorderColor: Color {
        if isSelected {
            return color ?? AppColors.primaryYellow
        } else {
            return AppColors.cardBorder
        }
    }
}

#Preview {
    FiltersView(viewModel: CosmeticViewModel())
}
