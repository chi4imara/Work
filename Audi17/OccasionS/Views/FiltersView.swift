import SwiftUI

struct FiltersView: View {
    @ObservedObject var fragranceViewModel: FragranceViewModel
    @ObservedObject var appViewModel: AppViewModel
    @State private var selectedSeason: Season?
    @State private var selectedFormat: FragranceFormat?
    @State private var notesFilter = ""
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Filters")
                    .font(.lumierepolis(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSection(title: "Format") {
                            HStack(spacing: 8) {
                                ForEach(FragranceFormat.allCases, id: \.self) { format in
                                    FilterButton(
                                        title: format.displayName,
                                        isSelected: selectedFormat == format
                                    ) {
                                        selectedFormat = selectedFormat == format ? nil : format
                                    }
                                }
                                Spacer()
                            }
                        }
                        
                        FilterSection(title: "Season") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                ForEach(Season.allCases, id: \.self) { season in
                                    FilterButton(
                                        title: season.displayName,
                                        isSelected: selectedSeason == season
                                    ) {
                                        selectedSeason = selectedSeason == season ? nil : season
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Notes") {
                            CustomTextField(
                                placeholder: "Search by notes...",
                                text: $notesFilter
                            )
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: applyFilters) {
                                Text("Apply Filters")
                                    .font(.lumierepolis(16, weight: .bold))
                                    .foregroundColor(AppColors.primaryWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.buttonPrimary)
                                    .cornerRadius(25)
                            }
                            
                            Button(action: clearFilters) {
                                Text("Reset Filters")
                                    .font(.lumierepolis(16, weight: .bold))
                                    .foregroundColor(AppColors.secondaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.buttonSecondary)
                                    .cornerRadius(25)
                            }
                        }
                        
                        if hasActiveFilters {
                            ActiveFiltersView(
                                season: selectedSeason,
                                format: selectedFormat,
                                notes: notesFilter
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private var hasActiveFilters: Bool {
        selectedSeason != nil || selectedFormat != nil || !notesFilter.isEmpty
    }
    
    private func loadCurrentFilters() {
        selectedSeason = fragranceViewModel.selectedSeason
        selectedFormat = fragranceViewModel.selectedFormat
        notesFilter = fragranceViewModel.selectedNotes
    }
    
    private func applyFilters() {
        fragranceViewModel.applyFilters(
            season: selectedSeason,
            format: selectedFormat,
            notes: notesFilter
        )
        
        withAnimation {
            appViewModel.selectTab(0)
        }
    }
    
    private func clearFilters() {
        selectedSeason = nil
        selectedFormat = nil
        notesFilter = ""
        fragranceViewModel.clearFilters()
        
        withAnimation {
            appViewModel.selectTab(0)
        }
    }
}

struct FilterSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.lumierepolis(18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            content
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .cornerRadius(16)
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
                .font(.lumierepolis(14, weight: .bold))
                .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? AppColors.buttonPrimary : AppColors.buttonSecondary)
                .cornerRadius(20)
        }
    }
}

struct ActiveFiltersView: View {
    let season: Season?
    let format: FragranceFormat?
    let notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Filters")
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                if let season = season {
                    FilterTag(title: "Season: \(season.displayName)")
                }
                
                if let format = format {
                    FilterTag(title: "Format: \(format.displayName)")
                }
                
                if !notes.isEmpty {
                    FilterTag(title: "Notes: \(notes)")
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(16)
        }
    }
}

struct FilterTag: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.lumierepolis(12))
            .foregroundColor(AppColors.primaryWhite)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(AppColors.accentGreen)
            .cornerRadius(12)
    }
}

#Preview {
    FiltersView(
        fragranceViewModel: FragranceViewModel(),
        appViewModel: AppViewModel()
    )
}
