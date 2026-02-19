import SwiftUI

struct EditPhaseView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let phase: Phase
    
    @State private var selectedPhaseType: PhaseType
    @State private var startDate: Date
    @State private var comment: String
    
    init(phase: Phase) {
        self.phase = phase
        self._selectedPhaseType = State(initialValue: phase.name)
        self._startDate = State(initialValue: phase.startDate)
        self._comment = State(initialValue: phase.comment)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.playfairDisplay(.medium, size: 16))
                        .foregroundColor(AppColors.lightBlue)
                        
                        Spacer()
                        
                        Text("Edit Phase")
                            .font(.playfairDisplay(.bold, size: 24))
                            .foregroundColor(AppColors.white)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveChanges()
                        }
                        .font(.playfairDisplay(.medium, size: 16))
                        .foregroundColor(AppColors.orange)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Phase Name")
                                .font(.playfairDisplay(.medium, size: 18))
                                .foregroundColor(AppColors.white)
                            
                            Menu {
                                ForEach(PhaseType.allCases) { phaseType in
                                    Button(phaseType.rawValue) {
                                        selectedPhaseType = phaseType
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedPhaseType.rawValue)
                                        .font(.playfairDisplay(.regular, size: 16))
                                        .foregroundColor(AppColors.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.lightBlue)
                                }
                                .padding()
                                .background(AppColors.cardGradient)
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Start Date")
                                .font(.playfairDisplay(.medium, size: 18))
                                .foregroundColor(AppColors.white)
                            
                            DatePicker("", selection: $startDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                                .padding()
                                .background(AppColors.cardGradient)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Comment")
                                .font(.playfairDisplay(.medium, size: 18))
                                .foregroundColor(AppColors.white)
                            
                            TextField("Enter comment (optional)", text: $comment, axis: .vertical)
                                .font(.playfairDisplay(.regular, size: 16))
                                .foregroundColor(AppColors.white)
                                .padding()
                                .background(AppColors.cardGradient)
                                .cornerRadius(12)
                                .lineLimit(3...6)
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.playfairDisplay(.semiBold, size: 18))
                                .foregroundColor(AppColors.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.orange)
                                .cornerRadius(25)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private func saveChanges() {
        var updatedPhase = phase
        updatedPhase.name = selectedPhaseType
        updatedPhase.startDate = startDate
        updatedPhase.comment = comment
        
        appState.updatePhase(updatedPhase)
        dismiss()
    }
}

#Preview {
    EditPhaseView(phase: Phase(name: .mass, startDate: Date(), comment: "Test comment"))
        .environmentObject(AppState())
}
