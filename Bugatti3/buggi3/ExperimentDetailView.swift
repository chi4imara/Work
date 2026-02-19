import SwiftUI

struct ExperimentDetailView: View {
    let experimentId: UUID
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ExperimentViewModel
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var experiment: Experiment? {
        viewModel.experiment(byId: experimentId)
    }
    
    var body: some View {
        Group {
            if let experiment = experiment {
                detailContent(experiment: experiment)
            } else {
                emptyOrDeletedView
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let experiment = viewModel.experiment(byId: experimentId) {
                EditExperimentView(experiment: experiment, viewModel: viewModel)
            }
        }
        .alert("Delete Experiment", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteExperiment(byId: experimentId)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this experiment? This action cannot be undone.")
        }
    }
    
    private func detailContent(experiment: Experiment) -> some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Text("Experiment")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Button("Edit") {
                        showingEditView = true
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryYellow)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tried (X)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.primaryYellow)
                            
                            Text(experiment.tried)
                                .font(.ubuntu(18))
                                .foregroundColor(Color.theme.primaryText)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Changed (Y)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.accentPink)
                            
                            Text(experiment.changed)
                                .font(.ubuntu(18))
                                .foregroundColor(Color.theme.primaryText)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Result (Z)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.accentGreen)
                            
                            Text(experiment.result)
                                .font(.ubuntu(18))
                                .foregroundColor(Color.theme.primaryText)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                Text("Edit")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(Color.theme.buttonText)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.theme.buttonBackground)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Text("Delete")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.theme.destructive)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var emptyOrDeletedView: some View {
        ZStack {
            AnimatedBackground()
            VStack(spacing: 20) {
                Text("Experiment not found.")
                    .font(.ubuntu(18))
                    .foregroundColor(Color.theme.primaryText)
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.primaryYellow)
            }
        }
    }
}

#Preview {
    ExperimentDetailView(experimentId: UUID())
        .environmentObject(ExperimentViewModel())
}
