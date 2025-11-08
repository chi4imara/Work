import SwiftUI

struct ProgressSheetItem: Identifiable {
    let id = UUID()
    let type: SheetType
    
    enum SheetType {
        case moviesList
        case seriesList
    }
}

struct ProgressView: View {
    @StateObject private var viewModel: ProgressViewModel
    @State private var showingSheet: ProgressSheetItem?
    
    init(movieListViewModel: MovieListViewModel) {
        self._viewModel = StateObject(wrappedValue: ProgressViewModel(movieListViewModel: movieListViewModel))
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    if viewModel.totalCount == 0 {
                        emptyStateView
                    } else {
                        statsCardsView
                        
                        pieChartView
                        
                        typeBreakdownView
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
        }
        .sheet(item: $showingSheet) { item in
            switch item.type {
            case .moviesList:
                RecentItemsView(
                    title: "Recent Movies",
                    items: viewModel.recentMovies
                )
            case .seriesList:
                RecentItemsView(
                    title: "Recent Series",
                    items: viewModel.recentSeries
                )
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Progress")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.pie")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            Text("No Progress to Show")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Add movies and series to track your progress")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var statsCardsView: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Total",
                value: "\(viewModel.totalCount)",
                color: AppColors.primaryBlue
            )
            
            StatCard(
                title: "Watched",
                value: "\(viewModel.watchedCount)",
                color: AppColors.accent
            )
            
            StatCard(
                title: "Remaining",
                value: "\(viewModel.unwatchedCount)",
                color: AppColors.warning
            )
        }
    }
    
    private var pieChartView: some View {
        VStack(spacing: 16) {
            Text("Viewing Progress")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            ZStack {
                PieChartView(
                    watchedCount: viewModel.watchedCount,
                    unwatchedCount: viewModel.unwatchedCount
                )
                .frame(width: 200, height: 200)
                
                VStack(spacing: 4) {
                    Text("\(viewModel.watchedCount)/\(viewModel.totalCount)")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                        .fontWeight(.bold)
                    
                    Text("watched")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            HStack(spacing: 24) {
                LegendItem(
                    color: AppColors.accent,
                    title: "Watched",
                    count: viewModel.watchedCount
                )
                
                LegendItem(
                    color: AppColors.warning,
                    title: "Not Watched",
                    count: viewModel.unwatchedCount
                )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
    
    private var typeBreakdownView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("By Type")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            
            VStack(spacing: 12) {
                TypeBreakdownRow(
                    icon: "film",
                    title: "Movies",
                    total: viewModel.movieStats.total,
                    watched: viewModel.movieStats.watched,
                    onTap: { showingSheet = ProgressSheetItem(type: .moviesList) }
                )
                
                TypeBreakdownRow(
                    icon: "tv",
                    title: "Series",
                    total: viewModel.seriesStats.total,
                    watched: viewModel.seriesStats.watched,
                    onTap: { showingSheet = ProgressSheetItem(type: .seriesList) }
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(AppFonts.title2)
                .foregroundColor(color)
                .fontWeight(.bold)
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
}

struct PieChartView: View {
    let watchedCount: Int
    let unwatchedCount: Int
    
    private var totalCount: Int {
        watchedCount + unwatchedCount
    }
    
    private var watchedPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(watchedCount) / Double(totalCount)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.warning.opacity(0.3), lineWidth: 20)
            
            if watchedCount > 0 {
                Circle()
                    .trim(from: 0, to: watchedPercentage)
                    .stroke(
                        AppColors.accent,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
            }
        }
    }
}

struct LegendItem: View {
    let color: Color
    let title: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
            
            Text("(\(count))")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

struct TypeBreakdownRow: View {
    let icon: String
    let title: String
    let total: Int
    let watched: Int
    let onTap: () -> Void
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(watched) / Double(total)
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text("\(watched) / \(total)")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(AppColors.secondaryText.opacity(0.2))
                                .frame(height: 4)
                            
                            Rectangle()
                                .fill(AppColors.accent)
                                .frame(width: geometry.size.width * percentage, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.backgroundGray)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(total == 0)
    }
}

struct RecentItemsView: View {
    let title: String
    let items: [Movie]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if items.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "film")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                        
                        Text("No items found")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(items) { movie in
                                RecentItemRow(movie: movie)
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}

struct RecentItemRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(movie.isWatched ? AppColors.accent : AppColors.warning)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(movie.displaySubtitle)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(movie.formattedCreatedAt)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    ProgressView(movieListViewModel: MovieListViewModel())
}
