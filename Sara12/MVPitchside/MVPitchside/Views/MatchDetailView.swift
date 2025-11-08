import SwiftUI

struct MatchDetailView: View {
    @ObservedObject var viewModel: MatchViewModel
    @Environment(\.dismiss) private var dismiss
    
    let matchId: UUID
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var match: Match? {
        viewModel.matches.first { $0.id == matchId }
    }
    
    var body: some View {
        ZStack {
            AppGradient.background
                .ignoresSafeArea()
            
            if let match = match {
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("Match Detail")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text(match.displayTeams)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text(match.formattedDate)
                                .font(.title3)
                                .foregroundColor(.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 12) {
                            Text("Final Score")
                                .font(.headline)
                                .foregroundColor(.secondaryText)
                            
                            HStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Text(match.teamA)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("\(match.scoreA)")
                                        .font(.custom("Poppins-Bold", size: 48))
                                        .foregroundColor(.primaryAccent)
                                }
                                .frame(maxWidth: .infinity)
                                
                                Text(":")
                                    .font(.custom("Poppins-Bold", size: 48))
                                    .foregroundColor(.primaryText)
                                
                                VStack(spacing: 8) {
                                    Text(match.teamB)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("\(match.scoreB)")
                                        .font(.custom("Poppins-Bold", size: 48))
                                        .foregroundColor(.primaryAccent)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.shadowColor, radius: 8, x: 0, y: 4)
                            )
                        }
                        
                        VStack(spacing: 12) {
                            Text("Result")
                                .font(.headline)
                                .foregroundColor(.secondaryText)
                            
                            HStack {
                                Image(systemName: resultIcon)
                                    .font(.title2)
                                    .foregroundColor(resultColor)
                                
                                Text(resultText)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(resultColor)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(resultColor.opacity(0.1))
                            )
                        }
                        
                        if let mvp = match.mvp {
                            VStack(spacing: 12) {
                                Text("Best Player")
                                    .font(.headline)
                                    .foregroundColor(.secondaryText)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .font(.title2)
                                        .foregroundColor(.warningColor)
                                    
                                    Text(mvp)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primaryText)
                                    
                                    Text("MVP")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.warningColor)
                                        .cornerRadius(8)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
                                )
                            }
                        }
                        
                        if let note = match.note, !note.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Notes")
                                    .font(.headline)
                                    .foregroundColor(.secondaryText)
                                
                                Text(note)
                                    .font(.body)
                                    .foregroundColor(.primaryText)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.cardBackground)
                                            .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
                                    )
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: { showingEditSheet = true }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Match")
                                }
                                .font(.buttonText)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.primaryAccent)
                                .cornerRadius(25)
                            }
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete Match")
                                }
                                .font(.buttonText)
                                .foregroundColor(.errorColor)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.errorColor.opacity(0.1))
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.errorColor, lineWidth: 1)
                                )
                            }
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            } else {
                VStack {
                    Text("Match not found")
                        .font(.title2)
                        .foregroundColor(.secondaryText)
                    
                    Button("Go Back") {
                        dismiss()
                    }
                    .foregroundColor(.primaryAccent)
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle("Match Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) {
            if let match = match {
                AddEditMatchView(viewModel: viewModel, matchToEdit: match)
            }
        }
        .alert("Delete Match", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let match = match {
                    viewModel.deleteMatch(match)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this match? This action cannot be undone.")
        }
    }
    
    private var resultIcon: String {
        guard let match = match else { return "questionmark.circle.fill" }
        switch match.result {
        case .win:
            return "trophy.fill"
        case .loss:
            return "xmark.circle.fill"
        case .draw:
            return "equal.circle.fill"
        }
    }
    
    private var resultColor: Color {
        guard let match = match else { return .secondaryText }
        switch match.result {
        case .win:
            return .successColor
        case .loss:
            return .errorColor
        case .draw:
            return .warningColor
        }
    }
    
    private var resultText: String {
        guard let match = match else { return "Unknown" }
        switch match.result {
        case .win:
            return "Victory"
        case .loss:
            return "Defeat"
        case .draw:
            return "Draw"
        }
    }
}

#Preview {
    NavigationView {
        let viewModel = MatchViewModel()
        let previewMatch = Match(
            date: Date(),
            teamA: "Lions",
            teamB: "Eagles",
            scoreA: 3,
            scoreB: 2,
            mvp: "John Doe",
            note: "Great game with amazing teamwork!"
        )
        viewModel.matches = [previewMatch]
        
        return MatchDetailView(
            viewModel: viewModel,
            matchId: previewMatch.id
        )
    }
}
