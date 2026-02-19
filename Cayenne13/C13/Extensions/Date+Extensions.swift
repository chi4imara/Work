import Foundation

extension Date {
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func isYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: date)
        return abs(components.day ?? 0)
    }
}
