import Foundation
import SwiftUI
import Combine

@MainActor
class QuestionViewModel: ObservableObject {
    @Published var currentDailyQuestion: Question?
    @Published var currentRandomQuestion: Question?
    @Published var todaysAnswer: DailyAnswer?
    @Published var answerText = ""
    @Published var isAnswerSaved = false
    @Published var showSaveConfirmation = false
    
    private let dataManager = DataManager.shared
    
    init() {
        loadTodaysQuestion()
        loadTodaysAnswer()
    }
    
    func loadTodaysQuestion() {
        currentDailyQuestion = dataManager.getTodaysQuestion()
    }
    
    func loadRandomQuestion() {
        currentRandomQuestion = dataManager.getRandomQuestion()
    }
    
    func loadTodaysAnswer() {
        todaysAnswer = dataManager.getTodaysAnswer()
        if let answer = todaysAnswer {
            answerText = answer.answer
            isAnswerSaved = true
        }
    }
    
    func saveAnswer() {
        guard let question = currentDailyQuestion, !answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let answer = DailyAnswer(
            questionId: question.id,
            questionText: question.text,
            answer: answerText,
            date: Date(),
            createdAt: Date()
        )
        
        dataManager.saveDailyAnswer(answer)
        todaysAnswer = answer
        isAnswerSaved = true
        showSaveConfirmation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showSaveConfirmation = false
        }
    }
    
    func canSaveAnswer() -> Bool {
        return !answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isAnswerSaved
    }
    
    func resetForNewDay() {
        if !Calendar.current.isDateInToday(todaysAnswer?.date ?? Date.distantPast) {
            todaysAnswer = nil
            answerText = ""
            isAnswerSaved = false
            loadTodaysQuestion()
        }
    }
}
