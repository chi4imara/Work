import SwiftUI

struct SeasonsView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var selectedSeason: Season = .spring
    @State private var selectedOutfitID: OutfitID?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                seasonSelectorView
                
                if outfitsForSelectedSeason.isEmpty {
                    emptyStateView
                } else {
                    seasonOutfitsList
                }
            }
        }
        .sheet(item: $selectedOutfitID) { outfitID in
            OutfitDetailView(outfitID: outfitID.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Seasons")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Text("\(outfitsForSelectedSeason.count)")
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(Color.theme.darkText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.primaryYellow)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var seasonSelectorView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Season.allCases, id: \.self) { season in
                    SeasonButton(
                        season: season,
                        isSelected: selectedSeason == season,
                        outfitCount: viewModel.outfitsForSeason(season).count,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedSeason = season
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    private var seasonOutfitsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(outfitsForSelectedSeason) { outfit in
                    SeasonOutfitCard(outfit: outfit) {
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
            
            Image(systemName: selectedSeason.icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(selectedSeason.color.opacity(0.7))
            
            Text("No \(selectedSeason.rawValue.lowercased()) outfits")
                .font(.ubuntu(24, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Add some outfits from \(selectedSeason.rawValue.lowercased()) to see them here!")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var outfitsForSelectedSeason: [OutfitModel] {
        viewModel.outfitsForSeason(selectedSeason)
    }
}

struct SeasonButton: View {
    let season: Season
    let isSelected: Bool
    let outfitCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? season.color.opacity(0.2) : Color.theme.secondaryButtonBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: season.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? season.color : Color.theme.primaryText.opacity(0.7))
                }
                
                Text(season.rawValue)
                    .font(.ubuntu(14, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? Color.theme.primaryText : Color.theme.secondaryText)
                
                Text("\(outfitCount)")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.darkText : Color.theme.secondaryText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isSelected ? Color.theme.primaryYellow.opacity(0.8) : Color.theme.secondaryButtonBackground)
                    )
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AnyShapeStyle(Color.theme.darkCardBackground) : AnyShapeStyle(Color.clear))
                    .shadow(color: Color.theme.shadowColor, radius: isSelected ? 8 : 0, x: 0, y: 4)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct SeasonOutfitCard: View {
    let outfit: OutfitModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Image(systemName: outfit.season.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(outfit.season.color)
                    
                    Text(outfit.shortDateString)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.accentText)
                }
                .frame(width: 60)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(outfit.description)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.darkText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack {
                        if !outfit.location.isEmpty {
                            Label(outfit.location, systemImage: "location")
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(Color.theme.darkText.opacity(0.7))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        if !outfit.weather.isEmpty {
                            Text(outfit.weather)
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(Color.theme.darkText.opacity(0.7))
                                .lineLimit(1)
                        }
                    }
                    
                    if !outfit.comment.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "note.text")
                                .font(.system(size: 10))
                                .foregroundColor(Color.theme.accentText)
                            
                            Text("Has comment")
                                .font(.ubuntu(10, weight: .regular))
                                .foregroundColor(Color.theme.accentText)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.darkText.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SeasonsView(viewModel: OutfitViewModel())
}
