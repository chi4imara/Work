import Foundation

struct Procedure: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: ProcedureType
    var frequency: ProcedureFrequency
    var timeOfDay: TimeOfDay
    var duration: Int? 
    var notes: String
    var isCompleted: Bool = false
    var completedDates: [Date] = []
    var nextScheduledDate: Date?
    
    enum ProcedureType: String, CaseIterable, Codable {
        case daily = "Daily"
        case weekly = "Weekly"
        case course = "Course"
    }
    
    enum ProcedureFrequency: String, CaseIterable, Codable {
        case onceDaily = "Once Daily"
        case twiceDaily = "Twice Daily"
        case onceWeekly = "Once Weekly"
        case twiceWeekly = "Twice Weekly"
        case threeTimesWeekly = "3 Times Weekly"
        case custom = "Custom"
    }
    
    enum TimeOfDay: String, CaseIterable, Codable {
        case morning = "Morning"
        case evening = "Evening"
        case anytime = "Anytime"
    }
    
    init(name: String, type: ProcedureType, frequency: ProcedureFrequency, timeOfDay: TimeOfDay, duration: Int? = nil, notes: String = "") {
        self.name = name
        self.type = type
        self.frequency = frequency
        self.timeOfDay = timeOfDay
        self.duration = duration
        self.notes = notes
        self.nextScheduledDate = Date()
    }
    
    mutating func markAsCompleted() {
        isCompleted = true
        completedDates.append(Date())
        updateNextScheduledDate()
    }
    
    mutating func updateNextScheduledDate() {
        let calendar = Calendar.current
        let today = Date()
        
        switch frequency {
        case .onceDaily, .twiceDaily:
            nextScheduledDate = calendar.date(byAdding: .day, value: 1, to: today)
        case .onceWeekly:
            nextScheduledDate = calendar.date(byAdding: .weekOfYear, value: 1, to: today)
        case .twiceWeekly:
            nextScheduledDate = calendar.date(byAdding: .day, value: 3, to: today)
        case .threeTimesWeekly:
            nextScheduledDate = calendar.date(byAdding: .day, value: 2, to: today)
        case .custom:
            nextScheduledDate = calendar.date(byAdding: .day, value: 1, to: today)
        }
    }
}
