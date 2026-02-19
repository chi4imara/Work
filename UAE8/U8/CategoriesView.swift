import SwiftUI

enum CategoriesSheetItem: Identifiable {
    case workoutDetails(workoutId: UUID)
    
    var id: String {
        switch self {
        case .workoutDetails(let workoutId):
            return "workoutDetails-\(workoutId.uuidString)"
        }
    }
}

struct CategoriesView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var sheetItem: CategoriesSheetItem?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Workout Categories")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.hasWorkouts {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.categorySummaries(), id: \.id) { category in
                                CategoryCard(
                                    category: category,
                                    workouts: workoutsForCategory(category.type)
                                ) { workout in
                                    sheetItem = .workoutDetails(workoutId: workout.id)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                } else {
                    emptyState
                    
                    Spacer()
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .workoutDetails(let workoutId):
                DayDetailsView(viewModel: viewModel, workoutId: workoutId)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "list.bullet.rectangle")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.lightBlue)
                
                Text("No workout categories yet")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add workouts to see them organized by categories")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func workoutsForCategory(_ type: WorkoutType) -> [Workout] {
        return viewModel.workouts.filter { $0.type == type }
    }
}

struct CategoryCard: View {
    let category: CategorySummary
    let workouts: [Workout]
    let onWorkoutTap: (Workout) -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.type.displayName)
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text("\(category.count) \(category.count == 1 ? "day" : "days")")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.lightBlue)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(16)
                .background(ColorManager.cardGradient)
                .cornerRadius(isExpanded ? 12 : 12)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(workouts, id: \.id) { workout in
                        WorkoutRow(workout: workout) {
                            onWorkoutTap(workout)
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
                .offset(y: -12)
            }
        }
    }
}

struct WorkoutRow: View {
    let workout: Workout
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.day.fullName)
                        .font(.ubuntu(16, weight: .medium))
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
                    if workout.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(ColorManager.green)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoriesView(viewModel: WorkoutViewModel())
}
