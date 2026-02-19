import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var tempFilterOptions = FilterOptions()
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Filters")
                        .font(FontManager.bold(size: 28))
                        .foregroundColor(ColorManager.primaryBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSection(title: "Status") {
                            VStack(spacing: 12) {
                                ForEach(ProductStatus.allCases, id: \.self) { status in
                                    StatusFilterRow(
                                        status: status,
                                        isSelected: tempFilterOptions.selectedStatuses.contains(status)
                                    ) {
                                        if tempFilterOptions.selectedStatuses.contains(status) {
                                            tempFilterOptions.selectedStatuses.remove(status)
                                        } else {
                                            tempFilterOptions.selectedStatuses.insert(status)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Categories") {
                            VStack(spacing: 12) {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    CategoryFilterRow(
                                        category: category,
                                        isSelected: tempFilterOptions.selectedCategories.contains(category)
                                    ) {
                                        if tempFilterOptions.selectedCategories.contains(category) {
                                            tempFilterOptions.selectedCategories.remove(category)
                                        } else {
                                            tempFilterOptions.selectedCategories.insert(category)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Brand") {
                            TextField("Enter brand name", text: $tempFilterOptions.brandFilter)
                                .font(FontManager.regular(size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: applyFilters) {
                                Text("Apply Filters")
                                    .font(FontManager.medium(size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        LinearGradient(
                                            colors: [ColorManager.primaryBlue, ColorManager.accentPurple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                            }
                            
                            Button(action: resetFilters) {
                                Text("Reset Filters")
                                    .font(FontManager.medium(size: 16))
                                    .foregroundColor(ColorManager.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(22)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(ColorManager.primaryBlue, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 10)
                }
            }
        }
        .onAppear {
            tempFilterOptions = productStore.filterOptions
        }
    }
    
    private func applyFilters() {
        productStore.filterOptions = tempFilterOptions
        
        withAnimation {
            selectedTab = 0
        }
    }
    
    private func resetFilters() {
        tempFilterOptions.reset()
        productStore.filterOptions.reset()
        
        withAnimation {
            selectedTab = 0
        }
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
                .font(FontManager.bold(size: 20))
                .foregroundColor(ColorManager.primaryBlue)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.white.opacity(0.6))
        .cornerRadius(16)
    }
}

struct StatusFilterRow: View {
    let status: ProductStatus
    let isSelected: Bool
    let onTap: () -> Void
    
    var statusColor: Color {
        switch status {
        case .inUse:
            return ColorManager.statusInUse
        case .inStock:
            return ColorManager.statusInStock
        case .needToBuy:
            return ColorManager.statusNeedToBuy
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                Text(status.displayName)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? ColorManager.primaryYellow : ColorManager.darkGray.opacity(0.4))
                    .font(.title3)
            }
            .padding(.vertical, 8)
        }
    }
}

struct CategoryFilterRow: View {
    let category: ProductCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var categoryIcon: String {
        switch category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .haircare:
            return "scissors"
        case .bodycare:
            return "figure.walk"
        case .fragrance:
            return "aqi.medium"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: categoryIcon)
                    .foregroundColor(ColorManager.primaryBlue)
                    .font(.title3)
                    .frame(width: 20)
                
                Text(category.displayName)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? ColorManager.primaryYellow : ColorManager.darkGray.opacity(0.4))
                    .font(.title3)
            }
            .padding(.vertical, 8)
        }
    }
}
