import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @State private var selectedFragranceId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.bauhausBold(28))
                        .foregroundColor(.appPrimaryBlue)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if viewModel.favoriteFragrances.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.favoriteFragrances) { fragrance in
                                FragranceCardView(fragrance: fragrance) {
                                    selectedFragranceId = fragrance.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: Binding<UUID?>(
            get: { selectedFragranceId },
            set: { selectedFragranceId = $0 }
        )) { id in
            FragranceDetailView(fragranceId: id, viewModel: viewModel)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.appAccentPink.opacity(0.3))
            
            VStack(spacing: 15) {
                Text("No favorites yet.")
                    .font(.bauhausMedium(22))
                    .foregroundColor(.appPrimaryBlue)
                
                Text("Add fragrances to favorites by tapping the heart icon in fragrance details.")
                    .font(.bauhausLight(16))
                    .foregroundColor(.appTextGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    FavoritesView(viewModel: FragranceViewModel())
}
