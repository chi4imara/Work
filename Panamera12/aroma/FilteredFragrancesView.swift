import SwiftUI

struct FilteredFragrancesView: View {
    let filter: FragranceFilter
    @ObservedObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFragranceId: UUID?
    
    private var filteredFragrances: [Fragrance] {
        switch filter {
        case .season(let season):
            return viewModel.fragrances.filter { $0.season == season }
        case .occasion(let occasion):
            return viewModel.fragrances.filter { 
                $0.occasions.localizedCaseInsensitiveContains(occasion) 
            }
        default:
            return []
        }
    }
    
    private var navigationTitle: String {
        switch filter {
        case .season(let season):
            return season.displayName
        case .occasion(let occasion):
            return occasion.capitalized
        default:
            return "Filtered"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if filteredFragrances.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(filteredFragrances.sorted { $0.dateCreated > $1.dateCreated }) { fragrance in
                                FragranceCardView(fragrance: fragrance) {
                                    selectedFragranceId = fragrance.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 50)
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.bauhausLight(16))
                        .foregroundColor(.appPrimaryBlue)
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
            Image(systemName: "magnifyingglass")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.appPrimaryBlue.opacity(0.3))
            
            VStack(spacing: 15) {
                Text("No fragrances found")
                    .font(.bauhausMedium(22))
                    .foregroundColor(.appPrimaryBlue)
                
                Text("No fragrances match this category yet.")
                    .font(.bauhausLight(16))
                    .foregroundColor(.appTextGray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    FilteredFragrancesView(
        filter: .season(.spring),
        viewModel: FragranceViewModel()
    )
}
