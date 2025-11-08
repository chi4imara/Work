import SwiftUI

struct CollectionView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showAddGame = false
    @State private var showFilters = false
    @State private var showSortOptions = false
    @State private var selectedGame: Game?
    @State private var gameToDelete: Game?
    @State private var gameToAddSession: Game?
    
    @State private var selectedTags: Set<String> = []
    @State private var minPlayersFilter: Int?
    @State private var maxPlayersFilter: Int?
    @State private var statusFilter: String = "All"
    
    @State private var sortBy: SortOption = .name
    
    enum SortOption {
        case name, sessionCount, lastPlayed
    }
    
    private var allGames: [Game] {
        dataManager.games
    }
    
    private var filteredByTags: [Game] {
        if selectedTags.isEmpty {
            return allGames
        }
        return allGames.filter { game in
            !Set(game.tags).isDisjoint(with: selectedTags)
        }
    }
    
    private var filteredByStatus: [Game] {
        switch statusFilter {
        case "Active":
            return filteredByTags.filter { $0.isActive }
        case "Inactive":
            return filteredByTags.filter { !$0.isActive }
        default:
            return filteredByTags
        }
    }
    
    var filteredGames: [Game] {
        var games = filteredByStatus
        
        switch sortBy {
        case .name:
            games.sort { $0.name < $1.name }
        case .sessionCount:
            games.sort { gameSessionCount($0) > gameSessionCount($1) }
        case .lastPlayed:
            games.sort { (gameLastPlayed($0) ?? Date.distantPast) > (gameLastPlayed($1) ?? Date.distantPast) }
        }
        
        return games
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Collection")
                        .font(AppFonts.bold(size: 23))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.leading, 60)
                    
                    Spacer()
                    
                    Button(action: { showSortOptions = true }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    
                    Button(action: { showFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    
                    Button(action: { showAddGame = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding()
                
                if filteredGames.isEmpty {
                    EmptyStateView(
                        icon: "dice.fill",
                        title: dataManager.games.isEmpty ? "No Games Yet" : "No Games Found",
                        subtitle: dataManager.games.isEmpty ? "Add your first game" : "Try adjusting filters",
                        action: dataManager.games.isEmpty ? nil : { resetFilters() },
                        actionTitle: "Reset Filters"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredGames) { game in
                                GameCardView(game: game)
                                    .onTapGesture {
                                        selectedGame = game
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddGame) {
            AddEditGameView(game: nil)
        }
        .sheet(item: $selectedGame) { game in
            GameDetailView(gameId: game.id)
        }
        .sheet(item: $gameToAddSession) { game in
            AddEditSessionView(session: nil, preselectedGame: game)
        }
        .alert("Delete Game", isPresented: Binding(
            get: { gameToDelete != nil },
            set: { if !$0 { gameToDelete = nil } }
        )) {
            Button("Cancel", role: .cancel) {
                gameToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let game = gameToDelete {
                    dataManager.deleteGame(game)
                }
                gameToDelete = nil
            }
        } message: {
            Text("This will delete the game and all related sessions.")
        }
        .confirmationDialog("Sort By", isPresented: $showSortOptions) {
            Button("Name") { sortBy = .name }
            Button("Session Count") { sortBy = .sessionCount }
            Button("Last Played") { sortBy = .lastPlayed }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showFilters) {
            FiltersView(
                selectedTags: $selectedTags,
                statusFilter: $statusFilter
            )
        }
    }
    
    private func gameSessionCount(_ game: Game) -> Int {
        dataManager.sessions.filter { $0.gameId == game.id }.count
    }
    
    private func gameLastPlayed(_ game: Game) -> Date? {
        dataManager.sessions
            .filter { $0.gameId == game.id }
            .map { $0.date }
            .max()
    }
    
    private func resetFilters() {
        selectedTags = []
        statusFilter = "All"
    }
}

struct GameCardView: View {
    let game: Game
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(game.name)
                    .font(AppFonts.semiBold(size: 20))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if !game.isActive {
                    Text("Inactive")
                        .font(AppFonts.regular(size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.secondaryText)
                        .cornerRadius(8)
                }
            }
            
            Text("\(game.minPlayers)-\(game.maxPlayers) Players • \(game.minTime)-\(game.maxTime) min")
                .font(AppFonts.regular(size: 14))
                .foregroundColor(AppColors.secondaryText)
            
            if !game.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(game.tags, id: \.self) { tag in
                            Text(tag)
                                .font(AppFonts.regular(size: 12))
                                .foregroundColor(AppColors.primaryBlue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppColors.lightBlue.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, -16)
            }
            
            let sessions = dataManager.sessions.filter { $0.gameId == game.id }
            if !sessions.isEmpty {
                Divider()
                    .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        StatItemView(label: "Sessions", value: "\(sessions.count)")
                        Spacer()
                        if let lastDate = sessions.map({ $0.date }).max() {
                            StatItemView(label: "Last Played", value: lastDate.formatted(date: .abbreviated, time: .omitted))
                        }
                    }
                    
                    if let avgDuration = dataManager.getAverageDuration(for: game.id) {
                        StatItemView(label: "Avg Duration", value: "\(avgDuration) min")
                    }
                    
                    if let topPlayer = dataManager.getTopPlayer(for: game.id) {
                        StatItemView(label: "Top Player", value: "\(topPlayer.name) (\(topPlayer.wins) wins)")
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct StatItemView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label + ":")
                .font(AppFonts.regular(size: 13))
                .foregroundColor(AppColors.secondaryText)
            Text(value)
                .font(AppFonts.medium(size: 13))
                .foregroundColor(AppColors.primaryBlue)
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    var action: (() -> Void)?
    var actionTitle: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue)
            
            HStack {
                Spacer()
                
                VStack(spacing: 8) {
                    Text(title)
                        .font(AppFonts.semiBold(size: 22))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(AppFonts.regular(size: 16))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            
            if let action = action, let actionTitle = actionTitle {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppFonts.medium(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
            
            Spacer()
        }
    }
}

struct FiltersView: View {
    @Binding var selectedTags: Set<String>
    @Binding var statusFilter: String
    @Environment(\.dismiss) var dismiss
    
    let availableTags = ["Family", "Euro", "Abstract", "Party", "Cooperative", "Duel", "Strategy", "Card Game"]
    let statusOptions = ["All", "Active", "Inactive"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tags")
                                .font(AppFonts.semiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            FlowLayout(spacing: 10) {
                                ForEach(availableTags, id: \.self) { tag in
                                    Button(action: {
                                        if selectedTags.contains(tag) {
                                            selectedTags.remove(tag)
                                        } else {
                                            selectedTags.insert(tag)
                                        }
                                    }) {
                                        Text(tag)
                                            .font(AppFonts.regular(size: 14))
                                            .foregroundColor(selectedTags.contains(tag) ? .white : AppColors.primaryBlue)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedTags.contains(tag) ? AppColors.primaryBlue : AppColors.lightBlue.opacity(0.2))
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Status")
                                .font(AppFonts.semiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(statusOptions, id: \.self) { status in
                                    Button(action: {
                                        statusFilter = status
                                    }) {
                                        Text(status)
                                            .font(AppFonts.regular(size: 14))
                                            .foregroundColor(statusFilter == status ? .white : AppColors.primaryBlue)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(statusFilter == status ? AppColors.primaryBlue : AppColors.lightBlue.opacity(0.2))
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                selectedTags = []
                                statusFilter = "All"
                            }) {
                                Text("Reset")
                                    .font(AppFonts.medium(size: 16))
                                    .foregroundColor(AppColors.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primaryBlue, lineWidth: 1)
                                    )
                            }
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Apply")
                                    .font(AppFonts.medium(size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        LinearGradient(
                                            colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Filters")
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

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth, currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

