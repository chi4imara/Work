import SwiftUI

struct OutfitsView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var showingAddOutfit = false
    @State private var selectedOutfitID: OutfitID?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                seasonFiltersView
                
                if viewModel.filteredOutfits.isEmpty {
                    emptyStateView
                } else {
                    outfitsList
                }
            }
        }
        .sheet(isPresented: $showingAddOutfit) {
            AddOutfitView(viewModel: viewModel)
        }
        .sheet(item: $selectedOutfitID) { outfitID in
            if let outfit = viewModel.getOutfit(by: outfitID.id) {
                OutfitDetailView(outfitID: outfitID.id, viewModel: viewModel)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Outfits")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddOutfit = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color.theme.primaryYellow)
                    .background(
                        Circle()
                            .fill(Color.theme.primaryWhite)
                            .frame(width: 32, height: 32)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var seasonFiltersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterButton(
                    title: "All",
                    isSelected: viewModel.selectedSeason == nil,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedSeason = nil
                        }
                    }
                )
                
                ForEach(Season.allCases, id: \.self) { season in
                    FilterButton(
                        title: season.rawValue,
                        isSelected: viewModel.selectedSeason == season,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.selectedSeason = season
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    private var outfitsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredOutfits) { outfit in
                    OutfitCard(outfit: outfit) {
                        selectedOutfitID = OutfitID(id: outfit.id)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tshirt")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.primaryYellow.opacity(0.7))
            
            Text("No outfits yet")
                .font(.ubuntu(24, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Add your first outfit to start your style gallery!")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                showingAddOutfit = true
            } label: {
                Text("Add Outfit")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.buttonText)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.theme.buttonBackground)
                            .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                    )
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: isSelected ? .medium : .regular))
                .foregroundColor(isSelected ? Color.theme.darkText : Color.theme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.theme.primaryYellow : Color.theme.secondaryButtonBackground)
                        .shadow(color: Color.theme.lightShadowColor, radius: isSelected ? 4 : 0, x: 0, y: 2)
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct OutfitCard: View {
    let outfit: OutfitModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(outfit.shortDateString)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.accentText)
                    
                    Spacer()
                    
                    Image(systemName: outfit.season.icon)
                        .font(.system(size: 16))
                        .foregroundColor(outfit.season.color)
                }
                
                Text(outfit.description)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.darkText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                HStack {
                    Label(outfit.location, systemImage: "location")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(Color.theme.darkText.opacity(0.7))
                    
                    Spacer()
                    
                    Text(outfit.weather)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(Color.theme.darkText.opacity(0.7))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    OutfitsView(viewModel: OutfitViewModel())
}
