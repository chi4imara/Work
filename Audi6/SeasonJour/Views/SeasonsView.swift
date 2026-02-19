import SwiftUI

struct SeasonsView: View {
    @ObservedObject var viewModel: SeasonItemViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Seasons")
                    .font(FontManager.bauhausBold(28))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                if viewModel.totalItemsCount == 0 {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                        
                        Text("Seasons will appear after adding items")
                            .font(FontManager.bauhausMedium(18))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Season.allCases) { season in
                                NavigationLink(destination: SeasonItemsView(season: season, viewModel: viewModel)) {
                                    SeasonCardView(season: season, itemCount: viewModel.itemsCountForSeason(season))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct SeasonCardView: View {
    let season: Season
    let itemCount: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: season.icon)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(season.displayName)
                    .font(FontManager.bauhausMedium(20))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(itemCount) item\(itemCount == 1 ? "" : "s")")
                    .font(FontManager.bauhausLight(16))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding()
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
