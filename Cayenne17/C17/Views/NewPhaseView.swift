import SwiftUI

struct NewPhaseView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPhaseType: PhaseType = .mass
    @State private var startDate = Date()
    @State private var comment = ""
    @State private var showingPhaseCreated = false
    @State private var createdPhase: Phase?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("New Phase")
                        .font(.playfairDisplay(.bold, size: 32))
                        .foregroundColor(AppColors.white)
                        .padding(.vertical, 20)
                    
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
                        
                        Button(action: createPhase) {
                            Text("Create Phase")
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
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showingPhaseCreated) {
            if let phase = createdPhase {
                PhaseCreatedView(phase: phase) {
                    showingPhaseCreated = false
                    resetForm()
                }
            }
        }
    }
    
    private func createPhase() {
        let newPhase = Phase(
            name: selectedPhaseType,
            startDate: startDate,
            comment: comment
        )
        
        appState.addPhase(newPhase)
        createdPhase = newPhase
        showingPhaseCreated = true
    }
    
    private func resetForm() {
        selectedPhaseType = .mass
        startDate = Date()
        comment = ""
        createdPhase = nil
    }
}

#Preview {
    NewPhaseView()
        .environmentObject(AppState())
}
