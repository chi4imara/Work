import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: FragranceViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.bauhausBold(28))
                        .foregroundColor(.appPrimaryBlue)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 25) {
                        totalStatsCard
                        
                        seasonDistributionCard
                        
                        favoritesStatsCard
                        
                        recentAdditionsCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var totalStatsCard: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.appPrimaryYellow)
                    .font(.system(size: 24))
                
                Text("Total Fragrances")
                    .font(.bauhausBold(20))
                    .foregroundColor(.appPrimaryBlue)
                
                Spacer()
            }
            
            Text("\(viewModel.fragrances.count)")
                .font(.bauhausHeavy(48))
                .foregroundColor(.appPrimaryBlue)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var seasonDistributionCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.appPrimaryYellow)
                    .font(.system(size: 24))
                
                Text("By Season")
                    .font(.bauhausBold(20))
                    .foregroundColor(.appPrimaryBlue)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(Season.allCases, id: \.self) { season in
                    HStack {
                        Text(season.displayName)
                            .font(.bauhausMedium(16))
                            .foregroundColor(.appPrimaryBlue)
                        
                        Spacer()
                        
                        Text("\(viewModel.fragrances.filter { $0.season == season }.count)")
                            .font(.bauhausDemi(18))
                            .foregroundColor(.appPrimaryYellow)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var favoritesStatsCard: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.appAccentPink)
                    .font(.system(size: 24))
                
                Text("Favorites")
                    .font(.bauhausBold(20))
                    .foregroundColor(.appPrimaryBlue)
                
                Spacer()
            }
            
            Text("\(viewModel.favoriteFragrances.count)")
                .font(.bauhausHeavy(48))
                .foregroundColor(.appAccentPink)
            
            if !viewModel.fragrances.isEmpty {
                let percentage = Double(viewModel.favoriteFragrances.count) / Double(viewModel.fragrances.count) * 100
                Text("\(Int(percentage))% of collection")
                    .font(.bauhausLight(14))
                    .foregroundColor(.appTextGray)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var recentAdditionsCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.appPrimaryYellow)
                    .font(.system(size: 24))
                
                Text("Recent Additions")
                    .font(.bauhausBold(20))
                    .foregroundColor(.appPrimaryBlue)
                
                Spacer()
            }
            
            if viewModel.fragrances.isEmpty {
                Text("No fragrances added yet")
                    .font(.bauhausLight(16))
                    .foregroundColor(.appTextGray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.fragrances.sorted { $0.dateCreated > $1.dateCreated }.prefix(5), id: \.id) { fragrance in
                        HStack {
                            Text(fragrance.name)
                                .font(.bauhausMedium(16))
                                .foregroundColor(.appPrimaryBlue)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(fragrance.dateCreated.formatted(date: .abbreviated, time: .omitted))
                                .font(.bauhausLight(12))
                                .foregroundColor(.appTextGray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    StatisticsView(viewModel: FragranceViewModel())
}
