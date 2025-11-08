import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var stories: [Story] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(storiesViewModel: StoriesViewModel) {
        storiesViewModel.$stories
            .assign(to: \.stories, on: self)
            .store(in: &cancellables)
    }
    
    var totalStories: Int {
        stories.count
    }
    
    var lastAddedDate: Date? {
        stories.max(by: { $0.createdAt < $1.createdAt })?.createdAt
    }
    
    var tagStatistics: [(tag: String, count: Int)] {
        var tagCounts: [String: Int] = [:]
        for story in stories {
            for tag in story.tags {
                tagCounts[tag, default: 0] += 1
            }
        }
        return tagCounts.sorted { first, second in
            if first.value == second.value {
                return first.key < second.key
            }
            return first.value > second.value
        }.map { (tag: $0.key, count: $0.value) }
    }
    
    var viewedStoriesCount: Int {
        stories.filter { $0.viewCount > 0 }.count
    }
    
    var lastViewedDate: Date? {
        stories.compactMap { $0.lastViewedAt }.max()
    }
    
    var maxDayStreak: Int {
        calculateMaxStreak()
    }
    
    var currentDayStreak: Int {
        calculateCurrentStreak()
    }
    
    private func calculateMaxStreak() -> Int {
        let viewDates = stories.compactMap { $0.lastViewedAt }
            .map { Calendar.current.startOfDay(for: $0) }
        let uniqueDates = Array(Set(viewDates)).sorted()
        
        guard !uniqueDates.isEmpty else { return 0 }
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 1..<uniqueDates.count {
            let previousDate = uniqueDates[i-1]
            let currentDate = uniqueDates[i]
            
            if Calendar.current.dateInterval(of: .day, for: previousDate)?.end == currentDate {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return maxStreak
    }
    
    private func calculateCurrentStreak() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        let viewDates = stories.compactMap { $0.lastViewedAt }
            .map { Calendar.current.startOfDay(for: $0) }
        let uniqueDates = Array(Set(viewDates)).sorted(by: >)
        
        guard !uniqueDates.isEmpty else { return 0 }
        
        var streak = 0
        var checkDate = today
        
        for date in uniqueDates {
            if date == checkDate {
                streak += 1
                checkDate = Calendar.current.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else {
                break
            }
        }
        
        return streak
    }
}
