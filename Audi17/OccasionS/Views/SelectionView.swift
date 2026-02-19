import SwiftUI

struct SelectionView: View {
    @ObservedObject var fragranceViewModel: FragranceViewModel
    @ObservedObject var appViewModel: AppViewModel
    @State private var selectedSeason: Season?
    @State private var selectedFormat: FragranceFormat?
    @State private var selectedFragrances: [Fragrance] = []
    @State private var selectedFragranceId: UUID?
    @State private var hasSearched = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Text("Fragrance Selection")
                        .font(.lumierepolis(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        SelectionSection(title: "Season") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(Season.allCases, id: \.self) { season in
                                        SelectionButton(
                                            title: season.displayName,
                                            isSelected: selectedSeason == season
                                        ) {
                                            selectedSeason = selectedSeason == season ? nil : season
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        SelectionSection(title: "Format") {
                            HStack(spacing: 8) {
                                ForEach(FragranceFormat.allCases, id: \.self) { format in
                                    SelectionButton(
                                        title: format.displayName,
                                        isSelected: selectedFormat == format
                                    ) {
                                        selectedFormat = selectedFormat == format ? nil : format
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Button(action: searchFragrances) {
                        Text("Show Fragrances")
                            .font(.lumierepolis(16, weight: .bold))
                            .foregroundColor(AppColors.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(canSearch ? AppColors.buttonPrimary : AppColors.buttonDisabled)
                            .cornerRadius(25)
                    }
                    .disabled(!canSearch)
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if hasSearched {
                    if selectedFragrances.isEmpty {
                        EmptySelectionView()
                    } else {
                        SelectionResultsView(
                            fragrances: selectedFragrances
                        ) { fragranceId in
                            selectedFragranceId = fragranceId
                        }
                    }
                } else {
                    SelectionPlaceholderView()
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedFragranceId },
            set: { newValue in
                selectedFragranceId = newValue
                if newValue == nil && hasSearched {
                    refreshFragrancesList()
                }
            }
        )) { id in
            FragranceDetailView(
                fragranceId: id,
                fragranceViewModel: fragranceViewModel
            )
        }
        .onAppear {
            if hasSearched {
                refreshFragrancesList()
            }
        }
    }
    
    private var canSearch: Bool {
        selectedSeason != nil && selectedFormat != nil
    }
    
    private func searchFragrances() {
        guard let season = selectedSeason, let format = selectedFormat else { return }
        
        refreshFragrancesList()
        hasSearched = true
    }
    
    private func refreshFragrancesList() {
        guard let season = selectedSeason, let format = selectedFormat else { return }
        
        selectedFragrances = fragranceViewModel.getFragrancesForSelection(
            season: season,
            format: format
        )
    }
}

struct SelectionSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            content
        }
    }
}

struct SelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.lumierepolis(14, weight: .bold))
                .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.buttonPrimary : AppColors.buttonSecondary)
                .cornerRadius(20)
        }
    }
}

struct SelectionPlaceholderView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "wand.and.stars")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("Select Parameters")
                    .font(.lumierepolis(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Choose season and format to find matching fragrances")
                    .font(.lumierepolis(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct EmptySelectionView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No Matching Fragrances")
                    .font(.lumierepolis(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("No fragrances match the selected parameters.")
                    .font(.lumierepolis(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct SelectionResultsView: View {
    let fragrances: [Fragrance]
    let onFragranceTap: (UUID) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(fragrances) { fragrance in
                    SelectionFragranceCard(fragrance: fragrance) {
                        onFragranceTap(fragrance.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct SelectionFragranceCard: View {
    let fragrance: Fragrance
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(fragrance.name)
                    .font(.lumierepolis(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if !fragrance.displayNotes.isEmpty {
                    Text(fragrance.displayNotes)
                        .font(.lumierepolis(14))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SelectionView(
        fragranceViewModel: FragranceViewModel(),
        appViewModel: AppViewModel()
    )
}
