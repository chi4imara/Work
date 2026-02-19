import Foundation

struct DailyQuestion {
    let text: String
    
    static let questions = [
        "What made you smile today?",
        "What are you thinking about right now?",
        "What can you thank yourself for?",
        "How did you take care of yourself today?",
        "What moment felt most peaceful?",
        "What are you grateful for in this moment?",
        "How are you feeling in your body right now?",
        "What would you tell your younger self today?",
        "What small victory can you celebrate?",
        "What does your heart need right now?",
        "How did you show kindness today?",
        "What are you looking forward to?",
        "What lesson did today teach you?",
        "How did you honor your feelings today?",
        "What brought you joy, even if just for a moment?"
    ]
    
    static func random() -> DailyQuestion {
        let randomQuestion = questions.randomElement() ?? questions[0]
        return DailyQuestion(text: randomQuestion)
    }
    
    static func forDate(_ date: Date) -> DailyQuestion {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % questions.count
        return DailyQuestion(text: questions[index])
    }
}