import SwiftUI

struct AddTermView: View {
    let dataManager: TermsDataManager
    
    @Environment(\.presentationMode) var presentationMode
    @State private var termName = ""
    @State private var explanation = ""
    @FocusState private var isTermNameFocused: Bool
    @FocusState private var isExplanationFocused: Bool
    
    private var isValidInput: Bool {
        !termName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !explanation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.accentYellow)
                    
                    Spacer()
                    
                    Text("New term")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveTerm()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(isValidInput ? AppColors.accentYellow : AppColors.secondaryText)
                    .disabled(!isValidInput)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Term")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter term name", text: $termName)
                                .textFieldStyle(.primary)
                                .focused($isTermNameFocused)
                                .submitLabel(.next)
                                .onSubmit {
                                    isExplanationFocused = true
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Explanation")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 1)
                                    )
                                    .frame(minHeight: 120)
                                
                                TextEditor(text: $explanation)
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.primaryText)
                                    .background(Color.clear)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .focused($isExplanationFocused)
                                    .scrollContentBackground(.hidden)
                                
                                if explanation.isEmpty {
                                    Text("Enter your explanation")
                                        .font(.ubuntu(16))
                                        .foregroundColor(AppColors.placeholderText)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 20)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            isTermNameFocused = true
        }
    }
    
    private func saveTerm() {
        let trimmedName = termName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedExplanation = explanation.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty && !trimmedExplanation.isEmpty else { return }
        
        let newTerm = Term(name: trimmedName, explanation: trimmedExplanation)
        dataManager.addTerm(newTerm)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddTermView(dataManager: TermsDataManager())
}
