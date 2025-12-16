import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var selectedOutfitID: OutfitID?
    @State private var selectedSeason: Season?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                seasonFilterView
                
                if filteredNotesOutfits.isEmpty {
                    emptyStateView
                } else {
                    notesList
                }
            }
        }
        .sheet(item: $selectedOutfitID) { outfitID in
            OutfitDetailView(outfitID: outfitID.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Notes")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Text("\(filteredNotesOutfits.count)")
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(Color.theme.darkText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.primaryYellow)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var seasonFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterButton(
                    title: "All Notes",
                    isSelected: selectedSeason == nil,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedSeason = nil
                        }
                    }
                )
                
                ForEach(Season.allCases, id: \.self) { season in
                    let seasonNotesCount = viewModel.outfitsWithNotes.filter { $0.season == season }.count
                    
                    if seasonNotesCount > 0 {
                        FilterButton(
                            title: "\(season.rawValue) (\(seasonNotesCount))",
                            isSelected: selectedSeason == season,
                            action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedSeason = season
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredNotesOutfits) { outfit in
                    NoteCard(outfit: outfit) {
                        selectedOutfitID = OutfitID(id: outfit.id)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.primaryYellow.opacity(0.7))
            
            Text("No notes yet")
                .font(.ubuntu(24, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Add comments to your outfits to see them here as personal notes and memories.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var filteredNotesOutfits: [OutfitModel] {
        let outfitsWithNotes = viewModel.outfitsWithNotes
        
        if let season = selectedSeason {
            return outfitsWithNotes.filter { $0.season == season }
        }
        
        return outfitsWithNotes
    }
}

struct NoteCard: View {
    let outfit: OutfitModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: outfit.season.icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(outfit.season.color)
                        
                        Text(outfit.shortDateString)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.accentText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.theme.darkText.opacity(0.5))
                }
                
                Text(outfit.description)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.darkText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                if !outfit.location.isEmpty || !outfit.weather.isEmpty {
                    HStack {
                        if !outfit.location.isEmpty {
                            Label(outfit.location, systemImage: "location")
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(Color.theme.darkText.opacity(0.6))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        if !outfit.weather.isEmpty {
                            Text(outfit.weather)
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(Color.theme.darkText.opacity(0.6))
                                .lineLimit(1)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.theme.primaryYellow)
                        
                        Text("Note")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(Color.theme.primaryYellow)
                    }
                    
                    Text(outfit.comment)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(Color.theme.darkText.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .padding(.leading, 4)
                }
                .padding(.top, 4)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NotesView(viewModel: OutfitViewModel())
}
