import Foundation

struct MoodEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var time: Date?
    var weather: WeatherType
    var temperature: Double
    var mood: MoodType
    var location: String?
    var tag: String?
    var comment: String?
    var createdAt: Date
    
    init(date: Date, time: Date? = nil, weather: WeatherType, temperature: Double, mood: MoodType, location: String? = nil, tag: String? = nil, comment: String? = nil) {
        self.id = UUID()
        self.date = date
        self.time = time
        self.weather = weather
        self.temperature = temperature
        self.mood = mood
        self.location = location
        self.tag = tag
        self.comment = comment
        self.createdAt = Date()
    }
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var displayTime: String? {
        guard let time = time else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var dayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
