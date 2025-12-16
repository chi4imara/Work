import SwiftUI

struct TimerView: View {
    @StateObject private var timerViewModel = BreathingTimerViewModel()
    @ObservedObject var programsViewModel: ProgramsViewModel
    @State private var showingMenu = false
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    headerView
                    
                    Spacer()
                    
                    if timerViewModel.currentProgram != nil {
                        timerContentView
                    } else {
                        emptyStateView
                    }
                    
                    Spacer()
                    
                    controlButtonsView
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            if let activeProgram = programsViewModel.activeProgram {
                timerViewModel.setProgram(activeProgram)
            }
        }
        .onChange(of: programsViewModel.activeProgram) { newProgram in
            if let program = newProgram {
                timerViewModel.setProgram(program)
            }
        }
        .actionSheet(isPresented: $showingMenu) {
            ActionSheet(
                title: Text("Options"),
                buttons: [
                    .default(Text("Select Program")) {
                        withAnimation {
                            selectedTab = .programs
                        }
                    },
                    .default(Text("History")) {
                        withAnimation {
                            selectedTab = .history
                        }
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Breathing")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.darkText)
            
            Spacer()
            
            Button(action: { showingMenu = true }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.mediumText)
                    .frame(width: 44, height: 44)
                    .background(AppColors.cardGradient)
                    .clipShape(Circle())
            }
        }
        .padding(.top, 10)
    }
    
    private var timerContentView: some View {
        VStack(spacing: 40) {
            breathingIndicatorView
            
            phaseInfoView
        }
    }
    
    private var breathingIndicatorView: some View {
        ZStack {
            Circle()
                .stroke(AppColors.lightGray, lineWidth: 8)
                .frame(width: 180, height: 180)
            
            Circle()
                .trim(from: 0, to: timerViewModel.phaseProgress)
                .stroke(
                    AppColors.purpleGradient,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 180, height: 180)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: timerViewModel.phaseProgress)
            
            ZStack {
                Circle()
                    .fill(AppColors.purpleGradient.opacity(0.3))
                    .frame(width: 110, height: 110)
                    .scaleEffect(timerViewModel.animationScale)
                
                Circle()
                    .fill(AppColors.purpleGradient)
                    .frame(width: 70, height: 70)
                    .scaleEffect(timerViewModel.animationScale * 0.8)
                
                VStack(spacing: 8) {
                    Text(timerViewModel.currentPhase.instruction)
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(timerViewModel.formattedTimeRemaining)
                        .font(.playfairDisplay(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .monospacedDigit()
                }
            }
        }
    }
    
    private var phaseInfoView: some View {
        VStack(spacing: 16) {
            if let program = timerViewModel.currentProgram {
                Text(program.name)
                    .font(.playfairDisplay(size: 22, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                    .multilineTextAlignment(.center)

                
                Text(timerViewModel.cycleText)
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.mediumText)
                
                Text(program.phaseDescription)
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.lightText)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "lungs")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryPurple.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No Active Program")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                
                Text("Select a breathing program to get started")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.mediumText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = .programs
                }
            }) {
                Text("Go to Programs")
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 160, height: 48)
                    .background(AppColors.purpleGradient)
                    .cornerRadius(24)
            }
        }
    }
    
    private var controlButtonsView: some View {
        HStack(spacing: 20) {
            if timerViewModel.timerState == .idle || timerViewModel.timerState == .completed {
                Button(action: {
                    timerViewModel.startTimer()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start")
                    }
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 120, height: 56)
                    .background(AppColors.purpleGradient)
                    .cornerRadius(28)
                }
                .disabled(timerViewModel.currentProgram == nil)
                
            } else if timerViewModel.timerState == .running {
                Button(action: {
                    timerViewModel.pauseTimer()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "pause.fill")
                        Text("Pause")
                    }
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 120, height: 56)
                    .background(AppColors.yellowAccent)
                    .cornerRadius(28)
                }
                
            } else if timerViewModel.timerState == .paused {
                Button(action: {
                    timerViewModel.startTimer()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Resume")
                    }
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 120, height: 56)
                    .background(AppColors.purpleGradient)
                    .cornerRadius(28)
                }
            }
            
            if timerViewModel.currentProgram != nil && timerViewModel.timerState != .idle {
                Button(action: {
                    timerViewModel.resetTimer()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "stop.fill")
                        Text("Reset")
                    }
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(width: 120, height: 56)
                    .background(AppColors.cardGradient)
                    .cornerRadius(28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(AppColors.primaryPurple, lineWidth: 2)
                    )
                }
            }
        }
    }
}
