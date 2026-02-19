import SwiftUI

struct AddDecisionView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate = Date()
    @State private var situation = ""
    @State private var chosenOption = ""
    @State private var showingDatePicker = false
    
    @Binding var selectedTab: Int
    
    private var isFormValid: Bool {
        !situation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !chosenOption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("New Decision")
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(DesignSystem.Colors.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveDecision()
                    }
                    .font(DesignSystem.Typography.largeTitle)
                    .foregroundColor(isFormValid ? DesignSystem.Colors.yellow : DesignSystem.Colors.secondaryText)
                    .disabled(!isFormValid)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
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
                    .padding(.vertical, DesignSystem.Spacing.lg)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
    }
    
    private func saveDecision() {
        let decision = Decision(
            date: selectedDate,
            situation: situation.trimmingCharacters(in: .whitespacesAndNewlines),
            chosenOption: chosenOption.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addDecision(decision)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
            selectedDate = Date()
            situation = ""
            chosenOption = ""
            showingDatePicker = false
        }
    }
}

struct CustomTextEditor: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(DesignSystem.Colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                )
            
            if text.isEmpty {
                Text(placeholder)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.placeholderText)
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.vertical, DesignSystem.Spacing.sm + 4)
            }
            
            TextEditor(text: $text)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.primaryText)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, DesignSystem.Spacing.sm)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(Color.clear)
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .colorScheme(.dark)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(DesignSystem.Colors.yellow)
            )
        }
    }
}
