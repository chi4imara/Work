import SwiftUI

struct SessionDetailView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) var dismiss
    
    let sessionId: UUID
    @State private var showEditSession = false
    @State private var showDeleteConfirmation = false
    
    var session: GameSession? {
        dataManager.sessions.first { $0.id == sessionId }
    }
    
    var game: Game? {
        guard let session = session else { return nil }
        return dataManager.games.first { $0.id == session.gameId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let session = session {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            if let game = game {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Game")
                                        .font(AppFonts.semiBold(size: 20))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text(game.name)
                                        .font(AppFonts.medium(size: 18))
                                        .foregroundColor(AppColors.primaryBlue)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                        .cornerRadius(16)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Session Details")
                                    .font(AppFonts.semiBold(size: 20))
                                    .foregroundColor(AppColors.primaryText)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    DetailRow(icon: "calendar", label: "Date", value: session.date.formatted(date: .long, time: .omitted))
                                    
                                    DetailRow(icon: "trophy.fill", label: "Winner", value: session.winner)
                                    
                                    if let duration = session.duration {
                                        DetailRow(icon: "clock.fill", label: "Duration", value: "\(duration) minutes")
                                    }
                                    
                                    if !session.location.isEmpty {
                                        DetailRow(icon: "location.fill", label: "Location", value: session.location)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Players")
                                    .font(AppFonts.semiBold(size: 20))
                                    .foregroundColor(AppColors.primaryText)
                                
                                FlowLayout(spacing: 10) {
                                    ForEach(session.players, id: \.self) { player in
                                        HStack(spacing: 6) {
                                            if player == session.winner {
                                                Image(systemName: "crown.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(AppColors.accentOrange)
                                            }
                                            Text(player)
                                                .font(AppFonts.medium(size: 14))
                                        }
                                        .foregroundColor(player == session.winner ? AppColors.accentOrange : AppColors.primaryBlue)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            player == session.winner ?
                                            AppColors.accentOrange.opacity(0.2) :
                                            AppColors.lightBlue.opacity(0.2)
                                        )
                                        .cornerRadius(16)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                            }
                            
                            if !session.notes.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Notes")
                                        .font(AppFonts.semiBold(size: 20))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text(session.notes)
                                        .font(AppFonts.regular(size: 15))
                                        .foregroundColor(AppColors.primaryText)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    VStack {
                        Text("Session not found")
                            .font(AppFonts.medium(size: 18))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Session Details")
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
                        Button(action: { showEditSession = true }) {
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
        .sheet(isPresented: $showEditSession) {
            if let session = session {
                AddEditSessionView(session: session, preselectedGame: nil)
            }
        }
        .alert("Delete Session", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let session = session {
                    dataManager.deleteSession(session)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this session?")
        }
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.primaryBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(AppFonts.regular(size: 13))
                    .foregroundColor(AppColors.secondaryText)
                Text(value)
                    .font(AppFonts.medium(size: 15))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
    }
}

