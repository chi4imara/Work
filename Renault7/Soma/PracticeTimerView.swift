import SwiftUI

struct PracticeTimerView: View {
    let practice: DailyPractice
    let onComplete: () -> Void
    
    @State private var timeRemaining: Int = 0
    @State private var isActive = false
    @State private var timer: Timer?
    @State private var progress: Double = 0
    @State private var isCompleted = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text(practice.title)
                        .font(.playfair(24, weight: .bold))
                        .foregroundColor(ColorTheme.textColor)
                        .multilineTextAlignment(.center)
                    
                    Text(practice.description)
                        .font(.playfair(16))
                        .foregroundColor(ColorTheme.secondaryColor)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.secondaryColor.opacity(0.3), lineWidth: 12)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            ColorTheme.accentColor,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.1), value: progress)
                    
                    VStack(spacing: 8) {
                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(ColorTheme.accentColor)
                        } else {
                            Text(timeString(from: timeRemaining))
                                .font(.playfair(32, weight: .bold))
                                .foregroundColor(ColorTheme.textColor)
                        }
                        
                        Text(isCompleted ? "Complete!" : (isActive ? "Breathing..." : "Ready"))
                            .font(.playfair(16))
                            .foregroundColor(ColorTheme.secondaryColor)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    if isCompleted {
                        Text("Your body is grateful for the care")
                            .font(.playfair(18, weight: .medium))
                            .foregroundColor(ColorTheme.accentColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    } else {
                        if isActive {
                            BreathingGuide()
                        }
                    }
                    
                    HStack(spacing: 20) {
                        if isCompleted {
                            Button("Done") {
                                onComplete()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        } else {
                            Button(isActive ? "Pause" : "Start") {
                                if isActive {
                                    pauseTimer()
                                } else {
                                    startTimer()
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            
                            Button("Skip") {
                                completeSession()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            setupTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func setupTimer() {
        let minutes = Int(practice.duration.components(separatedBy: " ").first ?? "5") ?? 5
        timeRemaining = minutes * 60
    }
    
    private func startTimer() {
        isActive = true
        let totalTime = timeRemaining
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = Double(totalTime - timeRemaining) / Double(totalTime)
            } else {
                completeSession()
            }
        }
    }
    
    private func pauseTimer() {
        isActive = false
        timer?.invalidate()
    }
    
    private func completeSession() {
        isActive = false
        timer?.invalidate()
        isCompleted = true
        progress = 1.0
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct BreathingGuide: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.6
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.accentColor.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Image(systemName: "lungs.fill")
                    .font(.system(size: 24))
                    .foregroundColor(ColorTheme.accentColor)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    scale = 1.3
                    opacity = 1.0
                }
            }
            
            Text("Breathe slowly and deeply")
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryColor)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.playfair(18, weight: .medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(ColorTheme.accentColor)
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.playfair(18, weight: .medium))
            .foregroundColor(ColorTheme.textColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.secondaryColor.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    PracticeTimerView(
        practice: DailyPractice.practices[0],
        onComplete: {}
    )
}
