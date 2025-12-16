import Foundation

struct BreathingProgram: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var inhaleSeconds: Int
    var pauseSeconds: Int
    var exhaleSeconds: Int
    var cycleCount: Int
    var isCustom: Bool = true
    
    init(id: UUID = UUID(), name: String, inhaleSeconds: Int, pauseSeconds: Int, exhaleSeconds: Int, cycleCount: Int, isCustom: Bool = true) {
        self.id = id
        self.name = name
        self.inhaleSeconds = inhaleSeconds
        self.pauseSeconds = pauseSeconds
        self.exhaleSeconds = exhaleSeconds
        self.cycleCount = cycleCount
        self.isCustom = isCustom
    }
    
    var cycleDuration: Int {
        inhaleSeconds + pauseSeconds + exhaleSeconds
    }
    
    var totalDuration: Int {
        cycleDuration * cycleCount
    }
    
    var formattedDuration: String {
        let minutes = totalDuration / 60
        let seconds = totalDuration % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    var phaseDescription: String {
        if pauseSeconds > 0 {
            return "Inhale \(inhaleSeconds)s — Pause \(pauseSeconds)s — Exhale \(exhaleSeconds)s"
        } else {
            return "Inhale \(inhaleSeconds)s — Exhale \(exhaleSeconds)s"
        }
    }
    
    static let defaultPrograms: [BreathingProgram] = [
        BreathingProgram(name: "Calm Breathing", inhaleSeconds: 4, pauseSeconds: 0, exhaleSeconds: 4, cycleCount: 10, isCustom: false),
        BreathingProgram(name: "Deep Relaxation", inhaleSeconds: 4, pauseSeconds: 7, exhaleSeconds: 8, cycleCount: 8, isCustom: false),
        BreathingProgram(name: "Focus Boost", inhaleSeconds: 6, pauseSeconds: 2, exhaleSeconds: 6, cycleCount: 12, isCustom: false),
        BreathingProgram(name: "Quick Relief", inhaleSeconds: 3, pauseSeconds: 1, exhaleSeconds: 5, cycleCount: 6, isCustom: false)
    ]
}

enum BreathingPhase: String, CaseIterable {
    case inhale = "Inhale"
    case pause = "Pause"
    case exhale = "Exhale"
    
    var instruction: String {
        switch self {
        case .inhale:
            return "Breathe In"
        case .pause:
            return "Hold"
        case .exhale:
            return "Breathe Out"
        }
    }
}

enum TimerState {
    case idle
    case running
    case paused
    case completed
}

struct SessionRecord: Identifiable, Codable {
    let id: UUID
    let programName: String
    let programPhases: String
    let startTime: Date
    let endTime: Date
    let completedCycles: Int
    let totalCycles: Int
    
    init(id: UUID = UUID(), programName: String, programPhases: String, startTime: Date, endTime: Date, completedCycles: Int, totalCycles: Int) {
        self.id = id
        self.programName = programName
        self.programPhases = programPhases
        self.startTime = startTime
        self.endTime = endTime
        self.completedCycles = completedCycles
        self.totalCycles = totalCycles
    }
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes) min \(seconds) sec"
        } else {
            return "\(seconds) sec"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: startTime)
    }
}

enum TabItem: String, CaseIterable {
    case timer = "Timer"
    case programs = "Programs"
    case history = "History"
    case extra = "Extra"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .timer:
            return "timer"
        case .programs:
            return "list.bullet"
        case .history:
            return "clock"
        case .settings:
            return "gearshape"
        case .extra:
            return "star"
        }
    }
}
