import Foundation

struct SampleData {
    static let workouts: [Workout] = [
        Workout(
            type: "Running",
            duration: 30,
            distance: 5.2,
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            comment: "Great morning run in the park. Perfect weather!"
        ),
        Workout(
            type: "Cycling",
            duration: 60,
            distance: 25.5,
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            comment: "Long ride through the countryside. Beautiful views."
        ),
        Workout(
            type: "Swimming",
            duration: 45,
            distance: 1.8,
            date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(),
            comment: "Pool session. Focused on technique."
        ),
        Workout(
            type: "Running",
            duration: 25,
            distance: 4.0,
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            comment: "Quick tempo run. Felt strong today."
        ),
        Workout(
            type: "Cycling",
            duration: 90,
            distance: 35.0,
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            comment: "Long distance training. Challenging route with hills."
        ),
        Workout(
            type: "Walking",
            duration: 40,
            distance: 3.5,
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            comment: "Recovery walk. Nice and easy pace."
        ),
        Workout(
            type: "Running",
            duration: 35,
            distance: 6.0,
            date: Date(),
            comment: "Today's run. Pushed the pace a bit."
        ),
        Workout(
            type: "Elliptical",
            duration: 20,
            distance: 2.5,
            date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(),
            comment: "Indoor training. Good cross-training session."
        )
    ]
    
    static func loadSampleData(into viewModel: WorkoutViewModel) {
        viewModel.loadSampleData()
    }
}

