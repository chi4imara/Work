import SwiftUI

struct MyFragrancesView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @State private var showingAddFragrance = false
    @State private var selectedFragranceId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if viewModel.filteredFragrances.isEmpty {
                    emptyStateView
                } else {
                    fragrancesList
                }
            }
        }
        .sheet(isPresented: $showingAddFragrance) {
            AddFragranceView(viewModel: viewModel)
        }
        .sheet(item: Binding<UUID?>(
            get: { selectedFragranceId },
            set: { selectedFragranceId = $0 }
        )) { id in
            FragranceDetailView(fragranceId: id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Fragrances")
                .font(.bauhausBold(28))
                .foregroundColor(.appPrimaryBlue)
            
            Spacer()
            
            Button(action: {
                HapticFeedback.light()
                showingAddFragrance = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.appPrimaryYellow)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 32, height: 32)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.appTextGray)
            
            TextField("Search fragrances...", text: $viewModel.searchText)
                .font(.bauhausLight(16))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.appPrimaryBlue.opacity(0.3))
            
            VStack(spacing: 15) {
                Text("No fragrances yet.")
                    .font(.bauhausMedium(22))
                    .foregroundColor(.appPrimaryBlue)
                
                Text("Add your first fragrance to get started.")
                    .font(.bauhausLight(16))
                    .foregroundColor(.appTextGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddFragrance = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Fragrance")
                        .font(.bauhausMedium(18))
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.buttonGradient)
                )
                .shadow(color: Color.appPrimaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var fragrancesList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.filteredFragrances) { fragrance in
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

struct FragranceCardView: View {
    let fragrance: Fragrance
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(fragrance.name)
                            .font(.bauhausMedium(18))
                            .foregroundColor(.appPrimaryBlue)
                            .lineLimit(2)
                        
                        if fragrance.hasNotes {
                            Text(fragrance.keyNotes)
                                .font(.bauhausLight(14))
                                .foregroundColor(.appTextGray)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    if fragrance.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.appAccentPink)
                            .font(.system(size: 16))
                    }
                }
                
                HStack {
                    if let season = fragrance.season {
                        TagView(text: season.displayName, color: .appPrimaryBlue)
                    }
                    
                    if fragrance.hasOccasions {
                        TagView(text: String(fragrance.occasions.prefix(20)), color: .appPrimaryYellow)
                    }
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.bauhausLight(12))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.1))
            )
    }
}

#Preview {
    MyFragrancesView(viewModel: FragranceViewModel())
}
