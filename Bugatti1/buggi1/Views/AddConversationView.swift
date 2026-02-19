import SwiftUI

struct AddConversationView: View {
    @ObservedObject var viewModel: ConversationViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var personName = ""
    @State private var topic = ""
    @State private var outcome = ""
    @State private var isAnimating = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case personName, topic, outcome
    }
    
    private var isFormValid: Bool {
        !personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !outcome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: AppSpacing.lg) {
                            CustomTextField(
                                title: "Who did you talk to",
                                text: $personName,
                                placeholder: "Enter person name or identifier",
                                isAnimating: isAnimating,
                                animationDelay: 0.2
                            )
                            .focused($focusedField, equals: .personName)
                            .onSubmit {
                                focusedField = .topic
                            }
                            
                            CustomTextField(
                                title: "Conversation topic",
                                text: $topic,
                                placeholder: "What was the conversation about?",
                                isAnimating: isAnimating,
                                animationDelay: 0.4
                            )
                            .focused($focusedField, equals: .topic)
                            .onSubmit {
                                focusedField = .outcome
                            }
                            
                            CustomTextField(
                                title: "Outcome",
                                text: $outcome,
                                placeholder: "One line summary of the result",
                                isAnimating: isAnimating,
                                animationDelay: 0.6
                            )
                            .focused($focusedField, equals: .outcome)
                            .onSubmit {
                                if isFormValid {
                                    saveConversation()
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.lg)
                    }
                    
                    actionButtons
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .personName
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(AppFonts.button())
                .foregroundColor(AppColors.textSecondary)
                
                Spacer()
                
                Text("New Entry")
                    .font(AppFonts.title(20))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("Save") {
                    saveConversation()
                }
                .font(AppFonts.button())
                .foregroundColor(isFormValid ? AppColors.secondary : AppColors.textTertiary)
                .disabled(!isFormValid)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            
            Divider()
                .background(AppColors.textTertiary)
        }
        .offset(y: isAnimating ? 0 : -50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8), value: isAnimating)
    }
    
    private var actionButtons: some View {
        VStack(spacing: AppSpacing.md) {
            Divider()
                .background(AppColors.textTertiary)
            
            HStack(spacing: AppSpacing.md) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(AppFonts.button())
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                .stroke(AppColors.textTertiary, lineWidth: 1)
                        )
                }
                
                Button {
                    saveConversation()
                } label: {
                    Text("Save")
                        .font(AppFonts.button())
                        .foregroundColor(AppColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                .fill(isFormValid ? AppColors.secondary : AppColors.textTertiary)
                        )
                }
                .disabled(!isFormValid)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.lg)
        }
        .offset(y: isAnimating ? 0 : 100)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.8), value: isAnimating)
    }
    
    private func saveConversation() {
        let trimmedPersonName = personName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTopic = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedOutcome = outcome.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.addConversation(
            personName: trimmedPersonName,
            topic: trimmedTopic,
            outcome: trimmedOutcome
        )
        
        dismiss()
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let isAnimating: Bool
    let animationDelay: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(AppFonts.headline(16))
                .foregroundColor(AppColors.textPrimary)
            
            TextField(placeholder, text: $text)
                .font(AppFonts.body())
                .foregroundColor(AppColors.textPrimary)
                .padding(AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                )
        }
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(animationDelay), value: isAnimating)
    }
}

#Preview {
    AddConversationView(viewModel: ConversationViewModel())
}
