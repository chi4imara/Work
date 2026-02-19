import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var sortBy: SortOption = .dateAdded
    @State private var filterCategory: JewelryCategory? = nil
    @State private var showSortMenu = false
    @State private var showAddJewelry = false
    
    private var sortedJewelry: [Jewelry] {
        var jewelry = appState.savedJewelry
        
        if let category = filterCategory {
            jewelry = jewelry.filter { $0.category == category }
        }
        
        switch sortBy {
        case .dateAdded:
            return jewelry
        case .price:
            return jewelry.sorted { $0.price < $1.price }
        case .brand:
            return jewelry.sorted { $0.brand < $1.brand }
        case .category:
            return jewelry.sorted { $0.category.rawValue < $1.category.rawValue }
        }
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridPatternView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                if appState.savedJewelry.isEmpty {
                    emptyStateView
                } else {
                    controlsSection
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ], spacing: 15) {
                            ForEach(sortedJewelry) { jewelry in
                                NavigationLink(destination: JewelryDetailView(jewelryId: jewelry.id).environmentObject(appState)) {
                                    CollectionJewelryCard(jewelryId: jewelry.id)
                                        .environmentObject(appState)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120) 
                    }
                }
            }
        }
        .actionSheet(isPresented: $showSortMenu) {
            ActionSheet(
                title: Text("Sort by"),
                buttons: [
                    .default(Text("Date Added")) { sortBy = .dateAdded },
                    .default(Text("Price")) { sortBy = .price },
                    .default(Text("Brand")) { sortBy = .brand },
                    .default(Text("Category")) { sortBy = .category },
                    .cancel()
                ]
            )
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Collection")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("\(appState.savedJewelry.count) saved items")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                if !appState.savedJewelry.isEmpty {
                    Button(action: { showSortMenu = true }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 16, weight: .medium))
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
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var controlsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryFilterButton(
                    title: "All",
                    isSelected: filterCategory == nil
                ) {
                    filterCategory = nil
                }
                
                ForEach(JewelryCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        title: category.rawValue,
                        isSelected: filterCategory == category
                    ) {
                        if filterCategory == category {
                            filterCategory = nil
                        } else {
                            filterCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.secondaryText)
            
            VStack(spacing: 12) {
                Text("Your collection is empty")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Start building your jewelry collection by saving pieces you love from the home screen")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            HStack(spacing: 16) {
                Button {
                    showAddJewelry = true
                } label: {
                    Text("Add Jewelry")
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(ColorTheme.whiteText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(ColorTheme.primaryYellow)
                                .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 10)
                        )
                }
                
                Button {
                    appState.selectedTab = 0
                } label: {
                    Text("Explore Home")
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(ColorTheme.whiteText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(ColorTheme.primaryBlue)
                                .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10)
                        )
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .sheet(isPresented: $showAddJewelry) {
            AddEditJewelryView(jewelryId: nil, mode: .add)
                .environmentObject(appState)
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.whiteText : ColorTheme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? ColorTheme.primaryBlue : ColorTheme.backgroundWhite)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 3)
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct CollectionJewelryCard: View {
    let jewelryId: UUID
    @EnvironmentObject var appState: AppState
    @State private var showActionSheet = false
    
    private var jewelry: Jewelry? {
        appState.getJewelry(by: jewelryId)
    }
    
    var body: some View {
        if let jewelry = jewelry {
            cardContent(jewelry: jewelry)
        }
    }
    
    private func cardContent(jewelry: Jewelry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                ColorTheme.lightGray,
                                ColorTheme.backgroundWhite
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                    .overlay(
                        VStack {
                            Image(systemName: getJewelryIcon(jewelry.category))
                                .font(.system(size: 30, weight: .light))
                                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
                            
                            Text(jewelry.name)
                                .font(.playfairDisplay(10, weight: .medium))
                                .foregroundColor(ColorTheme.secondaryText)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .padding(8)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(jewelry.name)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(2)
                
                Text(jewelry.brand)
                    .font(.playfairDisplay(10))
                    .foregroundColor(ColorTheme.secondaryText)
                
                HStack {
                    Text("$\(Int(jewelry.price))")
                        .font(.playfairDisplay(12, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Text(jewelry.category.rawValue)
                        .font(.playfairDisplay(8))
                        .foregroundColor(ColorTheme.secondaryText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ColorTheme.primaryBlue.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text(jewelry.name),
                buttons: [
                    .default(Text("Share")) {
                    },
                    .destructive(Text("Remove from Collection")) {
                        appState.removeFromCollection(id: jewelryId)
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private func getJewelryIcon(_ category: JewelryCategory) -> String {
        switch category {
        case .rings:
            return "circle.dashed"
        case .earrings:
            return "oval.portrait"
        case .bracelets:
            return "link.circle"
        case .necklaces:
            return "oval.portrait.bottomhalf.filled"
        }
    }
}

enum SortOption {
    case dateAdded, price, brand, category
}

#Preview {
    CollectionView()
        .environmentObject(AppState())
}
