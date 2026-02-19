import Foundation

enum SampleData {
    static var experiments: [Experiment] {
        [
            Experiment(tried: "Woke up at 6:00 AM for a week", changed: "Set alarm 30 minutes earlier, no phone in bedroom", result: "Felt more alert by 8 AM, finished morning tasks before work"),
            Experiment(tried: "Reduced coffee to 2 cups per day", changed: "Replaced afternoon coffee with green tea", result: "Less jittery, slept better after 3 days"),
            Experiment(tried: "30-minute walk after lunch", changed: "Blocked calendar and left the building", result: "Afternoon focus improved, fewer headaches"),
            Experiment(tried: "No screens 1 hour before bed", changed: "Read paper books, dimmed lights", result: "Fell asleep faster, woke less at night"),
            Experiment(tried: "Weekly review every Sunday", changed: "30 min block, same time each week", result: "Less forgotten tasks, clearer priorities"),
            Experiment(tried: "Single-tasking for deep work", changed: "Phone in drawer, one tab open", result: "Finished reports 40% faster, fewer errors"),
            Experiment(tried: "Meal prep on Sunday", changed: "3 lunch options, same containers", result: "Saved time and money, ate healthier"),
            Experiment(tried: "Standing desk for 2 hours daily", changed: "Set timer, alternated with sitting", result: "Less lower back pain after 2 weeks"),
        ]
    }
}
