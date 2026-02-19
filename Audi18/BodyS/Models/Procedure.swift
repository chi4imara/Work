import Foundation

struct Procedure: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var steps: [String]
    
    init(name: String, description: String = "", steps: [String] = []) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.steps = steps
    }
}

struct DailyProgress: Identifiable, Codable {
    let id: UUID
    let date: Date
    let procedureId: UUID
    var completedSteps: Set<Int>
    
    init(date: Date, procedureId: UUID) {
        self.id = UUID()
        self.date = date
        self.procedureId = procedureId
        self.completedSteps = []
    }
}

enum WeekDay: Int, CaseIterable, Codable, Identifiable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var id: Int { rawValue }
    
    var name: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
    
    static var today: WeekDay {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
        return WeekDay(rawValue: adjustedWeekday) ?? .monday
    }
}

struct Schedule: Codable {
    var weeklyProcedures: [WeekDay: [UUID]] = [:]
    
    mutating func addProcedure(_ procedureId: UUID, to day: WeekDay) {
        if weeklyProcedures[day] == nil {
            weeklyProcedures[day] = []
        }
        if !weeklyProcedures[day]!.contains(procedureId) {
            weeklyProcedures[day]!.append(procedureId)
        }
    }
    
    mutating func removeProcedure(_ procedureId: UUID, from day: WeekDay) {
        weeklyProcedures[day]?.removeAll { $0 == procedureId }
    }
    
    func procedures(for day: WeekDay) -> [UUID] {
        return weeklyProcedures[day] ?? []
    }
}
