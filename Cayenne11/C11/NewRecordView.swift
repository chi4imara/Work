import SwiftUI

struct NewRecordView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("New Record")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Track your strength workout")
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
                                selection: $viewModel.currentRecord.date,
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
                            TextField("Enter exercise name", text: $viewModel.currentRecord.exercise)
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
                            TextField("0", value: $viewModel.currentRecord.weight, format: .number)
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
                            TextField("0", value: $viewModel.currentRecord.repetitions, format: .number)
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
                            TextField("Add a comment...", text: $viewModel.currentRecord.comment, axis: .vertical)
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
                    viewModel.saveRecord()
                }) {
                    Text("Save")
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
            .padding(.bottom, 120)
        }
    }
    
    private var isFormValid: Bool {
        !viewModel.currentRecord.exercise.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        viewModel.currentRecord.weight > 0 &&
        viewModel.currentRecord.repetitions > 0
    }
}

struct CustomFormField<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(14, weight: .semibold))
                .foregroundColor(AppColors.secondaryText)
            
            content()
        }
    }
}

#Preview {
    NewRecordView(viewModel: WorkoutViewModel())
}
