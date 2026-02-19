import SwiftUI

struct CategoriesView: View {
    @ObservedObject var bagStore: BagStore
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(.bellGothic(32, weight: .bold))
                        .foregroundColor(.appDarkBlue)
                    
                    Spacer()
                    
                    if bagStore.selectedSize != nil || bagStore.selectedStyle != nil || !bagStore.searchText.isEmpty {
                        Button(action: {
                            resetFiltersAndNavigate()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Reset")
                                    .font(.bellGothic(14, weight: .bold))
                            }
                            .foregroundColor(.appDarkBlue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.appAccentYellow)
                            .cornerRadius(20)
                            .shadow(color: Color.appAccentYellow.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if bagStore.sizeCategories.isEmpty && bagStore.styleCategories.isEmpty {
                    EmptyCategoriesView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            if !bagStore.sizeCategories.isEmpty {
                                CategorySection(
                                    title: "Sizes",
                                    categories: bagStore.sizeCategories,
                                    bagStore: bagStore,
                                    selectedTab: $selectedTab
                                )
                            }
                            
                            if !bagStore.styleCategories.isEmpty {
                                CategorySection(
                                    title: "Styles",
                                    categories: bagStore.styleCategories,
                                    bagStore: bagStore,
                                    selectedTab: $selectedTab
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
    }
    
    private func resetFiltersAndNavigate() {
        bagStore.clearFilters()
        withAnimation {
            selectedTab = .bags
        }
    }
}

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.appPrimaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("Categories not formed yet")
                    .font(.bellGothic(24, weight: .bold))
                    .foregroundColor(.appDarkBlue)
                    .multilineTextAlignment(.center)
                
                Text("Add some bags to see categories")
                    .font(.bellGothic(16))
                    .foregroundColor(.appTextDark)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategorySection: View {
    let title: String
    let categories: [Category]
    @ObservedObject var bagStore: BagStore
    @Binding var selectedTab: TabItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.bellGothic(24, weight: .bold))
                .foregroundColor(.appDarkBlue)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(categories) { category in
                    CategoryCard(category: category, bagStore: bagStore, selectedTab: $selectedTab)
                }
            }
        }
    }
}

struct CategoryCard: View {
    let category: Category
    @ObservedObject var bagStore: BagStore
    @Binding var selectedTab: TabItem
    
    var body: some View {
        Button(action: {
            applyFilterAndNavigate()
        }) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.name)
                            .font(.bellGothic(16, weight: .bold))
                            .foregroundColor(.appDarkBlue)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(category.count) bag\(category.count == 1 ? "" : "s")")
                            .font(.bellGothic(14))
                            .foregroundColor(.appTextDark)
                    }
                    
                    Spacer()
                    
                    Image(systemName: iconName)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.appPrimaryBlue)
                }
                .padding(16)
            }
            .frame(minHeight: 80)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var iconName: String {
        switch category.type {
        case .size:
            return "ruler"
        case .style:
            return "paintbrush"
        }
    }
    
    private func applyFilterAndNavigate() {
        bagStore.clearFilters()
        
        switch category.type {
        case .size(let size):
            bagStore.filterBySize(size)
        case .style(let style):
            bagStore.filterByStyle(style)
        }
        
        withAnimation {
            selectedTab = .bags
        }
    }
}
