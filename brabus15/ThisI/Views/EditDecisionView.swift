import SwiftUI

struct EditDecisionView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let decisionId: UUID
    
    @State private var selectedDate: Date
    @State private var situation: String
    @State private var chosenOption: String
    @State private var showingDatePicker = false
    
    private var decision: Decision? {
        viewModel.getDecision(byId: decisionId)
    }
    
    init(decisionId: UUID) {
        self.decisionId = decisionId
        self._selectedDate = State(initialValue: Date())
        self._situation = State(initialValue: "")
        self._chosenOption = State(initialValue: "")
    }
    
    private var isFormValid: Bool {
        !situation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !chosenOption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        guard let currentDecision = decision else { return false }
        return selectedDate != currentDecision.date ||
        situation != currentDecision.situation ||
        chosenOption != currentDecision.chosenOption
    }
    
    var body: some View {
        Group {
            if let currentDecision = decision {
                ZStack {
                    AnimatedBackground()
                    
                    VStack(spacing: 0) {
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                            
                            Spacer()
                            
                            Text("Edit Decision")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.primaryText)
                            
                            Spacer()
                            
                            Button("Save Changes") {
                                saveChanges()
                            }
                            .font(DesignSystem.Typography.body)
                            .foregroundColor((isFormValid && hasChanges) ? DesignSystem.Colors.yellow : DesignSystem.Colors.secondaryText)
                            .disabled(!isFormValid || !hasChanges)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, 20)
                        
                        ScrollView {
                            VStack(spacing: DesignSystem.Spacing.lg) {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                    Text("Date")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                    
                                    Button(action: { showingDatePicker = true }) {
                                        HStack {
                                            Text(selectedDate, style: .date)
                                                .font(DesignSystem.Typography.body)
                                                .foregroundColor(DesignSystem.Colors.primaryText)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "calendar")
                                                .foregroundColor(DesignSystem.Colors.yellow)
                                        }
                                        .padding(DesignSystem.Spacing.md)
                                        .background(DesignSystem.Colors.cardBackground)
                                        .cornerRadius(DesignSystem.CornerRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                    Text("Situation")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                    
                                    CustomTextEditor(
                                        text: $situation,
                                        placeholder: "Describe the situation where you had to make a choice..."
                                    )
                                    .frame(minHeight: 100)
                                }
                                
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                    Text("Chosen Option")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                    
                                    CustomTextEditor(
                                        text: $chosenOption,
                                        placeholder: "What option did you choose?"
                                    )
                                    .frame(minHeight: 80)
                                }
                                
                                Spacer(minLength: DesignSystem.Spacing.xxl)
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            .padding(.top, DesignSystem.Spacing.lg)
                        }
                    }
                }
                .sheet(isPresented: $showingDatePicker) {
                    DatePickerView(selectedDate: $selectedDate)
                }
                .onAppear {
                    selectedDate = currentDecision.date
                    situation = currentDecision.situation
                    chosenOption = currentDecision.chosenOption
                }
            } else {
                Text("Decision not found")
                    .foregroundColor(DesignSystem.Colors.primaryText)
            }
        }
    }
    
    private func saveChanges() {
        guard let currentDecision = decision else { return }
        var updatedDecision = currentDecision
        updatedDecision.date = selectedDate
        updatedDecision.situation = situation.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedDecision.chosenOption = chosenOption.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateDecision(updatedDecision)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let viewModel = DecisionViewModel()
    let testDecision = Decision(situation: "Should I take the new job offer?", chosenOption: "Accept the offer and start next month")
    viewModel.addDecision(testDecision)
    return EditDecisionView(decisionId: testDecision.id)
        .environmentObject(viewModel)
}
