import Foundation
import Combine

struct Quote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
}

class QuoteManager: ObservableObject {
    static let shared = QuoteManager()
    
    private let quotes = [
        Quote(text: "Life consists of what you notice.", author: "Anonymous"),
        Quote(text: "Silence is also an answer.", author: "Anonymous"),
        Quote(text: "Every moment is an invitation to be here.", author: "Anonymous"),
        Quote(text: "Mindfulness is a gentle light within an ordinary day.", author: "Anonymous"),
        Quote(text: "Slow down, and the day will show its colors.", author: "Anonymous"),
        Quote(text: "Happiness is the ability to notice the present.", author: "Thich Nhat Hanh"),
        Quote(text: "Morning begins with attention.", author: "Anonymous"),
        Quote(text: "Notice life while it happens.", author: "Anonymous"),
        Quote(text: "Quiet joy is also joy.", author: "Anonymous"),
        Quote(text: "Three glances a day — your memory map.", author: "Anonymous")
    ]
    
    @Published var currentIndex = 0
    
    private init() {
        currentIndex = Int.random(in: 0..<quotes.count)
    }
    
    var currentQuote: Quote {
        quotes[currentIndex]
    }
    
    var quotesCount: Int {
        quotes.count
    }
    
    func nextQuote() {
        currentIndex = (currentIndex + 1) % quotes.count
    }
    
    func previousQuote() {
        currentIndex = currentIndex > 0 ? currentIndex - 1 : quotes.count - 1
    }
    
    func randomDailyQuote() -> String {
        let dailyQuotes = [
            "Morning begins with attention.",
            "Notice life while it happens.",
            "Quiet joy is also joy.",
            "Three glances a day — your memory map.",
            "Every moment is an invitation to be here.",
            "Slow down, and the day will show its colors."
        ]
        
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return dailyQuotes[dayOfYear % dailyQuotes.count]
    }
}
