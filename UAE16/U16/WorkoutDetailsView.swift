import SwiftUI

struct WorkoutDetailsView: View {
    let workout: Workout
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var currentWorkout: Workout? {
        viewModel.workouts.first { $0.id == workout.id }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let currentWorkout = currentWorkout {
                            dateHeaderView(workout: currentWorkout)
                            
                            muscleGroupsView(workout: currentWorkout)
                            
                            if !currentWorkout.comment.isEmpty {
                                commentView(workout: currentWorkout)
                            }
                            
                            actionButtonsView(workout: currentWorkout)
                        } else {
                            Text("Workout not found")
                                .font(.ubuntu(size: 18, weight: .medium))
                                .foregroundColor(AppColors.gray)
                                .padding(.top, 40)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Workout Details")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.gray)
            )
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingEditView) {
            if let currentWorkout = currentWorkout {
                EditWorkoutView(workout: currentWorkout, viewModel: viewModel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Workout?"),
                message: Text("This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let currentWorkout = currentWorkout {
                        viewModel.deleteWorkout(currentWorkout)
                    }
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func dateHeaderView(workout: Workout) -> some View {
        VStack(spacing: 8) {
            Text(formatDate(workout.date))
                .font(.ubuntu(size: 32, weight: .bold))
                .foregroundColor(AppColors.white)
            
            if viewModel.isLastVisit(workout) {
                Text("Last Visit")
                    .font(.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(AppColors.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.orange.opacity(0.2))
                    )
            }
        }
        .padding(.bottom, 10)
    }
    
    private func muscleGroupsView(workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Muscle Groups")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Array(workout.muscleGroups), id: \.self) { group in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.green)
                        
                        Text(group == .other && workout.otherMuscleGroup != nil ? 
                             workout.otherMuscleGroup! : group.displayName)
                            .font(.ubuntu(size: 16, weight: .medium))
                            .foregroundColor(AppColors.white)
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                    )
                }
            }
        }
    }
    
    private func commentView(workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Comment")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            Text(workout.comment)
                .font(.ubuntu(size: 16, weight: .regular))
                .foregroundColor(AppColors.gray)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
        }
    }
    
    private func actionButtonsView(workout: Workout) -> some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                    Text("Edit Workout")
                }
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.lightBlue)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                    Text("Delete Workout")
                }
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.red)
                )
            }
        }
        .padding(.top, 20)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    let sampleWorkout = Workout(
        date: Date(),
        muscleGroups: [.chest, .shoulders],
        comment: "Great workout today! Focused on compound movements."
    )
    
    WorkoutDetailsView(workout: sampleWorkout, viewModel: WorkoutViewModel())
}
