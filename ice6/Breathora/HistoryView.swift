import SwiftUI

struct HistoryView: View {
    @ObservedObject var sessionManager = SessionManager.shared
    @State private var sessionToDelete: SessionRecord?
    @State private var showingDeleteAlert = false
    @State private var selectedSession: SessionRecord?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if sessionManager.sessions.isEmpty {
                    emptyStateView
                } else {
                    sessionsListView
                }
            }
        }
        .sheet(item: $selectedSession) { session in
            SessionDetailView(session: session)
        }
        .alert("Delete Session", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let session = sessionToDelete {
                    sessionManager.deleteSession(session)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this session record?")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Practice History")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.darkText)
            
            Spacer()
            
            if !sessionManager.sessions.isEmpty {
                Text("\(sessionManager.sessions.count) sessions")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.mediumText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.lightPurple)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var sessionsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(sessionManager.sessions) { session in
                    SessionCardView(
                        session: session,
                        onTap: {
                            selectedSession = session
                        },
                        onDelete: {
                            sessionToDelete = session
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryPurple.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No Sessions Yet")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                
                Text("Your completed breathing sessions will appear here after practice")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.mediumText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct SessionCardView: View {
    let session: SessionRecord
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.programName)
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.darkText)
                        
                        Text(session.shortDate)
                            .font(.playfairDisplay(size: 14, weight: .medium))
                            .foregroundColor(AppColors.mediumText)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: session.completedCycles == session.totalCycles ? "checkmark.circle.fill" : "clock.fill")
                            .font(.system(size: 20))
                            .foregroundColor(session.completedCycles == session.totalCycles ? .green : AppColors.yellowAccent)
                        
                        Text(session.completedCycles == session.totalCycles ? "Complete" : "Partial")
                            .font(.playfairDisplay(size: 10, weight: .medium))
                            .foregroundColor(AppColors.lightText)
                    }
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Label("\(session.completedCycles)/\(session.totalCycles) cycles", systemImage: "repeat")
                        Spacer()
                        Label(session.formattedDuration, systemImage: "timer")
                    }
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.lightText)
                    
                    HStack {
                        Text(session.programPhases)
                            .font(.playfairDisplay(size: 12, weight: .regular))
                            .foregroundColor(AppColors.lightText)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                }
                
                HStack {
                    Text("Started: \(formatTime(session.startTime))")
                    Spacer()
                    Text("Ended: \(formatTime(session.endTime))")
                }
                .font(.playfairDisplay(size: 11, weight: .regular))
                .foregroundColor(AppColors.lightText.opacity(0.8))
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.darkText.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
}
