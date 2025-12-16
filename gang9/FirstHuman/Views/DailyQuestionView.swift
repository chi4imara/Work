import SwiftUI

struct DailyQuestionView: View {
    @StateObject private var viewModel = QuestionViewModel()
    @State private var showMenu = false
    @State private var showSettings = false
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Question of the Day")
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showMenu.toggle() }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                            .rotationEffect(.degrees(90))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        if let question = viewModel.currentDailyQuestion {
                            VStack(spacing: 20) {
                                Text(question.text)
                                    .font(.playfairDisplay(22, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                
                                Text("A new question appears every day")
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
                                    TextEditor(text: $viewModel.answerText)
                                        .font(.playfairDisplay(16, weight: .regular))
                                        .foregroundColor(AppColors.textPrimary)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.clear)
                                        .frame(minHeight: 120)
                                        .disabled(viewModel.isAnswerSaved)
                                        .overlay(
                                            Group {
                                                if viewModel.answerText.isEmpty && !viewModel.isAnswerSaved {
                                                    VStack {
                                                        HStack {
                                                            Text("Write what you feel...")
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
                                
                                if viewModel.isAnswerSaved {
                                    VStack(spacing: 8) {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(AppColors.accentGreen)
                                            Text("Answer saved")
                                                .font(.playfairDisplay(14, weight: .medium))
                                                .foregroundColor(AppColors.accentGreen)
                                        }
                                        
                                        if let answer = viewModel.todaysAnswer {
                                            Text("Answer recorded today at \(formatTime(answer.createdAt))")
                                                .font(.playfairDisplay(12, weight: .regular))
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                    }
                                } else {
                                    Button(action: viewModel.saveAnswer) {
                                        Text("Save Answer")
                                            .font(.playfairDisplay(16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(viewModel.canSaveAnswer() ? AnyShapeStyle(AppGradients.buttonGradient) : AnyShapeStyle(Color.gray.opacity(0.3)))
                                            )
                                    }
                                    .disabled(!viewModel.canSaveAnswer())
                                }
                            }
                            .padding(.horizontal, 20)
                            
                        } else {
                            EmptyQuestionState {
                                viewModel.loadTodaysQuestion()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 50)
                        }
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 12) {
                                Text("Daily Inspiration")
                                    .font(.playfairDisplay(18, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                VStack(spacing: 8) {
                                    Text("\"Sometimes silence speaks louder than words.\"")
                                        .font(.playfairDisplayItalic(16, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(2)
                                    
                                    Text("— Daily Reflection")
                                        .font(.playfairDisplay(14, weight: .regular))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .padding(.horizontal, 30)
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.6))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                        }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            viewModel.resetForNewDay()
        }
        .sheet(isPresented: $showMenu) {
            MenuSheet(showSettings: $showSettings, selectedTab: $selectedTab)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct EmptyQuestionState: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "book.closed")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 16) {
                Text("Every day — a new question for reflection")
                    .font(.playfairDisplay(20, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Button(action: action) {
                    Text("See the first question")
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

struct MenuSheet: View {
    @Binding var showSettings: Bool
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                MenuButton(title: "Question History", icon: "clock") {
                    withAnimation {
                        selectedTab = 2
                    }
                    dismiss()
                }
                
                MenuButton(title: "My Notes", icon: "note.text") {
                    withAnimation {
                        selectedTab = 3
                    }
                    dismiss()
                }
                
                MenuButton(title: "Settings", icon: "gear") {
                    withAnimation {
                        selectedTab = 4
                    }
                    dismiss()
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.height(300)])
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
                    }
            )
        }
    }
}

struct QuickActionButton: View {
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
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
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
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DailyQuestionView(selectedTab: .constant(0))
}
