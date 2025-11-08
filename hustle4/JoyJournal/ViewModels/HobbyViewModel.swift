import Foundation
import SwiftUI

class HobbyViewModel: ObservableObject {
    @Published var hobbies: [Hobby] = []
    @Published var selectedHobby: Hobby?
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let hobbiesKey = "SavedHobbies"
    
    init() {
        loadHobbies()
    }
    
    func addHobby(name: String, icon: String) {
        let newHobby = Hobby(name: name, icon: icon)
        hobbies.insert(newHobby, at: 0)
        saveHobbies()
    }
    
    func deleteHobby(_ hobby: Hobby) {
        hobbies.removeAll { $0.id == hobby.id }
        saveHobbies()
    }
    
    func updateHobbyName(_ hobby: Hobby, newName: String) {
        if let index = hobbies.firstIndex(where: { $0.id == hobby.id }) {
            hobbies[index].name = newName
            saveHobbies()
        }
    }
    
    func addSession(to hobby: Hobby, date: Date, duration: Int, comment: String, isPlanned: Bool = false) {
        if let index = hobbies.firstIndex(where: { $0.id == hobby.id }) {
            let newSession = HobbySession(date: date, duration: duration, comment: comment, isPlanned: isPlanned)
            hobbies[index].sessions.append(newSession)
            saveHobbies()
        }
    }
    
    func markSessionAsCompleted(_ session: HobbySession, in hobby: Hobby) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobby.id }),
           let sessionIndex = hobbies[hobbyIndex].sessions.firstIndex(where: { $0.id == session.id }) {
            hobbies[hobbyIndex].sessions[sessionIndex].isCompleted = true
            hobbies[hobbyIndex].sessions[sessionIndex].isPlanned = false
            saveHobbies()
        }
    }
    
    func deleteSession(_ session: HobbySession, from hobby: Hobby) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobby.id }) {
            hobbies[hobbyIndex].sessions.removeAll { $0.id == session.id }
            saveHobbies()
        }
    }
    
    var totalSessions: Int {
        hobbies.reduce(0) { $0 + $1.totalSessions }
    }
    
    var activeHobbies: Int {
        hobbies.filter { !$0.sessions.isEmpty }.count
    }
    
    var totalTime: Int {
        hobbies.reduce(0) { $0 + $1.totalTime }
    }
    
    var totalTimeFormatted: String {
        let hours = totalTime / 60
        let minutes = totalTime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var overallProgress: Double {
        guard !hobbies.isEmpty else { return 0.0 }
        let totalProgress = hobbies.reduce(0.0) { $0 + $1.progressPercentage }
        return totalProgress / Double(hobbies.count)
    }
    
    func getPlannedSessions(for date: Date) -> [PlannedSession] {
        var plannedSessions: [PlannedSession] = []
        
        for hobby in hobbies {
            let sessions = hobby.sessions.filter { session in
                session.isPlanned && Calendar.current.isDate(session.date, inSameDayAs: date)
            }
            
            for session in sessions {
                plannedSessions.append(PlannedSession(hobby: hobby, session: session))
            }
        }
        
        return plannedSessions.sorted { $0.session.date < $1.session.date }
    }
    
    func getCompletedSessions(for date: Date) -> [PlannedSession] {
        var completedSessions: [PlannedSession] = []
        
        for hobby in hobbies {
            let sessions = hobby.sessions.filter { session in
                session.isCompleted && Calendar.current.isDate(session.date, inSameDayAs: date)
            }
            
            for session in sessions {
                completedSessions.append(PlannedSession(hobby: hobby, session: session))
            }
        }
        
        return completedSessions.sorted { $0.session.date < $1.session.date }
    }
    
    func getSessionsData(for period: AnalyticsPeriod) -> [SessionDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        var dataPoints: [SessionDataPoint] = []
        
        let days: Int
        switch period {
        case .week:
            days = 7
        case .month:
            days = 30
        case .year:
            days = 365
        }
        
        for i in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -i, to: now) else { continue }
            
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
            
            let sessionsForDay = hobbies.flatMap { $0.sessions }.filter { session in
                session.isCompleted && session.date >= dayStart && session.date < dayEnd
            }
            
            let totalTime = sessionsForDay.reduce(0) { $0 + $1.duration }
            let sessionCount = sessionsForDay.count
            
            dataPoints.append(SessionDataPoint(
                date: dayStart,
                totalTime: totalTime,
                sessionCount: sessionCount
            ))
        }
        
        return dataPoints.reversed()
    }
    
    func getHobbyDistribution() -> [HobbyDistribution] {
        let totalTime = self.totalTime
        guard totalTime > 0 else { return [] }
        
        return hobbies.compactMap { hobby in
            let hobbyTime = hobby.totalTime
            guard hobbyTime > 0 else { return nil }
            
            let percentage = Double(hobbyTime) / Double(totalTime)
            return HobbyDistribution(
                hobby: hobby,
                percentage: percentage,
                totalTime: hobbyTime
            )
        }.sorted { $0.percentage > $1.percentage }
    }
    
    private func saveHobbies() {
        if let encoded = try? JSONEncoder().encode(hobbies) {
            userDefaults.set(encoded, forKey: hobbiesKey)
        }
    }
    
    private func loadHobbies() {
        if let data = userDefaults.data(forKey: hobbiesKey),
           let decoded = try? JSONDecoder().decode([Hobby].self, from: data) {
            hobbies = decoded
        }
    }
}

struct PlannedSession {
    let hobby: Hobby
    let session: HobbySession
}

struct SessionDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let totalTime: Int
    let sessionCount: Int
}

struct HobbyDistribution: Identifiable {
    let id = UUID()
    let hobby: Hobby
    let percentage: Double
    let totalTime: Int
}

enum AnalyticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
