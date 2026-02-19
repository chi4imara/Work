import SwiftUI

private struct TryOnSheetItem: Identifiable {
    let id: UUID
}

struct HomeView: View {
    @EnvironmentObject private var bagViewModel: BagViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var showingFilters = false
    @State private var tryOnItem: TryOnSheetItem?
    @State private var showingAddBag = false
    
    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    
                    searchAndFiltersSection
                    
                    if bagViewModel.filteredBags.isEmpty {
                        emptyStateView
                    } else {
                        bagsGridSection
                    }
                    
                    tipsSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(bagViewModel: bagViewModel)
        }
        .onChange(of: showingFilters) { isShowing in
            if !isShowing {
                bagViewModel.filterBags()
            }
        }
        .sheet(item: $tryOnItem) { item in
            ARTryOnView(bagId: item.id)
                .environmentObject(bagViewModel)
                .environmentObject(userViewModel)
        }
        .sheet(isPresented: $showingAddBag) {
            AddBagView()
                .environmentObject(bagViewModel)
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Recommended for You")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Choose the perfect bag for any occasion")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var searchAndFiltersSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.theme.secondaryText)
                
                TextField("Search bags...", text: $bagViewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.primaryText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !bagViewModel.searchText.isEmpty {
                    Button(action: { bagViewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
            }
            .padding(12)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
            
            HStack(spacing: 12) {
                Button(action: { showingFilters = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filters")
                            .font(.ubuntu(14, weight: .medium))
                        
                        if bagViewModel.currentFilter.isActive {
                            Circle()
                                .fill(Color.theme.accentYellow)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .foregroundColor(Color.theme.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
                }
                
                if bagViewModel.currentFilter.isActive {
                    Button(action: { bagViewModel.resetFilters() }) {
                        Text("Reset")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.theme.secondaryButton)
                            .cornerRadius(20)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "handbag")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.secondaryText)
            
            Text(bagViewModel.currentFilter.isActive ? "No suitable bags found" : "No bags yet")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text(bagViewModel.currentFilter.isActive ? "Try adjusting your filters or search terms" : "Add your first bag to get started")
                .font(.ubuntu(14))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
            
            if bagViewModel.currentFilter.isActive {
                Button(action: { bagViewModel.resetFilters() }) {
                    Text("Clear Filters")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.theme.primaryButton)
                        .cornerRadius(25)
                }
            } else {
                Button(action: { showingAddBag = true }) {
                    Text("Add First Bag")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.theme.primaryButton)
                        .cornerRadius(25)
                }
            }
        }
        .frame(height: 300)
    }
    
    private var bagsGridSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ], spacing: 12) {
            ForEach(bagViewModel.filteredBags) { bag in
                BagCardView(
                    bag: bag,
                    onFavoriteToggle: { bagViewModel.toggleFavorite(bag) },
                    onTryOn: {
                        tryOnItem = TryOnSheetItem(id: bag.id)
                    }
                )
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Style Tips")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 8) {
                TipCardView(
                    icon: "lightbulb.fill",
                    text: "Try neutral colors for office looks"
                )
                
                TipCardView(
                    icon: "star.fill",
                    text: "Small bags work great for evening events"
                )
                
                TipCardView(
                    icon: "heart.fill",
                    text: "Match your bag size to your outfit style"
                )
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 100)
    }
}

#Preview {
    HomeView()
        .environmentObject(BagViewModel())
        .environmentObject(UserViewModel())
}
