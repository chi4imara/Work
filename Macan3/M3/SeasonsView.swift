import SwiftUI

struct SeasonsView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @State private var selectedSeason: Season? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if selectedSeason == nil {
                        seasonSelectionView
                    } else {
                        seasonFragrancesView
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            if selectedSeason != nil {
                Button(action: { 
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedSeason = nil
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
            }
            
            Text(selectedSeason?.displayName ?? "Seasonal Fragrances")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var seasonSelectionView: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(Season.allCases, id: \.self) { season in
                    SeasonCard(
                        season: season,
                        fragranceCount: viewModel.fragrancesForSeason(season).count
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedSeason = season
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var seasonFragrancesView: some View {
        Group {
            if let season = selectedSeason {
                let seasonFragrances = viewModel.fragrancesForSeason(season)
                
                if seasonFragrances.isEmpty {
                    emptySeasonView(for: season)
                } else {
                    fragranceListView(for: seasonFragrances)
                }
            }
        }
    }
    
    private func emptySeasonView(for season: Season) -> some View {
        VStack(spacing: 20) {
            Image(systemName: season.icon)
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No \(season.displayName.lowercased()) fragrances")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("You don't have any fragrances for \(season.displayName.lowercased()) yet.")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func fragranceListView(for fragrances: [Fragrance]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(fragrances) { fragrance in
                    NavigationLink(destination: FragranceDetailView(fragrance: fragrance, viewModel: viewModel)) {
                        SeasonFragranceCard(fragrance: fragrance)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct SeasonCard: View {
    let season: Season
    let fragranceCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: season.icon)
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.accentYellow)
                
                VStack(spacing: 4) {
                    Text(season.displayName)
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(fragranceCount) fragrance\(fragranceCount == 1 ? "" : "s")")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.borderPrimary, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SeasonFragranceCard: View {
    let fragrance: Fragrance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(fragrance.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    Text(fragrance.brand)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Text(fragrance.type.displayName)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.buttonText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.accentYellow)
                    .cornerRadius(6)
            }
            
            if !fragrance.atmosphere.isEmpty {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text(fragrance.atmosphere)
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.tertiaryText)
                        .italic()
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.borderPrimary, lineWidth: 1)
        )
    }
}

#Preview {
    SeasonsView(viewModel: FragranceViewModel())
}
