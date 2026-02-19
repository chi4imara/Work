import SwiftUI

struct EditExperimentView: View {
    let experiment: Experiment
    @ObservedObject var viewModel: ExperimentViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tried: String
    @State private var changed: String
    @State private var result: String
    
    init(experiment: Experiment, viewModel: ExperimentViewModel) {
        self.experiment = experiment
        self.viewModel = viewModel
        self._tried = State(initialValue: experiment.tried)
        self._changed = State(initialValue: experiment.changed)
        self._result = State(initialValue: experiment.result)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Text("Edit Experiment")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(canSave ? Color.theme.primaryYellow : Color.gray)
                    .disabled(!canSave)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tried (X)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.primaryYellow)
                            
                            TextEditor(text: $tried)
                                .font(.ubuntu(16))
                                .foregroundColor(Color.theme.primaryText)
                                .scrollContentBackground(.hidden)
                                .padding()
                                .frame(minHeight: 100)
                                .background(Color.theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Changed (Y)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.accentPink)
                            
                            TextEditor(text: $changed)
                                .font(.ubuntu(16))
                                .foregroundColor(Color.theme.primaryText)
                                .scrollContentBackground(.hidden)
                                .padding()
                                .frame(minHeight: 100)
                                .background(Color.theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Result (Z)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.accentGreen)
                            
                            TextEditor(text: $result)
                                .font(.ubuntu(16))
                                .foregroundColor(Color.theme.primaryText)
                                .scrollContentBackground(.hidden)
                                .padding()
                                .frame(minHeight: 100)
                                .background(Color.theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: saveChanges) {
                                Text("Save Changes")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(Color.theme.buttonText)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(canSave ? Color.theme.buttonBackground : Color.gray)
                                    .cornerRadius(12)
                            }
                            .disabled(!canSave)
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(Color.theme.secondaryButtonText)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.theme.secondaryButtonBackground)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var canSave: Bool {
        !tried.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !changed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveChanges() {
        guard canSave else { return }
        
        viewModel.updateExperiment(
            experiment,
            tried: tried.trimmingCharacters(in: .whitespacesAndNewlines),
            changed: changed.trimmingCharacters(in: .whitespacesAndNewlines),
            result: result.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditExperimentView(
        experiment: Experiment(tried: "Sample tried", changed: "Sample changed", result: "Sample result"),
        viewModel: ExperimentViewModel()
    )
}
