import SwiftUI

struct JournalView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showAddSession = false
    @State private var showFilters = false
    @State private var showSortOptions = false
    @State private var selectedSession: GameSession?
    @State private var sessionToDelete: GameSession?
    @State private var sessionToEdit: GameSession?
    @State private var showPlayerManagement = false
    
    @State private var selectedGameId: UUID?
    @State private var selectedPlayers: Set<String> = []
    @State private var selectedWinner: String?
    @State private var locationFilter: String = ""
    
    @State private var sortBy: SortOption = .dateDesc
    
    enum SortOption {
        case dateDesc, dateAsc, durationDesc, durationAsc
    }
    
    private var allSessions: [GameSession] {
        dataManager.sessions
    }
    
    private var filteredByGame: [GameSession] {
        if let gameId = selectedGameId {
            return allSessions.filter { $0.gameId == gameId }
        }
        return allSessions
    }
    
    private var filteredByPlayers: [GameSession] {
        if selectedPlayers.isEmpty {
            return filteredByGame
        }
        return filteredByGame.filter { session in
            !Set(session.players).isDisjoint(with: selectedPlayers)
        }
    }
    
    private var filteredByWinner: [GameSession] {
        if let winner = selectedWinner {
            return filteredByPlayers.filter { $0.winner == winner }
        }
        return filteredByPlayers
    }
    
    private var filteredByLocation: [GameSession] {
        if locationFilter.isEmpty {
            return filteredByWinner
        }
        return filteredByWinner.filter { $0.location.localizedCaseInsensitiveContains(locationFilter) }
    }
    
    var filteredSessions: [GameSession] {
        var sessions = filteredByLocation
        
        switch sortBy {
        case .dateDesc:
            sessions.sort { $0.date > $1.date }
        case .dateAsc:
            sessions.sort { $0.date < $1.date }
        case .durationDesc:
            sessions.sort { ($0.duration ?? 0) > ($1.duration ?? 0) }
        case .durationAsc:
            sessions.sort { ($0.duration ?? 0) < ($1.duration ?? 0) }
        }
        
        return sessions
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Journal")
                        .font(AppFonts.bold(size: 22))
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
                    
                    Button(action: { showPlayerManagement = true }) {
                        Image(systemName: "person.2")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    
                    Button(action: { showAddSession = true }) {
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
                
                if filteredSessions.isEmpty {
                    EmptyStateView(
                        icon: "list.bullet.clipboard",
                        title: dataManager.sessions.isEmpty ? "No Sessions Yet" : "No Sessions Found",
                        subtitle: dataManager.sessions.isEmpty ? "Add your first session" : "Try adjusting filters",
                        action: dataManager.sessions.isEmpty ? nil : { resetFilters() },
                        actionTitle: "Reset Filters"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredSessions) { session in
                                SessionCardView(session: session)
                                    .onTapGesture {
                                        selectedSession = session
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            sessionToDelete = session
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button {
                                            sessionToEdit = session
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(AppColors.primaryBlue)
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSession) {
            AddEditSessionView(session: nil, preselectedGame: nil)
        }
        .sheet(item: $selectedSession) { session in
            SessionDetailView(sessionId: session.id)
        }
        .sheet(item: $sessionToEdit) { session in
            AddEditSessionView(session: session, preselectedGame: nil)
        }
        .sheet(isPresented: $showPlayerManagement) {
            PlayerManagementView()
        }
        .alert("Delete Session", isPresented: Binding(
            get: { sessionToDelete != nil },
            set: { if !$0 { sessionToDelete = nil } }
        )) {
            Button("Cancel", role: .cancel) {
                sessionToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let session = sessionToDelete {
                    dataManager.deleteSession(session)
                }
                sessionToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this session?")
        }
        .confirmationDialog("Sort By", isPresented: $showSortOptions) {
            Button("Date (Newest First)") { sortBy = .dateDesc }
            Button("Date (Oldest First)") { sortBy = .dateAsc }
            Button("Duration (Longest First)") { sortBy = .durationDesc }
            Button("Duration (Shortest First)") { sortBy = .durationAsc }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showFilters) {
            JournalFiltersView(
                selectedGameId: $selectedGameId,
                selectedPlayers: $selectedPlayers,
                selectedWinner: $selectedWinner,
                locationFilter: $locationFilter
            )
        }
    }
    
    private func resetFilters() {
        selectedGameId = nil
        selectedPlayers = []
        selectedWinner = nil
        locationFilter = ""
    }
}

struct SessionCardView: View {
    let session: GameSession
    @ObservedObject private var dataManager = DataManager.shared
    
    var game: Game? {
        dataManager.games.first { $0.id == session.gameId }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.date.formatted(date: .abbreviated, time: .omitted))
                        .font(AppFonts.semiBold(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    if let game = game {
                        Text(game.name)
                            .font(AppFonts.medium(size: 14))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
                
                Spacer()
                
                if let duration = session.duration {
                    Text("\(duration) min")
                        .font(AppFonts.regular(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppColors.lightBlue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.accentOrange)
                    Text("Winner: \(session.winner)")
                        .font(AppFonts.medium(size: 14))
                        .foregroundColor(AppColors.primaryText)
                }
                
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.primaryBlue)
                    Text(session.players.joined(separator: ", "))
                        .font(AppFonts.regular(size: 13))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                }
                
                if !session.location.isEmpty {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.primaryBlue)
                        Text(session.location)
                            .font(AppFonts.regular(size: 13))
                            .foregroundColor(AppColors.secondaryText)
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

struct JournalFiltersView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Binding var selectedGameId: UUID?
    @Binding var selectedPlayers: Set<String>
    @Binding var selectedWinner: String?
    @Binding var locationFilter: String
    @Environment(\.dismiss) var dismiss
    
    private var sessionPlayerNames: [String] {
        dataManager.sessions.flatMap { $0.players }
    }
    
    var allPlayerNames: [String] {
        Array(Set(sessionPlayerNames)).sorted()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Game")
                                .font(AppFonts.semiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    Button(action: {
                                        selectedGameId = nil
                                    }) {
                                        Text("All Games")
                                            .font(AppFonts.regular(size: 14))
                                            .foregroundColor(selectedGameId == nil ? .white : AppColors.primaryBlue)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedGameId == nil ? AppColors.primaryBlue : AppColors.lightBlue.opacity(0.2))
                                            .cornerRadius(16)
                                    }
                                    
                                    ForEach(dataManager.games) { game in
                                        Button(action: {
                                            selectedGameId = game.id
                                        }) {
                                            Text(game.name)
                                                .font(AppFonts.regular(size: 14))
                                                .foregroundColor(selectedGameId == game.id ? .white : AppColors.primaryBlue)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedGameId == game.id ? AppColors.primaryBlue : AppColors.lightBlue.opacity(0.2))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if !allPlayerNames.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Players")
                                    .font(AppFonts.semiBold(size: 18))
                                    .foregroundColor(AppColors.primaryText)
                                
                                FlowLayout(spacing: 10) {
                                    ForEach(allPlayerNames, id: \.self) { player in
                                        Button(action: {
                                            if selectedPlayers.contains(player) {
                                                selectedPlayers.remove(player)
                                            } else {
                                                selectedPlayers.insert(player)
                                            }
                                        }) {
                                            Text(player)
                                                .font(AppFonts.regular(size: 14))
                                                .foregroundColor(selectedPlayers.contains(player) ? .white : AppColors.primaryBlue)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedPlayers.contains(player) ? AppColors.primaryBlue : AppColors.lightBlue.opacity(0.2))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(AppFonts.semiBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Filter by location", text: $locationFilter)
                                .font(AppFonts.regular(size: 16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        Spacer(minLength: 20)
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                selectedGameId = nil
                                selectedPlayers = []
                                selectedWinner = nil
                                locationFilter = ""
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

