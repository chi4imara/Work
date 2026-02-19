import SwiftUI

struct AddEnergyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: Date
    @State private var energyLevel: Double
    @State private var mood: String

    let onSave: (EnergyData) -> Void
    let onDismiss: (() -> Void)?
    let editingData: EnergyData?

    init(editingData: EnergyData? = nil, onSave: @escaping (EnergyData) -> Void, onDismiss: (() -> Void)? = nil) {
        self.editingData = editingData
        self.onSave = onSave
        self.onDismiss = onDismiss
        _selectedDate = State(initialValue: editingData?.date ?? Date())
        _energyLevel = State(initialValue: editingData?.energyLevel ?? 5)
        _mood = State(initialValue: editingData?.mood ?? "")
    }

    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.primaryBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Date")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)

                            DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(AppColors.accentYellow)
                                .colorScheme(.dark)
                        }

                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Energy Level: \(Int(energyLevel))")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)

                            Slider(value: $energyLevel, in: 1...10, step: 1)
                                .accentColor(AppColors.accentYellow)
                        }

                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Mood (optional)")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)

                            TextField("e.g. Focused, Relaxed", text: $mood)
                                .textFieldStyle(CustomTextFieldStyle())
                        }

                        Button(action: saveEnergy) {
                            Text("Save")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: AppRadius.medium)
                                        .fill(AppColors.accentYellow)
                                )
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle(editingData == nil ? "Add Energy Entry" : "Edit Energy Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss?()
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .onDisappear {
            onDismiss?()
        }
    }

    private func saveEnergy() {
        let data = EnergyData(
            id: editingData?.id ?? UUID(),
            date: selectedDate,
            energyLevel: energyLevel,
            mood: mood.isEmpty ? "Not specified" : mood
        )
        onSave(data)
        onDismiss?()
        dismiss()
    }
}

#Preview {
    AddEnergyView { _ in }
}
