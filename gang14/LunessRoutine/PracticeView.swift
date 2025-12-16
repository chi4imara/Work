import SwiftUI

struct PracticeView: View {
    @StateObject private var viewModel: PracticeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAbout = false
    @State private var showingRestartAlert = false
    @State private var showingCompletion = false
    
    let onComplete: () -> Void
    
    let action: () -> Void
    
    init(isRepeat: Bool = false, onComplete: @escaping () -> Void, action: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: PracticeViewModel(isRepeat: isRepeat))
        self.onComplete = onComplete
        self.action = action
    }
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 0) {
                headerSection
                
                Spacer()
                
                stepContentSection
                
                Spacer()
                
                progressSection
                
                actionButtonSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .sheet(isPresented: $showingAbout) {
            StatisticsView()
        }
        .sheet(isPresented: $showingCompletion) {
            CompletionView(
                completionDate: Date(),
                isRepeatSession: viewModel.isRepeatSession,
                completionCount: 1,
                onReturnHome: {
                    onComplete()
                    dismiss()
                },
                onRepeatPractice: {
                    viewModel.restartPractice()
                }
            )
        }
        .alert("Start Over", isPresented: $showingRestartAlert) {
            Button("Yes") {
                viewModel.restartPractice()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to restart the practice from the beginning?")
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(ColorTheme.lightBlue.opacity(0.2))
                    )
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Practice \"Let Go of the Day\"")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                if viewModel.isRepeatSession {
                    Text("Repeat Session")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.textLight)
                }
            }
            
            Spacer()
            
            Menu {
                Button("Start Over") {
                    showingRestartAlert = true
                }
                Button("Statistics") {
                    action()
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(ColorTheme.lightBlue.opacity(0.2))
                    )
            }
        }
    }
    
    private var stepContentSection: some View {
        VStack(spacing: 32) {
            Text("Step \(viewModel.currentStep)")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryYellow)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.primaryYellow.opacity(0.2))
                )
            
            Text(viewModel.currentStepData.title)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(viewModel.currentStepData.description)
                .font(.ubuntu(18, weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 12, x: 0, y: 6)
        )
    }
    
    private var progressSection: some View {
        HStack(spacing: 16) {
            ForEach(0..<viewModel.progressDots.count, id: \.self) { index in
                Circle()
                    .fill(viewModel.progressDots[index] ? ColorTheme.primaryBlue : ColorTheme.lightBlue.opacity(0.4))
                    .frame(width: 12, height: 12)
                    .scaleEffect(viewModel.progressDots[index] ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.progressDots[index])
            }
        }
        .padding(.bottom, 40)
    }
    
    private var actionButtonSection: some View {
        Button(action: {
            if viewModel.isLastStep {
                showingCompletion = true
            } else {
                viewModel.nextStep()
            }
        }) {
            HStack(spacing: 12) {
                if !viewModel.canProceed {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: ColorTheme.backgroundWhite))
                        .scaleEffect(0.8)
                }
                
                Text(viewModel.isLastStep ? "Complete Practice" : "Next")
                    .font(.ubuntu(18, weight: .medium))
            }
            .foregroundColor(ColorTheme.backgroundWhite)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        viewModel.canProceed ?
                        LinearGradient(
                            colors: [ColorTheme.primaryBlue, ColorTheme.accentPurple],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            colors: [ColorTheme.textLight, ColorTheme.textLight],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(
                color: viewModel.canProceed ? ColorTheme.primaryBlue.opacity(0.3) : Color.clear,
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(!viewModel.canProceed)
        .animation(.easeInOut(duration: 0.3), value: viewModel.canProceed)
    }
}


