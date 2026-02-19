import SwiftUI

struct FragrancesView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    @State private var showingAddFragrance = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Fragrances")
                        .font(.bellGothicBold(size: 24))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddFragrance = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.primaryYellow)
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                SearchBarView(searchText: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                SeasonFilterView(selectedSeason: $viewModel.selectedSeason)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                
                if viewModel.filteredFragrances.isEmpty {
                    EmptyStateView(
                        message: viewModel.fragrances.isEmpty ?
                        "No fragrances yet. Add your first one." :
                            "No fragrances found."
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredFragrances) { fragrance in
                                NavigationLink(destination: FragranceDetailView(fragranceId: fragrance.id)
                                    .environmentObject(viewModel)) {
                                    FragranceCardView(fragrance: fragrance)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddFragrance) {
            AddFragranceView()
                .environmentObject(viewModel)
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search by fragrance name", text: $searchText)
                .font(.bellGothicRegular(size: 16))
                .foregroundColor(AppColors.textPrimary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.buttonSecondary)
        )
    }
}

struct SeasonFilterView: View {
    @Binding var selectedSeason: Season
    
    var body: some View {
        HStack {
            Text("Season:")
                .font(.bellGothicRegular(size: 16))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Menu {
                ForEach(Season.allCases) { season in
                    Button(action: {
                        selectedSeason = season
                    }) {
                        HStack {
                            Text(season.displayName)
                            if selectedSeason == season {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedSeason.displayName)
                        .font(.bellGothicRegular(size: 16))
                        .foregroundColor(AppColors.textPrimary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.primaryYellow)
                        .font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.buttonSecondary)
                )
            }
        }
    }
}

struct FragranceCardView: View {
    let fragrance: Fragrance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(fragrance.name)
                        .font(.bellGothicBold(size: 18))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(fragrance.brand)
                        .font(.bellGothicRegular(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                if fragrance.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(AppColors.primaryYellow)
                        .font(.title3)
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: seasonIcon(for: fragrance.season))
                        .foregroundColor(AppColors.primaryYellow)
                        .font(.caption)
                    Text(fragrance.season.displayName)
                        .font(.bellGothicRegular(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Text(fragrance.style)
                    .font(.bellGothicRegular(size: 12))
                    .foregroundColor(AppColors.textAccent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(AppColors.primaryYellow.opacity(0.2))
                    )
            }
            
            HStack {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= fragrance.rating ? "star.fill" : "star")
                            .foregroundColor(AppColors.primaryYellow)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Text(DateFormatter.shortDate.string(from: fragrance.dateAdded))
                    .font(.bellGothicRegular(size: 11))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
    }
    
    private func seasonIcon(for season: Season) -> String {
        switch season {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .autumn: return "leaf.fill"
        case .winter: return "snowflake"
        case .allSeasons: return "circle"
        }
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "drop")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
            
            Text(message)
                .font(.bellGothicRegular(size: 18))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    FragrancesView()
        .environmentObject(FragranceViewModel())
}
