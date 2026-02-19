import SwiftUI

struct StatisticsView: View {
    @ObservedObject var fragranceViewModel: FragranceViewModel
    @State private var selectedFragranceId: UUID?
    
    private var totalFragrances: Int {
        fragranceViewModel.fragrances.count
    }
    
    private var fragrancesBySeason: [Season: Int] {
        Dictionary(grouping: fragranceViewModel.fragrances, by: { $0.season })
            .mapValues { $0.count }
    }
    
    private var fragrancesByFormat: [FragranceFormat: Int] {
        Dictionary(grouping: fragranceViewModel.fragrances, by: { $0.format })
            .mapValues { $0.count }
    }
    
    private var mostCommonNotes: [(String, Int)] {
        let allNotes = fragranceViewModel.fragrances.flatMap { $0.notes }
        let noteCounts = Dictionary(grouping: allNotes, by: { $0.lowercased() })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(5)
        
        return noteCounts.map { ($0.key.capitalized, $0.value) }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Statistics")
                    .font(.lumierepolis(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                VStack(spacing: 24) {
                    if totalFragrances == 0 {
                        EmptyStatisticsView()
                        
                        Spacer()
                    } else {
                        ScrollView {
                            VStack {
                                TotalCountCard(count: totalFragrances)
                                
                                if !fragrancesBySeason.isEmpty {
                                    SeasonStatisticsCard(statistics: fragrancesBySeason)
                                }
                                
                                if !fragrancesByFormat.isEmpty {
                                    FormatStatisticsCard(statistics: fragrancesByFormat)
                                }
                                
                                if !mostCommonNotes.isEmpty {
                                    TopNotesCard(notes: mostCommonNotes)
                                }
                                
                                RecentFragrancesCard(
                                    fragrances: Array(fragranceViewModel.fragrances.sorted { $0.dateAdded > $1.dateAdded }.prefix(5))
                                ) { fragranceId in
                                    selectedFragranceId = fragranceId
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 120)
                        }
                    }
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedFragranceId },
            set: { selectedFragranceId = $0 }
        )) { id in
            if let fragrance = fragranceViewModel.fragrances.first(where: { $0.id == id }) {
                FragranceDetailView(
                    fragranceId: fragrance.id,
                    fragranceViewModel: fragranceViewModel
                )
            }
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No Statistics Available")
                    .font(.lumierepolis(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add fragrances to see statistics")
                    .font(.lumierepolis(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct TotalCountCard: View {
    let count: Int
    
    var body: some View {
        StatisticsCard(title: "Total Fragrances") {
            VStack(spacing: 8) {
                Text("\(count)")
                    .font(.lumierepolis(48, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(count == 1 ? "fragrance" : "fragrances")
                    .font(.lumierepolis(16))
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }
}

struct SeasonStatisticsCard: View {
    let statistics: [Season: Int]
    
    var body: some View {
        StatisticsCard(title: "By Season") {
            VStack(spacing: 12) {
                ForEach(Season.allCases, id: \.self) { season in
                    if let count = statistics[season], count > 0 {
                        SeasonStatRow(season: season, count: count)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct SeasonStatRow: View {
    let season: Season
    let count: Int
    
    var body: some View {
        HStack {
            Text(season.displayName)
                .font(.lumierepolis(16))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text("\(count)")
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(AppColors.accentGreen)
        }
        .padding(.horizontal, 4)
    }
}

struct FormatStatisticsCard: View {
    let statistics: [FragranceFormat: Int]
    
    var body: some View {
        StatisticsCard(title: "By Format") {
            HStack(spacing: 20) {
                ForEach(FragranceFormat.allCases, id: \.self) { format in
                    if let count = statistics[format], count > 0 {
                        FormatStatItem(format: format, count: count)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct FormatStatItem: View {
    let format: FragranceFormat
    let count: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.lumierepolis(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(format.displayName)
                .font(.lumierepolis(14))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TopNotesCard: View {
    let notes: [(String, Int)]
    
    var body: some View {
        StatisticsCard(title: "Top Notes") {
            VStack(spacing: 12) {
                ForEach(Array(notes.enumerated()), id: \.offset) { index, note in
                    TopNoteRow(rank: index + 1, note: note.0, count: note.1)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct TopNoteRow: View {
    let rank: Int
    let note: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank).")
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(AppColors.accentPink)
                .frame(width: 24)
            
            Text(note)
                .font(.lumierepolis(16))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text("\(count)")
                .font(.lumierepolis(14))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.horizontal, 4)
    }
}

struct RecentFragrancesCard: View {
    let fragrances: [Fragrance]
    let onFragranceTap: (UUID) -> Void
    
    var body: some View {
        StatisticsCard(title: "Recent Additions") {
            if fragrances.isEmpty {
                Text("No recent fragrances")
                    .font(.lumierepolis(14))
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(fragrances) { fragrance in
                        Button(action: { onFragranceTap(fragrance.id) }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(fragrance.name)
                                        .font(.lumierepolis(16, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text(fragrance.season.displayName)
                                        .font(.lumierepolis(12))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                        }
                        
                        if fragrance.id != fragrances.last?.id {
                            Divider()
                                .background(AppColors.cardBorder)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct StatisticsCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.lumierepolis(18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

#Preview {
    StatisticsView(fragranceViewModel: FragranceViewModel())
}
