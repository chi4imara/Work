import SwiftUI

struct CategoryFragrancesView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    let category: Category
    
    private var fragrances: [Fragrance] {
        viewModel.getFragrances(for: category).sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            if fragrances.isEmpty {
                EmptyStateView(message: "No fragrances in this category yet.")
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(fragrances) { fragrance in
                            NavigationLink(destination: FragranceDetailView(fragranceId: fragrance.id)
                                .environmentObject(viewModel)) {
                                FragranceCardView(fragrance: fragrance)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationView {
        CategoryFragrancesView(category: Category(
            name: "Summer",
            count: 3,
            type: .season(.summer)
        ))
        .environmentObject(FragranceViewModel())
    }
}
