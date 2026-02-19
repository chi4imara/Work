import SwiftUI

struct MeditationTimerView: View {
    let onComplete: () -> Void
    @State private var selectedDuration: TimeInterval = 180
    @State private var timeRemaining: TimeInterval = 180
    @State private var isActive = false
    @State private var timer: Timer?
    @State private var breathingScale: CGFloat = 1.0
    @Environment(\.dismiss) private var dismiss
    
    private let durations: [TimeInterval] = [180, 300]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Button("Cancel") {
                        stopTimer()
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text("Meditation")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    if isActive {
                        Button("Pause") {
                            toggleTimer()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    } else {
                        Button("Pause") {
                            toggleTimer()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .disabled(true)
                        .opacity(0)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack {
                        if !isActive && timeRemaining == selectedDuration {
                            VStack(spacing: 24) {
                                Text("Choose Duration")
                                    .font(.ubuntu(24, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                HStack(spacing: 20) {
                                    ForEach(durations, id: \.self) { duration in
                                        Button(action: {
                                            selectedDuration = duration
                                            timeRemaining = duration
                                        }) {
                                            VStack(spacing: 8) {
                                                Text("\(Int(duration / 60))")
                                                    .font(.ubuntu(32, weight: .bold))
                                                    .foregroundColor(selectedDuration == duration ? AppColors.accentText : AppColors.primaryText)
                                                
                                                Text("minutes")
                                                    .font(.ubuntu(14, weight: .light))
                                                    .foregroundColor(selectedDuration == duration ? AppColors.accentText : AppColors.secondaryText)
                                            }
                                            .frame(width: 100, height: 100)
                                            .background(
                                                selectedDuration == duration
                                                ? AppColors.primaryAccent
                                                : AppColors.cardBackground
                                            )
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        } else {
                            VStack(spacing: 40) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.softGradient)
                                        .frame(width: 200, height: 200)
                                        .scaleEffect(breathingScale)
                                        .opacity(0.6)
                                    
                                    Circle()
                                        .stroke(AppColors.primaryAccent.opacity(0.5), lineWidth: 2)
                                        .frame(width: 200, height: 200)
                                    
                                    Text(isActive ? "Breathe" : "Ready")
                                        .font(.ubuntu(20, weight: .light))
                                        .foregroundColor(AppColors.primaryText)
                                }
                                
                                Text(timeString(from: timeRemaining))
                                    .font(.ubuntu(48, weight: .light))
                                    .foregroundColor(AppColors.primaryText)
                                    .monospacedDigit()
                                
                                Text(isActive ? "Focus on your breathing" : "Tap start when ready")
                                    .font(.ubuntu(16, weight: .light))
                                    .foregroundColor(AppColors.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        Button(action: {
                            if timeRemaining <= 0 {
                                onComplete()
                                dismiss()
                            } else if timeRemaining == selectedDuration {
                                startTimer()
                            } else {
                                toggleTimer()
                            }
                        }) {
                            HStack {
                                Image(systemName: buttonIcon)
                                    .font(.system(size: 20))
                                
                                Text(buttonText)
                                    .font(.ubuntu(18, weight: .medium))
                            }
                            .foregroundColor(timeRemaining <= 0 ? AppColors.success : AppColors.accentText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                timeRemaining <= 0
                                ? AppColors.success.opacity(0.2)
                                : AppColors.primaryAccent
                            )
                            .cornerRadius(28)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 50)
                    }
                    .padding(.top, 30)
                }
            }
        }
        .onAppear {
            startBreathingAnimation()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private var buttonIcon: String {
        if timeRemaining <= 0 {
            return "checkmark.circle.fill"
        } else if isActive {
            return "pause.circle.fill"
        } else if timeRemaining == selectedDuration {
            return "play.circle.fill"
        } else {
            return "play.circle.fill"
        }
    }
    
    private var buttonText: String {
        if timeRemaining <= 0 {
            return "Complete"
        } else if isActive {
            return "Pause"
        } else if timeRemaining == selectedDuration {
            return "Start"
        } else {
            return "Resume"
        }
    }
    
    private func startTimer() {
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
    }
    
    private func toggleTimer() {
        if isActive {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    private func startBreathingAnimation() {
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            breathingScale = 1.2
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    MeditationTimerView(onComplete: {})
}
