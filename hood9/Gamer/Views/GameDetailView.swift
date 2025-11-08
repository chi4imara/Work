import SwiftUI

struct GameDetailView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) var dismiss
    
    let gameId: UUID
    @State private var showEditGame = false
    @State private var showDeleteConfirmation = false
    @State private var showAddSession = false
    @State private var selectedSession: GameSession?
    
    var game: Game? {
        dataManager.games.first { $0.id == gameId }
    }
    
    var gameSessions: [GameSession] {
        dataManager.sessions
            .filter { $0.gameId == gameId }
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let game = game {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Game Info")
                                    .font(AppFonts.semiBold(size: 20))
                                    .foregroundColor(AppColors.primaryText)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    InfoRow(label: "Players", value: "\(game.minPlayers)-\(game.maxPlayers)")
                                    InfoRow(label: "Play Time", value: "\(game.minTime)-\(game.maxTime) min")
                                    
                                    if !game.tags.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Tags:")
                                                .font(AppFonts.regular(size: 14))
                                                .foregroundColor(AppColors.secondaryText)
                                            
                                            FlowLayout(spacing: 8) {
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
                                        }
                                    }
                                    
                                    if !game.notes.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Notes:")
                                                .font(AppFonts.regular(size: 14))
                                                .foregroundColor(AppColors.secondaryText)
                                            Text(game.notes)
                                                .font(AppFonts.regular(size: 14))
                                                .foregroundColor(AppColors.primaryText)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                            }
                        
                            if !gameSessions.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Statistics")
                                        .font(AppFonts.semiBold(size: 20))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    VStack(spacing: 16) {
                                        StatRow(label: "Total Sessions", value: "\(gameSessions.count)")
                                        
                                        if let lastDate = gameSessions.first?.date {
                                            StatRow(label: "Last Played", value: lastDate.formatted(date: .abbreviated, time: .omitted))
                                        }
                                        
                                        if let avgDuration = dataManager.getAverageDuration(for: gameId) {
                                            StatRow(label: "Avg Duration", value: "\(avgDuration) min")
                                        }
                                        
                                        if let topPlayer = dataManager.getTopPlayer(for: gameId) {
                                            StatRow(label: "Top Player", value: "\(topPlayer.name) (\(topPlayer.wins) wins)")
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(16)
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Recent Sessions")
                                            .font(AppFonts.semiBold(size: 20))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                        
                                        Text("Last 5")
                                            .font(AppFonts.regular(size: 14))
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    
                                    ForEach(gameSessions.prefix(5)) { session in
                                        SessionRowView(session: session, game: game)
                                            .onTapGesture {
                                                selectedSession = session
                                            }
                                    }
                                }
                            } else {
                                EmptyStateView(
                                    icon: "list.bullet.clipboard",
                                    title: "No Sessions Yet",
                                    subtitle: "Add the first session for this game",
                                    action: nil,
                                    actionTitle: nil
                                )
                                .frame(height: 200)
                            }
                            
                            Button(action: { showAddSession = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20))
                                    Text("Add Session")
                                        .font(AppFonts.semiBold(size: 16))
                                }
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
                        .padding()
                    }
                } else {
                    VStack {
                        Text("Game not found")
                            .font(AppFonts.medium(size: 18))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle(game?.name ?? "Game Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showEditGame = true }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
            }
        }
        .sheet(isPresented: $showEditGame) {
            if let game = game {
                AddEditGameView(game: game)
            }
        }
        .sheet(isPresented: $showAddSession) {
            if let game = game {
                AddEditSessionView(session: nil, preselectedGame: game)
            }
        }
        .sheet(item: $selectedSession) { session in
            SessionDetailView(sessionId: session.id)
        }
        .alert("Delete Game", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let game = game {
                    dataManager.deleteGame(game)
                }
                dismiss()
            }
        } message: {
            Text("This will delete the game and all \(gameSessions.count) related sessions.")
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .font(AppFonts.regular(size: 14))
                .foregroundColor(AppColors.secondaryText)
            Spacer()
            Text(value)
                .font(AppFonts.medium(size: 14))
                .foregroundColor(AppColors.primaryText)
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(AppFonts.medium(size: 15))
                .foregroundColor(AppColors.primaryText)
            Spacer()
            Text(value)
                .font(AppFonts.semiBold(size: 15))
                .foregroundColor(AppColors.primaryBlue)
        }
    }
}

struct SessionRowView: View {
    let session: GameSession
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(session.date.formatted(date: .abbreviated, time: .omitted))
                    .font(AppFonts.medium(size: 14))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if let duration = session.duration {
                    Text("\(duration) min")
                        .font(AppFonts.regular(size: 13))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            HStack {
                Text("Winner:")
                    .font(AppFonts.regular(size: 13))
                    .foregroundColor(AppColors.secondaryText)
                Text(session.winner)
                    .font(AppFonts.medium(size: 13))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            Text("Players: \(session.players.joined(separator: ", "))")
                .font(AppFonts.regular(size: 13))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(1)
            
            if !session.location.isEmpty {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11))
                    Text(session.location)
                        .font(AppFonts.regular(size: 12))
                }
                .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

