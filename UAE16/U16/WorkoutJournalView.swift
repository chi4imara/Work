import SwiftUI

struct WorkoutJournalView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingNewWorkout = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                filterButtonsView
                
                if viewModel.filteredWorkouts.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    workoutListView
                }
            }
        }
        .sheet(isPresented: $showingNewWorkout) {
            NewWorkoutView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Workout Journal")
                .font(.ubuntu(size: 28, weight: .bold))
                .foregroundColor(AppColors.white)
            
            Spacer()
            
            Button(action: {
                showingNewWorkout = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.lightBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var filterButtonsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterButton(
                    title: "All",
                    isSelected: viewModel.selectedMuscleGroupFilter == nil
                ) {
                    viewModel.selectedMuscleGroupFilter = nil
                }
                
                ForEach(MuscleGroup.allCases.filter { $0 != .other }, id: \.self) { group in
                    FilterButton(
                        title: group.displayName,
                        isSelected: viewModel.selectedMuscleGroupFilter == group
                    ) {
                        viewModel.selectedMuscleGroupFilter = group
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.gray)
            
            VStack(spacing: 12) {
                Text("Add your first workout")
                    .font(.ubuntu(size: 24, weight: .medium))
                    .foregroundColor(AppColors.white)
                
                Text("Start tracking your gym sessions")
                    .font(.ubuntu(size: 16, weight: .regular))
                    .foregroundColor(AppColors.gray)
            }
            
            Button(action: {
                showingNewWorkout = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Workout")
                }
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.lightBlue)
                )
            }
            
            Spacer()
        }
    }
    
    private var workoutListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredWorkouts) { workout in
                    WorkoutRowView(
                        workout: workout,
                        isLastVisit: viewModel.isLastVisit(workout),
                        viewModel: viewModel
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
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
                .font(.ubuntu(size: 14, weight: .medium))
                .foregroundColor(isSelected ? AppColors.white : AppColors.gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.lightBlue : AppColors.cardBackground)
                )
        }
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    let isLastVisit: Bool
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingDetails = false
    
    var body: some View {
        Button(action: {
            showingDetails = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatDate(workout.date))
                            .font(.ubuntu(size: 18, weight: .medium))
                            .foregroundColor(AppColors.white)
                        
                        Text(workout.muscleGroupsString)
                            .font(.ubuntu(size: 14, weight: .regular))
                            .foregroundColor(AppColors.gray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    if isLastVisit {
                        Text("Last Visit")
                            .font(.ubuntu(size: 12, weight: .medium))
                            .foregroundColor(AppColors.orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.orange.opacity(0.2))
                            )
                    }
                }
                
                if !workout.comment.isEmpty {
                    Text(workout.comment)
                        .font(.ubuntu(size: 12, weight: .regular))
                        .foregroundColor(AppColors.gray)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            WorkoutDetailsView(workout: workout, viewModel: viewModel)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    WorkoutJournalView(viewModel: WorkoutViewModel())
}
