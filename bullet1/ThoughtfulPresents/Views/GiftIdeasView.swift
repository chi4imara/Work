import SwiftUI

enum GiftSheetItem: Identifiable {
    case add
    case edit(GiftIdea)
    case detail(GiftIdea)
    case filter
    
    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let gift):
            return "edit-\(gift.id)"
        case .detail(let gift):
            return "detail-\(gift.id)"
        case .filter:
            return "filter"
        }
    }
}

struct GiftIdeasView: View {
    @ObservedObject var viewModel: GiftIdeaViewModel
    @State private var showingSortMenu = false
    @State private var sheetItem: GiftSheetItem?
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Gift Ideas")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Menu {
                            Button("Filter") {
                                sheetItem = .filter
                            }
                            Button("Sort") {
                                showingSortMenu = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color.theme.primaryBlue)
                        }
                    }
                    .padding()
                    .padding(.top)
                    
                    StatisticsSummaryView(viewModel: viewModel)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    if viewModel.filteredGiftIdeas.isEmpty {
                        EmptyStateView(
                            isFiltered: viewModel.currentFilter.isActive,
                            onAddGift: { sheetItem = .add },
                            onResetFilter: { viewModel.resetFilter() }
                        )
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredGiftIdeas) { gift in
                                GiftIdeaCardView(gift: gift)
                                    .onTapGesture {
                                        sheetItem = .detail(gift)
                                    }
                                    .contextMenu {
                                        Button("Edit") {
                                            sheetItem = .edit(gift)
                                        }
                                        Button("Delete", role: .destructive) {
                                            viewModel.deleteGiftIdea(gift)
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                        .padding(.top, 16)
                    }
                    
                    Spacer()
                }
            }
            
            if !viewModel.filteredGiftIdeas.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { sheetItem = .add }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Add Idea")
                                    .font(.theme.buttonMedium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(Color.theme.primaryBlue)
                            .cornerRadius(25)
                            .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 8)
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .add:
                AddEditGiftView(viewModel: viewModel)
            case .edit(let gift):
                AddEditGiftView(viewModel: viewModel, giftToEdit: gift)
            case .detail(let gift):
                GiftDetailView(giftId: gift.id, viewModel: viewModel)
            case .filter:
                FilterView(viewModel: viewModel)
            }
        }
        .confirmationDialog("Sort Options", isPresented: $showingSortMenu) {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(option.displayName) {
                    viewModel.applySorting(option)
                }
            }
        }
    }
}

struct StatisticsSummaryView: View {
    @ObservedObject var viewModel: GiftIdeaViewModel
    
    var body: some View {
        let stats = viewModel.getFilteredStatistics()
        
        VStack(spacing: 16) {
            HStack {
                Text("Summary")
                    .font(.theme.title3)
                    .foregroundColor(Color.theme.primaryText)
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    StatCard(title: "Total Ideas", value: "\(stats.total)", color: Color.theme.primaryBlue)
                    StatCard(title: "Bought", value: "\(stats.bought)", color: Color.theme.boughtColor)
                }
                
                HStack(spacing: 12) {
                    StatCard(title: "Gifted", value: "\(stats.gifted)", color: Color.theme.giftedColor)
                    StatCard(title: "Remaining", value: "\(stats.ideas)", color: Color.theme.ideaColor)
                }
                
                HStack {
                    Text("Total Amount:")
                        .font(.theme.headline)
                        .foregroundColor(Color.theme.primaryText)
                    Spacer()
                    Text(String(format: "$%.2f", stats.totalAmount))
                        .font(.theme.title2)
                        .foregroundColor(Color.theme.primaryBlue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.theme.cardBackground)
                .cornerRadius(12)
            }
        }
        .padding(16)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.white.opacity(0.7))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.theme.title2)
                .foregroundColor(color)
            Text(title)
                .font(.theme.caption)
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
    }
}

struct EmptyStateView: View {
    let isFiltered: Bool
    let onAddGift: () -> Void
    let onResetFilter: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "gift")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            Text(isFiltered ? "No gifts match your filters" : "Add your first gift idea")
                .font(.theme.title2)
                .foregroundColor(Color.theme.primaryText)
                .multilineTextAlignment(.center)
            
            if isFiltered {
                Button("Reset Filter") {
                    onResetFilter()
                }
                .font(.theme.buttonMedium)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.theme.primaryBlue)
                .cornerRadius(20)
            } else {
                Button {
                    onAddGift()
                } label: {
                    Text("Add Idea")
                        .font(.theme.buttonMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.theme.primaryBlue)
                        .cornerRadius(20)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}


