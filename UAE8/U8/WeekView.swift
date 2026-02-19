import SwiftUI

enum WeekSheetItem: Identifiable {
    case addWorkout(selectedDay: DayOfWeek?)
    case dayDetails(workoutId: UUID)
    
    var id: String {
        switch self {
        case .addWorkout:
            return "addWorkout"
        case .dayDetails(let workoutId):
            return "dayDetails-\(workoutId.uuidString)"
        }
    }
}

struct WeekView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var sheetItem: WeekSheetItem?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                header
                
                if viewModel.hasWorkouts {
                    ScrollView {
                        VStack(spacing: 20) {
                            weekGrid
                            
                            if let lastWorkout = viewModel.lastUpdatedWorkout() {
                                lastUpdatedSection(workout: lastWorkout)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 130)
                    }
                } else {
                    emptyState
                    
                    Spacer()
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addWorkout(let selectedDay):
                AddWorkoutView(viewModel: viewModel, selectedDay: selectedDay)
            case .dayDetails(let workoutId):
                DayDetailsView(viewModel: viewModel, workoutId: workoutId)
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("Week")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Button(action: {
                sheetItem = .addWorkout(selectedDay: nil)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                    Text("Add Workout")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(ColorManager.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [ColorManager.lightBlue, ColorManager.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var weekGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 15) {
            ForEach(DayOfWeek.allCases, id: \.self) { day in
                DayCard(
                    day: day,
                    workout: viewModel.workout(for: day)
                ) {
                    if let workout = viewModel.workout(for: day) {
                        sheetItem = .dayDetails(workoutId: workout.id)
                    } else {
                        sheetItem = .addWorkout(selectedDay: day)
                    }
                }
            }
        }
    }
    
    private func lastUpdatedSection(workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last Updated")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.day.rawValue)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorManager.lightBlue)
                    
                    Text(workout.type.displayName)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    if !workout.note.isEmpty {
                        Text(workout.note)
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(formatDate(workout.lastModified))
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    if workout.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(ColorManager.green)
                    }
                }
            }
            .padding(16)
            .background(ColorManager.cardGradient)
            .cornerRadius(15)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.lightBlue)
                
                Text("Add your first workout to the week")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Button {
                    sheetItem = .addWorkout(selectedDay: nil)
                } label: {
                    Text("Add")
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorManager.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(
                            LinearGradient(
                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DayCard: View {
    let day: DayOfWeek
    let workout: Workout?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(day.rawValue)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorManager.lightBlue)
                    
                    Spacer()
                    
                    if let workout = workout, workout.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(ColorManager.green)
                    }
                }
                
                if let workout = workout {
                    Text(workout.type.displayName)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    if !workout.note.isEmpty {
                        Text(workout.note)
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                            .lineLimit(2)
                    }
                } else {
                    Text("No workout")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                        .italic()
                }
                
                Spacer()
            }
            .frame(height: 100)
            .padding(12)
            .background(ColorManager.cardGradient)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    WeekView(viewModel: WorkoutViewModel())
}
