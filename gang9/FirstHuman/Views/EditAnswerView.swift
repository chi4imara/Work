import SwiftUI

struct EditAnswerView: View {
    let answer: DailyAnswer
    let onSave: (DailyAnswer) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var editedText: String
    @State private var showSaveAlert = false
    @State private var hasChanges = false
    
    init(answer: DailyAnswer, onSave: @escaping (DailyAnswer) -> Void) {
        self.answer = answer
        self.onSave = onSave
        self._editedText = State(initialValue: answer.answer)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Question")
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(answer.questionText)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                    }
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Answer")
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                        
                        TextEditor(text: $editedText)
                            .font(.playfairDisplay(16, weight: .regular))
                            .foregroundColor(AppColors.textPrimary)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .frame(minHeight: 200)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                    }
                            )
                            .onChange(of: editedText) { newValue in
                                hasChanges = newValue.trimmingCharacters(in: .whitespacesAndNewlines) != answer.answer.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Edit Answer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if hasChanges {
                            showSaveAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(hasChanges ? AppColors.primaryBlue : AppColors.textSecondary)
                    .disabled(editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("Save Changes", isPresented: $showSaveAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save", role: .none) {
                let updatedAnswer = DailyAnswer(
                    id: answer.id,
                    questionId: answer.questionId,
                    questionText: answer.questionText,
                    answer: editedText,
                    date: answer.date,
                    createdAt: answer.createdAt
                )
                onSave(updatedAnswer)
            }
        } message: {
            Text("Are you sure you want to save the changes to this answer?")
        }
    }
}

#Preview {
    EditAnswerView(
        answer: DailyAnswer(
            questionId: UUID(),
            questionText: "What brings you peace?",
            answer: "This is a sample answer that can be edited.",
            date: Date(),
            createdAt: Date()
        ),
        onSave: { _ in }
    )
}
