import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: JewelryCategory? = nil
    @State private var selectedStyle: JewelryStyle? = nil
    @State private var priceRange: ClosedRange<Double> = 0...5000
    @State private var showFilters = false
    @State private var showAddJewelry = false
    @State private var searchText = ""
    
    private var filteredJewelry: [Jewelry] {
        var jewelry = appState.allJewelry
        
        if let category = selectedCategory {
            jewelry = jewelry.filter { $0.category == category }
        }
        
        if let style = selectedStyle {
            jewelry = jewelry.filter { $0.style == style }
        }
        
        jewelry = jewelry.filter { $0.price >= priceRange.lowerBound && $0.price <= priceRange.upperBound }
        
        if !searchText.isEmpty {
            jewelry = jewelry.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.brand.localizedCaseInsensitiveContains(searchText) ||
                $0.material.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return jewelry
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                
                searchAndFiltersSection
                
                categoriesSection
                
                if filteredJewelry.isEmpty {
                    emptyStateView
                } else {
                    jewelryGridSection
                }
                
                tipsSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
        .sheet(isPresented: $showFilters) {
            FiltersView(
                selectedCategory: $selectedCategory,
                selectedStyle: $selectedStyle,
                priceRange: $priceRange
            )
        }
        .sheet(isPresented: $showAddJewelry) {
            AddEditJewelryView(jewelryId: nil, mode: .add)
                .environmentObject(appState)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommended for You")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Find the perfect jewelry for any occasion")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: { showAddJewelry = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(ColorTheme.primaryYellow)
                                    .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 5)
                            )
                    }
                }
            }
        }
        .padding(.top, 20)
    }
    
    private var searchAndFiltersSection: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTheme.secondaryText)
                
                TextField("Search jewelry...", text: $searchText)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorTheme.primaryText)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5)
            )
            
            Button(action: { showFilters = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.whiteText)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(ColorTheme.primaryBlue)
                            .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 5)
                    )
            }
        }
    }
    
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(JewelryCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        if selectedCategory == category {
                            selectedCategory = nil
                        } else {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
    
    private var jewelryGridSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ], spacing: 15) {
            ForEach(filteredJewelry) { jewelry in
                NavigationLink(destination: JewelryDetailView(jewelryId: jewelry.id).environmentObject(appState)) {
                    JewelryCard(jewelryId: jewelry.id)
                        .environmentObject(appState)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: appState.allJewelry.isEmpty ? "plus.circle" : "sparkles")
                .font(.system(size: 50))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text(appState.allJewelry.isEmpty ? "No jewelry yet" : "No matching jewelry found")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(appState.allJewelry.isEmpty ? "Add your first jewelry manually" : "Try adjusting your filters or search terms")
                .font(.playfairDisplay(14))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            if appState.allJewelry.isEmpty {
                Button {
                    showAddJewelry = true
                } label: {
                    Text("Add Jewelry")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.whiteText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(ColorTheme.primaryYellow)
                        )
                }
                
            } else {
                Button {
                    selectedCategory = nil
                    selectedStyle = nil
                    priceRange = 0...5000
                    searchText = ""
                } label: {
                    Text("Reset Filters")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.whiteText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(ColorTheme.primaryYellow)
                        )
                }
            }
        }
        .padding(.vertical, 40)
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Style Tips")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            TipCard(tip: "Try pairing gold earrings with evening outfits for an elegant look")
            TipCard(tip: "Minimalist rings work perfectly for daily wear and professional settings")
            TipCard(tip: "Statement necklaces can transform a simple dress into a stunning outfit")
        }
    }
}

struct CategoryButton: View {
    let category: JewelryCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.whiteText : ColorTheme.primaryText)
                
                Text(category.rawValue)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.whiteText : ColorTheme.primaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? ColorTheme.primaryBlue : ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5)
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct TipCard: View {
    let tip: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.primaryYellow)
            
            Text(tip)
                .font(.playfairDisplay(14))
                .foregroundColor(ColorTheme.primaryText)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 3)
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
