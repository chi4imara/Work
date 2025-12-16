import Foundation
import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var isShowingSplash: Bool = true
    
    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    func hideSplash() {
        isShowingSplash = false
    }
}

class BreathingTimerViewModel: ObservableObject {
    @Published var currentProgram: BreathingProgram?
    @Published var timerState: TimerState = .idle
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var currentCycle: Int = 1
    @Published var timeRemaining: Int = 0
    @Published var animationScale: CGFloat = 1.0
    
    private var timer: Timer?
    private var sessionStartTime: Date?
    private var backgroundTime: Date?
    
    var currentPhaseDuration: Int {
        guard let program = currentProgram else { return 0 }
        switch currentPhase {
        case .inhale:
            return program.inhaleSeconds
        case .pause:
            return program.pauseSeconds
        case .exhale:
            return program.exhaleSeconds
        }
    }
    
    var phaseProgress: Double {
        guard currentProgram != nil else { return 0.0 }
        let totalPhaseTime: Int = currentPhaseDuration
        guard totalPhaseTime > 0 else { return 0.0 }
        let elapsed = Double(totalPhaseTime - timeRemaining)
        let total = Double(totalPhaseTime)
        return elapsed / total
    }
    
    var formattedTimeRemaining: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var cycleText: String {
        guard let program = currentProgram else { return "" }
        return "Cycle \(currentCycle) of \(program.cycleCount)"
    }
    
    func setProgram(_ program: BreathingProgram) {
        currentProgram = program
        resetTimer()
    }
    
    func startTimer() {
        guard let program = currentProgram else { return }
        
        if timerState == .idle {
            sessionStartTime = Date()
            currentCycle = 1
            currentPhase = .inhale
            timeRemaining = program.inhaleSeconds
        }
        
        timerState = .running
        startTimerLoop()
        startBreathingAnimation()
    }
    
    func pauseTimer() {
        timerState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        currentCycle = 1
        currentPhase = .inhale
        animationScale = 1.0
        
        if let program = currentProgram {
            timeRemaining = program.inhaleSeconds
        }
    }
    
    private func startTimerLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        guard timeRemaining > 0 else {
            moveToNextPhase()
            return
        }
        
        timeRemaining -= 1
    }
    
    private func moveToNextPhase() {
        guard let program = currentProgram else { return }
        
        switch currentPhase {
        case .inhale:
            if program.pauseSeconds > 0 {
                currentPhase = .pause
                timeRemaining = program.pauseSeconds
            } else {
                currentPhase = .exhale
                timeRemaining = program.exhaleSeconds
            }
        case .pause:
            currentPhase = .exhale
            timeRemaining = program.exhaleSeconds
        case .exhale:
            if currentCycle < program.cycleCount {
                currentCycle += 1
                currentPhase = .inhale
                timeRemaining = program.inhaleSeconds
            } else {
                completeSession()
                return
            }
        }
        
        startBreathingAnimation()
    }
    
    private func completeSession() {
        guard let program = currentProgram,
              let startTime = sessionStartTime else { return }
        
        timer?.invalidate()
        timer = nil
        timerState = .completed
        
        let session = SessionRecord(
            programName: program.name,
            programPhases: program.phaseDescription,
            startTime: startTime,
            endTime: Date(),
            completedCycles: currentCycle,
            totalCycles: program.cycleCount
        )
        
        SessionManager.shared.addSession(session)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.resetTimer()
        }
    }
    
    private func startBreathingAnimation() {
        withAnimation(.easeInOut(duration: Double(currentPhaseDuration))) {
            switch currentPhase {
            case .inhale:
                animationScale = 1.4
            case .pause:
                break
            case .exhale:
                animationScale = 0.8
            }
        }
    }
    
    func handleAppBackground() {
        backgroundTime = Date()
    }
    
    func handleAppForeground() {
        guard let backgroundTime = backgroundTime,
              timerState == .running else { return }
        
        let timeInBackground = Date().timeIntervalSince(backgroundTime)
        let secondsElapsed = Int(timeInBackground)
        
        timeRemaining = max(0, timeRemaining - secondsElapsed)
        
        if timeRemaining == 0 {
            moveToNextPhase()
        }
        
        self.backgroundTime = nil
    }
}

class ProgramsViewModel: ObservableObject {
    @Published var programs: [BreathingProgram] = []
    @Published var activeProgram: BreathingProgram?
    
    init() {
        loadPrograms()
    }
    
    func loadPrograms() {
        programs = BreathingProgram.defaultPrograms
        
        if let data = UserDefaults.standard.data(forKey: "customPrograms") {
            do {
                let customPrograms: [BreathingProgram] = try JSONDecoder().decode([BreathingProgram].self, from: data)
                programs.append(contentsOf: customPrograms)
            } catch {
                print("Failed to decode custom programs: \(error)")
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: "activeProgram") {
            do {
                let program: BreathingProgram = try JSONDecoder().decode(BreathingProgram.self, from: data)
                activeProgram = program
            } catch {
                print("Failed to decode active program: \(error)")
            }
        }
    }
    
    func addProgram(_ program: BreathingProgram) {
        programs.append(program)
        saveCustomPrograms()
    }
    
    func deleteProgram(_ program: BreathingProgram) -> Bool {
        if !program.isCustom {
            let remainingDefaults = programs.filter { !$0.isCustom && $0.id != program.id }
            if remainingDefaults.isEmpty {
                return false 
            }
        }
        
        programs.removeAll { $0.id == program.id }
        
        if activeProgram?.id == program.id {
            activeProgram = nil
            saveActiveProgram()
        }
        
        saveCustomPrograms()
        return true
    }
    
    func setActiveProgram(_ program: BreathingProgram) {
        activeProgram = program
        saveActiveProgram()
    }
    
    private func saveCustomPrograms() {
        let customPrograms = programs.filter { $0.isCustom }
        if let data = try? JSONEncoder().encode(customPrograms) {
            UserDefaults.standard.set(data, forKey: "customPrograms")
        }
    }
    
    private func saveActiveProgram() {
        if let program = activeProgram,
           let data = try? JSONEncoder().encode(program) {
            UserDefaults.standard.set(data, forKey: "activeProgram")
        } else {
            UserDefaults.standard.removeObject(forKey: "activeProgram")
        }
    }
}

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var sessions: [SessionRecord] = []
    
    private init() {
        loadSessions()
    }
    
    func addSession(_ session: SessionRecord) {
        sessions.insert(session, at: 0)
        saveSessions()
    }
    
    func deleteSession(_ session: SessionRecord) {
        sessions.removeAll { $0.id == session.id }
        saveSessions()
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: "sessions") {
            do {
                let loadedSessions: [SessionRecord] = try JSONDecoder().decode([SessionRecord].self, from: data)
                sessions = loadedSessions
            } catch {
                print("Failed to decode sessions: \(error)")
            }
        }
    }
    
    private func saveSessions() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: "sessions")
        }
    }
}
