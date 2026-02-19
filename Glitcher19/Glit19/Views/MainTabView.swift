import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var selectedTab: TabItem = .notes
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .notes:
                    NotesView(viewModel: viewModel)
                case .categories:
                    CategoriesView(viewModel: viewModel)
                case .favorites:
                    FavoritesView(viewModel: viewModel)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct StatisticsView: View {
    @ObservedObject var viewModel: NotesViewModel
    
    private var averageNoteLength: Int {
        guard !viewModel.notes.isEmpty else { return 0 }
        let totalLength = viewModel.notes.reduce(0) { $0 + $1.text.count }
        return totalLength / viewModel.notes.count
    }
    
    private var notesThisWeek: Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return viewModel.notes.filter { $0.createdAt >= weekAgo }.count
    }
    
    private var notesThisMonth: Int {
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return viewModel.notes.filter { $0.createdAt >= monthAgo }.count
    }
    
    private var topCategories: [(name: String, count: Int)] {
        viewModel.categories
            .filter { $0.notesCount > 0 }
            .sorted { $0.notesCount > $1.notesCount }
            .prefix(5)
            .map { (name: $0.name, count: $0.notesCount) }
    }
    
    private var recentNotes: [Note] {
        Array(viewModel.notes.sorted { $0.createdAt > $1.createdAt }.prefix(5))
    }
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 20) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color.theme.accentYellow)
                        
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        StatCard(
                            title: "Total Notes",
                            value: "\(viewModel.notes.count)",
                            icon: "note.text"
                        )
                        
                        StatCard(
                            title: "Categories",
                            value: "\(viewModel.categories.filter { $0.notesCount > 0 }.count)",
                            icon: "folder.fill"
                        )
                        
                        StatCard(
                            title: "Favorites",
                            value: "\(viewModel.notes.filter { $0.isFavorite }.count)",
                            icon: "heart.fill"
                        )
                        
                        StatCard(
                            title: "Avg. Length",
                            value: "\(averageNoteLength) chars",
                            icon: "text.alignleft"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Activity")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ActivityStatCard(
                                title: "This Week",
                                value: "\(notesThisWeek)",
                                icon: "calendar",
                                color: Color.theme.accentYellow
                            )
                            
                            ActivityStatCard(
                                title: "This Month",
                                value: "\(notesThisMonth)",
                                icon: "calendar.badge.clock",
                                color: Color.theme.accentYellow
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    if !topCategories.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Top Categories")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(Array(topCategories.enumerated()), id: \.offset) { index, category in
                                    CategoryStatRow(
                                        rank: index + 1,
                                        categoryName: category.name,
                                        count: category.count,
                                        totalNotes: viewModel.notes.count
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    if !recentNotes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Notes")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(recentNotes) { note in
                                    NavigationLink(destination: NoteDetailView(noteId: note.id, viewModel: viewModel)) {
                                        RecentNoteRow(note: note)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(Color.theme.accentYellow)
                .frame(width: 60, height: 60)
                .background(Color.theme.accentYellow.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(value)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
    }
}

struct ActivityStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Text(value)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
    }
}

struct CategoryStatRow: View {
    let rank: Int
    let categoryName: String
    let count: Int
    let totalNotes: Int
    
    private var percentage: Double {
        guard totalNotes > 0 else { return 0 }
        return Double(count) / Double(totalNotes) * 100
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text("#\(rank)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(Color.theme.accentYellow)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(categoryName)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("\(count) \(count == 1 ? "note" : "notes") • \(String(format: "%.0f", percentage))%")
                    .font(.ubuntu(12))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.theme.cardBackground.opacity(0.5))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(Color.theme.accentYellow)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(width: 80, height: 6)
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
    }
}

struct RecentNoteRow: View {
    let note: Note
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "note.text")
                .font(.system(size: 20))
                .foregroundColor(Color.theme.accentYellow)
                .frame(width: 40, height: 40)
                .background(Color.theme.accentYellow.opacity(0.2))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.firstLine)
                    .font(.ubuntu(15, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(note.category)
                        .font(.ubuntu(12))
                        .foregroundColor(Color.theme.accentYellow)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.theme.accentYellow.opacity(0.2))
                        .cornerRadius(6)
                    
                    Text(note.formattedDate)
                        .font(.ubuntu(12))
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    MainTabView()
}
