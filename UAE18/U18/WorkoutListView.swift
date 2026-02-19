import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selectedFilter: WorkoutFilter = .all
    @State private var showingAddWorkout = false
    
    private var filteredWorkouts: [Workout] {
        workoutManager.filteredWorkouts(by: selectedFilter)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    filterView
                    
                    if filteredWorkouts.isEmpty {
                        emptyStateView
                    } else {
                        workoutsList
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddWorkout) {
            AddEditWorkoutView()
                .environmentObject(workoutManager)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Workout Journal")
                .font(.ubuntu(.bold, size: 28))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddWorkout = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(AppColors.orangeGradient)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(WorkoutFilter.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "list.clipboard")
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            Text("Add your first workout")
                .font(.ubuntu(.medium, size: 20))
                .foregroundColor(AppColors.primaryText)
            
            Button(action: {
                showingAddWorkout = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Workout")
                        .font(.ubuntu(.medium, size: 16))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.buttonGradient)
                )
            }
            
            Spacer()
        }
    }
    
    private var workoutsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredWorkouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        WorkoutRowView(workout: workout)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(.medium, size: 14))
                .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AnyShapeStyle(AppColors.lightBlue) : AnyShapeStyle(AppColors.cardGradient))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
        }
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    @EnvironmentObject var workoutManager: WorkoutManager
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateFormatter.string(from: workout.date))
                    .font(.ubuntu(.bold, size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Text(workout.exercisesList)
                    .font(.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if workoutManager.hasPersonalBest(workout) {
                Text("Best Result")
                    .font(.ubuntu(.medium, size: 12))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.orangeGradient)
                    )
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    WorkoutListView()
        .environmentObject(WorkoutManager())
}
