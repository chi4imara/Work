import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: SeasonItemViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Statistics")
                    .font(FontManager.bauhausBold(28))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                if viewModel.totalItemsCount == 0 {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                        
                        Text("No statistics available yet")
                            .font(FontManager.bauhausMedium(18))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Text("Add items to see your wardrobe statistics")
                            .font(FontManager.bauhausLight(16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            StatisticCardView(
                                title: "Total Items",
                                value: "\(viewModel.totalItemsCount)",
                                icon: "tshirt",
                                color: AppColors.primaryBlue
                            )
                            
                            StatisticCardView(
                                title: "Favorites",
                                value: "\(viewModel.favoriteItems.count)",
                                icon: "heart.fill",
                                color: AppColors.accentPink
                            )
                            
                            VStack(spacing: 16) {
                                Text("Items by Season")
                                    .font(FontManager.bauhausMedium(20))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ForEach(Season.allCases) { season in
                                    SeasonStatisticRow(
                                        season: season,
                                        count: viewModel.itemsCountForSeason(season),
                                        total: viewModel.totalItemsCount
                                    )
                                }
                            }
                            .padding()
                            .background(AppColors.cardGradient)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct StatisticCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.bauhausLight(16))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(FontManager.bauhausBold(32))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
        .padding()
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct SeasonStatisticRow: View {
    let season: Season
    let count: Int
    let total: Int
    
    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: season.icon)
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 24)
                
                Text(season.displayName)
                    .font(FontManager.bauhausMedium(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(FontManager.bauhausBold(18))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.lightGray)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text("\(Int(percentage))%")
                .font(FontManager.bauhausLight(12))
                .foregroundColor(AppColors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
}
