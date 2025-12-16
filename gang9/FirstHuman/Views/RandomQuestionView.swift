import SwiftUI
import Combine

struct RandomQuestionView: View {
    @StateObject private var viewModel = RandomQuestionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    .opacity(0)
                    .disabled(true)
                    
                    Spacer()
                    
                    Text("Random Question")
                        .font(.playfairDisplay(20, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: viewModel.loadNewRandomQuestion) {
                        Image(systemName: "shuffle")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        if let question = viewModel.currentQuestion {
                            VStack(spacing: 20) {
                                Text(question.text)
                                    .font(.playfairDisplay(22, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                
                                Text("Not related to the question of the day")
                                    .font(.playfairDisplay(14, weight: .regular))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 40)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppGradients.cardGradient)
                                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 30)
                            
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 12) {
                                    TextEditor(text: $viewModel.noteText)
                                        .font(.playfairDisplay(16, weight: .regular))
                                        .foregroundColor(AppColors.textPrimary)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.clear)
                                        .frame(minHeight: 120)
                                        .overlay(
                                            Group {
                                                if viewModel.noteText.isEmpty {
                                                    VStack {
                                                        HStack {
                                                            Text("Write what came to mind...")
                                                                .font(.playfairDisplay(16, weight: .regular))
                                                                .foregroundColor(AppColors.textLight)
                                                            Spacer()
                                                        }
                                                        Spacer()
                                                    }
                                                    .padding(.top, 8)
                                                    .padding(.leading, 5)
                                                }
                                            }
                                        )
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                        }
                                )
                                
                                Button(action: viewModel.saveNote) {
                                    Text("Save Note")
                                        .font(.playfairDisplay(16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(viewModel.canSaveNote() ? AnyShapeStyle(AppGradients.buttonGradient) : AnyShapeStyle(Color.gray.opacity(0.3)))
                                        )
                                }
                                .disabled(!viewModel.canSaveNote())
                                
                                if viewModel.showSaveConfirmation {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(AppColors.accentGreen)
                                        Text("Note saved!")
                                            .font(.playfairDisplay(14, weight: .medium))
                                            .foregroundColor(AppColors.accentGreen)
                                    }
                                    .transition(.opacity.combined(with: .scale))
                                }
                            }
                            .padding(.horizontal, 20)
                            
                        } else {
                            EmptyRandomQuestionState {
                                viewModel.loadNewRandomQuestion()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 50)
                        }
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 12) {
                                Text("Reflection Tips")
                                    .font(.playfairDisplay(18, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                VStack(spacing: 16) {
                                    ReflectionTipCard(
                                        icon: "brain.head.profile",
                                        title: "Free Writing",
                                        description: "Write without stopping or editing. Let your thoughts flow naturally.",
                                        color: AppColors.primaryBlue
                                    )
                                    
                                    ReflectionTipCard(
                                        icon: "heart",
                                        title: "Emotional Check",
                                        description: "Notice what emotions arise as you reflect on the question.",
                                        color: AppColors.accentPink
                                    )
                                    
                                    ReflectionTipCard(
                                        icon: "leaf",
                                        title: "Mindful Pause",
                                        description: "Take a moment to breathe and center yourself before writing.",
                                        color: AppColors.accentGreen
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadNewRandomQuestion()
        }
    }
}

struct EmptyRandomQuestionState: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "shuffle.circle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 16) {
                Text("Random questions are over. Try again later.")
                    .font(.playfairDisplay(20, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Button(action: action) {
                    Text("Get Question")
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 14)
                        .background(AppGradients.buttonGradient)
                        .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal, 40)
    }
}

@MainActor
class RandomQuestionViewModel: ObservableObject {
    @Published var currentQuestion: Question?
    @Published var noteText = ""
    @Published var showSaveConfirmation = false
    
    private let dataManager = DataManager.shared
    
    func loadNewRandomQuestion() {
        currentQuestion = dataManager.getRandomQuestion()
    }
    
    func saveNote() {
        guard !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let note = PersonalNote(
            content: noteText,
            createdAt: Date(),
            updatedAt: Date(),
            isFromRandomQuestion: true
        )
        
        dataManager.savePersonalNote(note)
        noteText = ""
        showSaveConfirmation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showSaveConfirmation = false
        }
    }
    
    func canSaveNote() -> Bool {
        return !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct ReflectionTipCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(description)
                    .font(.playfairDisplay(12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                }
        )
    }
}

struct NavigationSuggestionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.playfairDisplay(11, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RandomQuestionView()
}
