import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: ManicureViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.favoriteManicures.isEmpty {
                    EmptyStateView(
                        title: "No favorites yet",
                        subtitle: "Add manicures to favorites to see them here",
                        systemImage: "heart"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favoriteManicures) { manicure in
                                NavigationLink(destination: ManicureDetailView(manicureId: manicure.id, viewModel: viewModel)) {
                                    ManicureCard(manicureId: manicure.id, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: ManicureViewModel())
}
