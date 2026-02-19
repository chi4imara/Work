import Foundation

enum SampleData {
    
    static func generate() -> [Event] {
        let calendar = Calendar.current
        let now = Date()
        
        let items: [(title: String, monthOffset: Int, day: Int)] = [
            ("Team meeting", 0, 5),
            ("Client call", 0, 12),
            ("Project deadline", 1, 1),
            ("Conference trip", 1, 18),
            ("Contract signed", 1, 25),
            ("Interview", 2, 3),
            ("Product launch", 2, 10),
            ("Budget review", 2, 22),
            ("Training session", 3, 7),
            ("Partnership agreement", 3, 15),
            ("Site visit", 3, 28),
            ("Quarterly review", 4, 2),
            ("Design review", 4, 14),
            ("Deal closed", 4, 20),
            ("Offsite workshop", 5, 6),
            ("Release shipped", 5, 16),
            ("Kickoff meeting", 5, 24),
            ("Retrospective", 0, 28),
            ("One-on-one", 2, 5),
            ("All-hands", 4, 8)
        ]
        
        var events: [Event] = []
        
        for item in items {
            guard let monthDate = calendar.date(byAdding: .month, value: -item.monthOffset, to: now),
                  let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)),
                  let eventDate = calendar.date(byAdding: .day, value: item.day - 1, to: startOfMonth) else { continue }
            events.append(Event(title: item.title, date: eventDate))
        }
        
        return events.sorted { $0.date > $1.date }
    }
}
