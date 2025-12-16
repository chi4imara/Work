import SwiftUI

struct InspirationsView: View {
    @ObservedObject var viewModel: WomenViewModel
    @Binding var selectedTab: Int
    @State private var selectedWomanId: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text("My Inspirations")
                    .font(FontManager.ubuntu(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.theme.secondaryText)
                    
                    TextField("Search by name or description...", text: $viewModel.searchText)
                        .font(FontManager.ubuntu(16))
                        .foregroundColor(Color.theme.primaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.theme.cardBackground.opacity(0.2))
                .cornerRadius(12)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(WomenViewModel.FilterType.allCases, id: \.self) { filter in
                            FilterButton(
                                title: filter.rawValue,
                                isSelected: viewModel.selectedFilter == filter
                            ) {
                                viewModel.selectedFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            if viewModel.filteredWomen.isEmpty {
                EmptyStateView(
                    message: viewModel.women.isEmpty ? 
                        "No inspiring names yet. Add the first woman whose ideas inspire you!" :
                        "No results found for your search.",
                    buttonTitle: "Add Woman",
                    buttonAction: { selectedTab = 3 }
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredWomen) { woman in
                            WomanCard(woman: woman) {
                                selectedWomanId = woman.id
                            } onFavoriteToggle: {
                                viewModel.toggleFavorite(for: woman)
                            } onDelete: {
                                viewModel.deleteWoman(woman)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .padding(.bottom, 104)
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedWomanId.map { WomanID(id: $0) } },
            set: { selectedWomanId = $0?.id }
        )) { womanId in
            WomanDetailsView(womanId: womanId.id, viewModel: viewModel)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(FontManager.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? Color.theme.darkText : Color.theme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.theme.primaryYellow : Color.theme.cardBackground.opacity(0.2))
                )
        }
    }
}

struct EmptyStateView: View {
    let message: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.text.square")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryText.opacity(0.6))
            
            Text(message)
                .font(FontManager.ubuntu(16))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: buttonAction) {
                HStack {
                    Image(systemName: "plus")
                    Text(buttonTitle)
                }
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.theme.buttonPrimary)
                .cornerRadius(12)
            }
            
            Spacer()
        }
    }
}

#Preview {
    InspirationsView(viewModel: WomenViewModel(), selectedTab: .constant(0))
}
