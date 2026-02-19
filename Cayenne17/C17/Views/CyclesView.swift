import SwiftUI

struct CyclesView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPhase: Phase?
    @State private var showingPhaseDetails = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Cycles")
                    .font(.playfairDisplay(.bold, size: 32))
                    .foregroundColor(AppColors.white)
                    .padding(.top, 20)
                
                if appState.phases.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "repeat.circle")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.lightBlue.opacity(0.6))
                        
                        Text("Phases not created yet.")
                            .font(.playfairDisplay(.medium, size: 18))
                            .foregroundColor(AppColors.white.opacity(0.7))
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(appState.phases) { phase in
                                PhaseCard(phase: phase) {
                                    selectedPhase = phase
                                    showingPhaseDetails = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedPhase) { phase in
            PhaseDetailsView(phase: phase)
        }
    }
}

struct PhaseCard: View {
    let phase: Phase
    let onOpen: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(phase.name.rawValue)
                        .font(.playfairDisplay(.semiBold, size: 20))
                        .foregroundColor(AppColors.white)
                    
                    Text("Started: \(phase.startDate, style: .date)")
                        .font(.playfairDisplay(.regular, size: 14))
                        .foregroundColor(AppColors.lightBlue)
                    
                    if !phase.comment.isEmpty {
                        Text(phase.comment)
                            .font(.playfairDisplay(.regular, size: 14))
                            .foregroundColor(AppColors.white.opacity(0.8))
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("\(phase.workouts.count)")
                        .font(.playfairDisplay(.bold, size: 24))
                        .foregroundColor(AppColors.orange)
                    
                    Text("Workouts")
                        .font(.playfairDisplay(.regular, size: 12))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
            }
            
            Button(action: onOpen) {
                Text("Open")
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(AppColors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(AppColors.lightBlue)
                    .cornerRadius(20)
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CyclesView()
        .environmentObject(AppState())
}
