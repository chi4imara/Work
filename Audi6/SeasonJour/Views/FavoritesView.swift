import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: SeasonItemViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Favorites")
                    .font(FontManager.bauhausBold(28))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                if viewModel.favoriteItems.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "heart")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.accentPink.opacity(0.6))
                        
                        Text("You haven't added items to favorites yet")
                            .font(FontManager.bauhausMedium(18))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favoriteItems) { item in
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
    }
}
