import SwiftUI

struct AddEditMatchView: View {
    @ObservedObject var viewModel: MatchViewModel
    @Environment(\.dismiss) private var dismiss
    
    let matchToEdit: Match?
    
    @State private var date = Date()
    @State private var teamA = ""
    @State private var teamB = ""
    @State private var scoreA = ""
    @State private var scoreB = ""
    @State private var mvp = ""
    @State private var note = ""
    @State private var showingDatePicker = false
    @State private var showingSuggestions = false
    @State private var playerSuggestions: [String] = []
    
    @State private var errorMessage = ""
    @State private var showingError = false
    
    init(viewModel: MatchViewModel, matchToEdit: Match? = nil) {
        self.viewModel = viewModel
        self.matchToEdit = matchToEdit
    }
    
    var isEditing: Bool {
        matchToEdit != nil
    }
    
    var body: some View {
        ZStack {
            AppGradient.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryAccent)
                    
                    Spacer()
                    
                    Text(isEditing ? "Edit Match" : "New Match")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveMatch()
                    }
                    .foregroundColor(.primaryAccent)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.cardBackground.opacity(0.1))
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Match Date")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            Button(action: { showingDatePicker = true }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.primaryAccent)
                                    Text(date.formatted(date: .abbreviated, time: .omitted))
                                        .foregroundColor(.primaryText)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondaryText)
                                }
                                .padding()
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Teams")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            CustomTextField(
                                title: "Team A",
                                text: $teamA,
                                placeholder: "Enter team A name"
                            )
                            
                            CustomTextField(
                                title: "Team B",
                                text: $teamB,
                                placeholder: "Enter team B name"
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Score")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Team A")
                                        .font(.subheadline)
                                        .foregroundColor(.secondaryText)
                                    
                                    TextField("0", text: $scoreA)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                
                                Text(":")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryText)
                                    .padding(.top, 20)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Team B")
                                        .font(.subheadline)
                                        .foregroundColor(.secondaryText)
                                    
                                    TextField("0", text: $scoreB)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Best Player (MVP)")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            Text("Optional")
                                .font(.caption)
                                .foregroundColor(.secondaryText)
                            
                            VStack {
                                TextField("Enter player name", text: $mvp)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .onChange(of: mvp) { newValue in
                                        updatePlayerSuggestions(for: newValue)
                                    }
                                
                                if showingSuggestions && !playerSuggestions.isEmpty {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(playerSuggestions, id: \.self) { suggestion in
                                            Button(action: {
                                                mvp = suggestion
                                                showingSuggestions = false
                                            }) {
                                                HStack {
                                                    Text(suggestion)
                                                        .foregroundColor(.primaryText)
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            
                                            if suggestion != playerSuggestions.last {
                                                Divider()
                                            }
                                        }
                                    }
                                    .background(Color.cardBackground)
                                    .cornerRadius(8)
                                    .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            Text("Optional")
                                .font(.caption)
                                .foregroundColor(.secondaryText)
                            
                            TextField("Add any comments about the match", text: $note, axis: .vertical)
                                .lineLimit(3...6)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $date)
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            setupInitialValues()
        }
        .onTapGesture {
            showingSuggestions = false
        }
    }
    
    private func setupInitialValues() {
        if let match = matchToEdit {
            date = match.date
            teamA = match.teamA
            teamB = match.teamB
            scoreA = String(match.scoreA)
            scoreB = String(match.scoreB)
            mvp = match.mvp ?? ""
            note = match.note ?? ""
        }
    }
    
    private func updatePlayerSuggestions(for text: String) {
        if text.isEmpty {
            showingSuggestions = false
            playerSuggestions = []
        } else {
            playerSuggestions = viewModel.getPlayerSuggestions(for: text)
            showingSuggestions = !playerSuggestions.isEmpty
        }
    }
    
    private func saveMatch() {
        guard !teamA.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Please enter Team A name")
            return
        }
        
        guard !teamB.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Please enter Team B name")
            return
        }
        
        let trimmedTeamA = teamA.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTeamB = teamB.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedTeamA.lowercased() != trimmedTeamB.lowercased() else {
            showError("Team names must be different")
            return
        }
        
        guard let scoreAInt = Int(scoreA), scoreAInt >= 0 else {
            showError("Please enter a valid score for Team A")
            return
        }
        
        guard let scoreBInt = Int(scoreB), scoreBInt >= 0 else {
            showError("Please enter a valid score for Team B")
            return
        }
        
        let mvpName = mvp.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : mvp.trimmingCharacters(in: .whitespacesAndNewlines)
        let noteText = note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingMatch = matchToEdit {
            var updatedMatch = existingMatch
            updatedMatch.date = date
            updatedMatch.teamA = trimmedTeamA
            updatedMatch.teamB = trimmedTeamB
            updatedMatch.scoreA = scoreAInt
            updatedMatch.scoreB = scoreBInt
            updatedMatch.mvp = mvpName
            updatedMatch.note = noteText
            
            viewModel.updateMatch(updatedMatch, oldMatch: existingMatch)
        } else {
            let newMatch = Match(
                date: date,
                teamA: trimmedTeamA,
                teamB: trimmedTeamB,
                scoreA: scoreAInt,
                scoreB: scoreBInt,
                mvp: mvpName,
                note: noteText
            )
            
            viewModel.addMatch(newMatch)
        }
        
        dismiss()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondaryText)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(CustomTextFieldStyle())
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondaryBackground, lineWidth: 1)
            )
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AppGradient.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Text("Select Date")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryAccent)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.cardBackground.opacity(0.1))
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AddEditMatchView(viewModel: MatchViewModel())
}
