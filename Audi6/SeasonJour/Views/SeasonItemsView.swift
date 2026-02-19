import SwiftUI

struct SeasonItemsView: View {
    let season: Season
    @ObservedObject var viewModel: SeasonItemViewModel
    
    var seasonItems: [SeasonItem] {
        viewModel.itemsForSeason(season)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if seasonItems.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: season.icon)
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                        
                        Text("No items for this season yet")
                            .font(FontManager.bauhausMedium(18))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(seasonItems) { item in
                                NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: viewModel)) {
                                    ItemCardView(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle(season.displayName)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        SeasonItemsView(season: .spring, viewModel: SeasonItemViewModel())
    }
}
