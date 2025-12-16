import SwiftUI

struct HomeView: View {
    @ObservedObject var candleStore: CandleStore
    @State private var showingAddCandle = false
    @State private var showingCandleDetail: Candle?
    @State private var editingCandle: Candle?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBar
                    
                    filterSection
                    
                    if candleStore.filteredCandles.isEmpty {
                        emptyStateView
                    } else {
                        candlesList
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCandle) {
            AddEditCandleView(candleStore: candleStore)
        }
        .sheet(item: $showingCandleDetail) { candle in
            CandleDetailView(candle: candle, candleStore: candleStore)
        }
        .sheet(item: $editingCandle) { candle in
            AddEditCandleView(candleStore: candleStore, editingCandle: candle)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Scents")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(candleStore.candles.count) candles in collection")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                showingAddCandle = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.primaryYellow)
                    .background(
                        Circle()
                            .fill(AppColors.primaryWhite)
                            .frame(width: 32, height: 32)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textLight)
            
            TextField("Search by name or brand...", text: $candleStore.searchText)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(CandleStore.FilterType.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.rawValue,
                        isSelected: candleStore.selectedFilter == filter
                    ) {
                        candleStore.selectedFilter = filter
                        if filter != .mood {
                            candleStore.selectedMoodFilter = nil
                        }
                        if filter != .season {
                            candleStore.selectedSeasonFilter = nil
                        }
                    }
                }
                
                if candleStore.selectedFilter == .mood {
                    ForEach(Mood.allCases) { mood in
                        FilterButton(
                            title: mood.rawValue,
                            isSelected: candleStore.selectedMoodFilter == mood,
                            isSecondary: true
                        ) {
                            candleStore.selectedMoodFilter = candleStore.selectedMoodFilter == mood ? nil : mood
                        }
                    }
                }
                
                if candleStore.selectedFilter == .season {
                    ForEach(Season.allCases) { season in
                        FilterButton(
                            title: season.rawValue,
                            isSelected: candleStore.selectedSeasonFilter == season,
                            isSecondary: true
                        ) {
                            candleStore.selectedSeasonFilter = candleStore.selectedSeasonFilter == season ? nil : season
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
        .padding(.top, 16)
    }
    
    private var candlesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(candleStore.filteredCandles) { candle in
                    CandleCard(candle: candle) {
                        showingCandleDetail = candle
                    } onEdit: {
                        editingCandle = candle
                    } onDelete: {
                        candleStore.deleteCandle(candle)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100) 
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "flame")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textLight)
            
            VStack(spacing: 12) {
                Text("No scents added yet")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add your first candle that creates the atmosphere at home.")
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                showingAddCandle = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Candle")
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.buttonPrimary)
                        .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                )
            }
            
            Spacer()
        }
        .padding(.bottom, 100)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let isSecondary: Bool
    let action: () -> Void
    
    init(title: String, isSelected: Bool, isSecondary: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.isSecondary = isSecondary
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(isSelected ? AppColors.buttonText : AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? (isSecondary ? AppColors.primaryBlue : AppColors.primaryPurple) : AppColors.cardBackground)
                        .shadow(color: AppColors.shadowColor, radius: isSelected ? 4 : 2, x: 0, y: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CandleCard: View {
    let candle: Candle
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingActions = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(AppColors.primaryBlue)
                            .clipShape(Circle())
                    }
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(AppColors.accentPink)
                            .clipShape(Circle())
                    }
                }
                .padding(.trailing, 20)
                .opacity(showingActions ? 1 : 0)
            }
            
            Button(action: onTap) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(candle.name)
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            if candle.isFavorite {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.accentPink)
                            }
                        }
                        
                        Text(candle.brand)
                            .font(.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(1)
                        
                        HStack {
                            Text(candle.mood.rawValue)
                                .font(.playfairDisplay(size: 12, weight: .medium))
                                .foregroundColor(AppColors.primaryPurple)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(AppColors.primaryPurple.opacity(0.1))
                                )
                            
                            Text(candle.season.rawValue)
                                .font(.playfairDisplay(size: 12, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(AppColors.primaryBlue.opacity(0.1))
                                )
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .offset(x: offset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 25)
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = value.translation
                            showingActions = offset.width < -50
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width < -100 {
                                offset = CGSize(width: -100, height: 0)
                                showingActions = true
                            } else {
                                offset = .zero
                                showingActions = false
                            }
                        }
                    }
            )
        }
    }
}

#Preview {
    HomeView(candleStore: CandleStore())
}
