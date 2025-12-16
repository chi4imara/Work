import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let dailyQuestions = [
        Question(text: "What brings you peace?", category: .daily),
        Question(text: "Who do you want to be for yourself?", category: .daily),
        Question(text: "When do you feel true solitude?", category: .daily),
        Question(text: "What does silence teach you?", category: .daily),
        Question(text: "How do you show kindness to yourself?", category: .daily),
        Question(text: "What thoughts visit you in quiet moments?", category: .daily),
        Question(text: "When do you feel most authentic?", category: .daily),
        Question(text: "What would you tell your younger self?", category: .daily),
        Question(text: "How has solitude changed you?", category: .daily),
        Question(text: "What are you grateful for today?", category: .daily),
        Question(text: "What fears hold you back?", category: .daily),
        Question(text: "How do you define happiness?", category: .daily),
        Question(text: "What makes you feel alive?", category: .daily),
        Question(text: "When do you feel most connected to yourself?", category: .daily),
        Question(text: "What dreams are you nurturing?", category: .daily)
    ]
    
    private let randomQuestions = [
        Question(text: "If silence could speak, what would it tell you?", category: .random),
        Question(text: "What color represents your current mood?", category: .random),
        Question(text: "If you could have a conversation with time, what would you ask?", category: .random),
        Question(text: "What would your ideal day of solitude look like?", category: .random),
        Question(text: "If your thoughts had a voice, how would they sound?", category: .random),
        Question(text: "What would you create if no one was watching?", category: .random),
        Question(text: "How would you describe the feeling of being truly understood?", category: .random),
        Question(text: "What question do you wish someone would ask you?", category: .random),
        Question(text: "If you could send a message to the universe, what would it say?", category: .random),
        Question(text: "What does your inner voice sound like?", category: .random)
    ]
    
    private let quotes = [
        Quote(text: "Sometimes silence speaks louder than words.", author: nil),
        Quote(text: "You are not alone — you are simply with yourself.", author: nil),
        Quote(text: "In stillness, we find our truest thoughts.", author: nil),
        Quote(text: "Solitude is where you meet yourself.", author: nil),
        Quote(text: "The quietest moments often hold the deepest truths.", author: nil),
        Quote(text: "Your thoughts are your most honest companions.", author: nil),
        Quote(text: "In silence, we learn to listen to our hearts.", author: nil),
        Quote(text: "Every moment of reflection is a step toward understanding.", author: nil)
    ]
    
    private init() {}
    
    func getTodaysQuestion() -> Question {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % dailyQuestions.count
        return dailyQuestions[index]
    }
    
    func getRandomQuestion() -> Question {
        return randomQuestions.randomElement() ?? randomQuestions[0]
    }
    
    func saveDailyAnswer(_ answer: DailyAnswer) {
        var answers = getDailyAnswers()
        
        if let existingIndex = answers.firstIndex(where: { $0.id == answer.id }) {
            answers[existingIndex] = answer
        } else {
            answers.removeAll { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
            answers.append(answer)
        }
        
        saveDailyAnswers(answers)
    }
    
    func getTodaysAnswer() -> DailyAnswer? {
        let answers = getDailyAnswers()
        return answers.first { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
    }
    
    func getDailyAnswers() -> [DailyAnswer] {
        guard let data = UserDefaults.standard.data(forKey: "dailyAnswers"),
              let answers = try? JSONDecoder().decode([DailyAnswer].self, from: data) else {
            return []
        }
        return answers.sorted { $0.date > $1.date }
    }
    
    private func saveDailyAnswers(_ answers: [DailyAnswer]) {
        if let data = try? JSONEncoder().encode(answers) {
            UserDefaults.standard.set(data, forKey: "dailyAnswers")
        }
    }
    
    func deleteDailyAnswer(_ answer: DailyAnswer) {
        var answers = getDailyAnswers()
        answers.removeAll { $0.id == answer.id }
        saveDailyAnswers(answers)
    }
    
    func savePersonalNote(_ note: PersonalNote) {
        var notes = getPersonalNotes()
        
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
        
        savePersonalNotes(notes)
    }
    
    func getPersonalNotes() -> [PersonalNote] {
        guard let data = UserDefaults.standard.data(forKey: "personalNotes"),
              let notes = try? JSONDecoder().decode([PersonalNote].self, from: data) else {
            return []
        }
        return notes.sorted { $0.createdAt > $1.createdAt }
    }
    
    private func savePersonalNotes(_ notes: [PersonalNote]) {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: "personalNotes")
        }
    }
    
    func deletePersonalNote(_ note: PersonalNote) {
        var notes = getPersonalNotes()
        notes.removeAll { $0.id == note.id }
        savePersonalNotes(notes)
    }
    
    func getUserStats() -> UserStats {
        let dailyAnswers = getDailyAnswers()
        let personalNotes = getPersonalNotes()
        
        let currentStreak = calculateCurrentStreak(answers: dailyAnswers)
        let longestAnswer = dailyAnswers.max { $0.answer.split(separator: " ").count < $1.answer.split(separator: " ").count }
        let longestWordCount = longestAnswer?.answer.split(separator: " ").count ?? 0
        
        return UserStats(
            totalDailyAnswers: dailyAnswers.count,
            currentStreak: currentStreak,
            totalPersonalNotes: personalNotes.count,
            longestAnswerWordCount: longestWordCount
        )
    }
    
    private func calculateCurrentStreak(answers: [DailyAnswer]) -> Int {
        guard !answers.isEmpty else { return 0 }
        
        let sortedAnswers = answers.sorted { $0.date > $1.date }
        var streak = 0
        var currentDate = Date()
        
        for answer in sortedAnswers {
            if Calendar.current.isDate(answer.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if Calendar.current.isDate(answer.date, inSameDayAs: Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: answer.date) ?? answer.date
            } else {
                break
            }
        }
        
        return streak
    }
    
    func getTodaysQuote() -> Quote {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % quotes.count
        return quotes[index]
    }
}
