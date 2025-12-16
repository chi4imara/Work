import Foundation

extension EntryStore {
    func addSampleData() {
        let sampleEntries = [
            Entry(
                phrase: "Today is going to be amazing!",
                note: "Feeling optimistic about the new project",
                date: Date(),
                category: .personal
            ),
            Entry(
                phrase: "Why do programmers prefer dark mode? Because light attracts bugs!",
                note: "Heard this at the office today",
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                category: .joke
            ),
            Entry(
                phrase: "Meeting with the client at 10 AM",
                note: "Don't forget to prepare the presentation",
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                category: .work
            ),
            Entry(
                phrase: "Life is what happens when you're busy making other plans",
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                category: .personal
            ),
            Entry(
                phrase: "Code review scheduled for this afternoon",
                note: "Need to check the new authentication module",
                date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(),
                category: .work
            ),
            Entry(
                phrase: "I told my wife she was drawing her eyebrows too high. She looked surprised.",
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                category: .joke
            ),
            Entry(
                phrase: "Remember to call mom",
                note: "It's her birthday next week",
                date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(),
                category: .personal
            ),
            Entry(
                phrase: "The best time to plant a tree was 20 years ago. The second best time is now.",
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                category: .other
            )
        ]
        
        for entry in sampleEntries {
            addEntry(entry)
        }
    }
}
