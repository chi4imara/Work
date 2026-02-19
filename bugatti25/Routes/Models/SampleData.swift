import Foundation

enum SampleData {
    
    static var places: [Place] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        return [
            Place(name: "Central Park", category: .park, status: .wantToVisit, whyImportant: "Great for morning walks"),
            Place(name: "Blue Bottle Coffee", category: .cafe, status: .done, whyImportant: "Best flat white"),
            Place(name: "Museum of Modern Art", category: .museum, status: .wantToVisit),
            Place(name: "Brooklyn Bridge", category: .attraction, status: .done),
            Place(name: "Riverside Walk", category: .walk, status: .wantToVisit, whyImportant: "30 min exercise"),
            Place(name: "Sunset photo spot", category: .photoTask, status: .done)
        ]
    }
    
    static var dailyTasks: [DailyTask] {
        return [
            DailyTask(title: "Morning walk in the park", category: .walk, frequency: .daily, whyImportant: "Start the day active"),
            DailyTask(title: "Visit one new cafe", category: .cafe, frequency: .weekly, whyImportant: "Discover new places"),
            DailyTask(title: "Take 5 nature photos", category: .photoTask, frequency: .once),
            DailyTask(title: "Explore a new street", category: .walk, frequency: .weekly)
        ]
    }
    
    static var samplePlacesWithCompletion: [Place] {
        var list = places
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        if list.count > 1 {
            list[1].isCompleted = true
            list[1].completionDate = yesterday
            list[1].status = .done
        }
        if list.count > 3 {
            list[3].isCompleted = true
            list[3].completionDate = today
            list[3].status = .done
        }
        if list.count > 5 {
            list[5].isCompleted = true
            list[5].completionDate = yesterday
            list[5].status = .done
        }
        return list
    }
    
    static var sampleTasksWithCompletion: [DailyTask] {
        var list = dailyTasks
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        if list.count > 0 {
            list[0].isCompleted = true
            list[0].completionDate = today
        }
        if list.count > 1 {
            list[1].isCompleted = true
            list[1].completionDate = yesterday
        }
        return list
    }
    
    static var sampleCompletedChallenge: MiniChallenge {
        var challenge = MiniChallenge(title: "Walk for 30 minutes", description: "Take a refreshing 30-minute walk")
        challenge.isCompleted = true
        challenge.completionDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return challenge
    }
    
    static var sampleCurrentChallenge: MiniChallenge {
        MiniChallenge(title: "Take a sunset photo", description: "Capture the beauty of today's sunset")
    }
}
