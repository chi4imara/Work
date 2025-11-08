import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func limitLength(_ maxLength: Int) -> String {
        if self.count <= maxLength {
            return self
        }
        let endIndex = self.index(self.startIndex, offsetBy: maxLength)
        return String(self[..<endIndex]) + "..."
    }
}

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

extension Array where Element == Story {
    func groupedByDate() -> [Date: [Story]] {
        Dictionary(grouping: self) { story in
            story.createdAt.startOfDay
        }
    }
    
    func sortedByCreationDate(ascending: Bool = false) -> [Story] {
        return self.sorted { first, second in
            ascending ? first.createdAt < second.createdAt : first.createdAt > second.createdAt
        }
    }
}
