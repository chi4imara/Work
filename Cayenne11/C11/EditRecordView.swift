import SwiftUI

struct EditRecordView: View {
    let record: WorkoutRecord
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var editedRecord: WorkoutRecord
    
    init(record: WorkoutRecord, viewModel: WorkoutViewModel) {
        self.record = record
        self.viewModel = viewModel
        self._editedRecord = State(initialValue: record)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        AppColors.deepBlue,
                        AppColors.darkBlue
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Edit Record")
                                .font(.playfairDisplay(32, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Update your workout details")
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            CustomFormField(
                                title: "Date",
                                content: {
                                    DatePicker(
                                        "",
                                        selection: $editedRecord.date,
                                        displayedComponents: .date
                                    )
                                    .colorInvert()
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(AppColors.border, lineWidth: 1)
                                            )
                                    )
                                }
                            )
                            
                            CustomFormField(
                                title: "Exercise",
                                content: {
                                    TextField("Enter exercise name", text: $editedRecord.exercise)
                                        .font(.playfairDisplay(16, weight: .medium))
                                        .foregroundColor(AppColors.primaryText)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppColors.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppColors.border, lineWidth: 1)
                                                )
                                        )
                                }
                            )
                            
                            CustomFormField(
                                title: "Weight (kg)",
                                content: {
                                    TextField("0", value: $editedRecord.weight, format: .number)
                                        .font(.playfairDisplay(16, weight: .medium))
                                        .foregroundColor(AppColors.primaryText)
                                        .keyboardType(.decimalPad)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppColors.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppColors.border, lineWidth: 1)
                                                )
                                        )
                                }
                            )
                            
                            CustomFormField(
                                title: "Repetitions",
                                content: {
                                    TextField("0", value: $editedRecord.repetitions, format: .number)
                                        .font(.playfairDisplay(16, weight: .medium))
                                        .foregroundColor(AppColors.primaryText)
                                        .keyboardType(.numberPad)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppColors.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppColors.border, lineWidth: 1)
                                                )
                                        )
                                }
                            )
                            
                            CustomFormField(
                                title: "Comment (optional)",
                                content: {
                                    TextField("Add a comment...", text: $editedRecord.comment, axis: .vertical)
                                        .font(.playfairDisplay(16, weight: .medium))
                                        .foregroundColor(AppColors.primaryText)
                                        .lineLimit(3...6)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppColors.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppColors.border, lineWidth: 1)
                                                )
                                        )
                                }
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        Button(action: {
                            viewModel.updateRecord(editedRecord)
                            dismiss()
                        }) {
                            Text("Save Changes")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            isFormValid ? AppColors.lightBlue : AppColors.secondaryText.opacity(0.3)
                                        )
                                )
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(AppColors.lightBlue)
            )
        }
    }
    
    private var isFormValid: Bool {
        !editedRecord.exercise.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        editedRecord.weight > 0 &&
        editedRecord.repetitions > 0
    }
}

#Preview {
    EditRecordView(
        record: WorkoutRecord(
            date: Date(),
            exercise: "Bench Press",
            weight: 80,
            repetitions: 8,
            comment: "Felt strong today!"
        ),
        viewModel: WorkoutViewModel()
    )
}
