import SwiftUI

struct AddExperimentView: View {
    @ObservedObject var viewModel: ExperimentViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tried = ""
    @State private var changed = ""
    @State private var result = ""
    
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
                    
                    Text("New Experiment")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveExperiment()
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
                            Button(action: saveExperiment) {
                                Text("Save")
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
    
    private func saveExperiment() {
        guard canSave else { return }
        
        viewModel.addExperiment(
            tried: tried.trimmingCharacters(in: .whitespacesAndNewlines),
            changed: changed.trimmingCharacters(in: .whitespacesAndNewlines),
            result: result.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddExperimentView(viewModel: ExperimentViewModel())
}
