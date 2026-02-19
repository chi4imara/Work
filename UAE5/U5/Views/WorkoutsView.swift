import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var showingNewWorkout = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Workouts")
                            .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            showingNewWorkout = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "plus")
                                Text("Add")
                            }
                            .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(ColorManager.buttonBackground)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if workoutStore.workouts.isEmpty {
                        VStack(spacing: 30) {
                            Spacer()
                            
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 80, weight: .light))
                                .foregroundColor(ColorManager.accentBlue.opacity(0.6))
                            
                            VStack(spacing: 12) {
                                Text("Create Your First Workout")
                                    .font(FontManager.playfairDisplay(size: 24, weight: .semibold))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Text("Start building your fitness routine with custom bodyweight exercises")
                                    .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                    .foregroundColor(ColorManager.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            
                            Button(action: {
                                showingNewWorkout = true
                            }) {
                                Text("Add Workout")
                                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(ColorManager.primaryText)
                                    .frame(width: 200, height: 50)
                                    .background(ColorManager.accentGradient)
                                    .cornerRadius(25)
                            }
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                if let lastSession = workoutStore.lastCompletedWorkout {
                                    LastCompletedWorkoutCard(session: lastSession)
                                        .padding(.top, 20)
                                }
                                
                                ForEach(workoutStore.workouts) { workout in
                                    NavigationLink(destination: WorkoutDetailView(workout: workout)
                                        .environmentObject(workoutStore)) {
                                        WorkoutCard(workout: workout)
                                            .environmentObject(workoutStore)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingNewWorkout) {
            NewWorkoutView()
                .environmentObject(workoutStore)
        }
    }
}

struct WorkoutCard: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    let workout: Workout
    
    private var currentWorkout: Workout {
        workoutStore.workouts.first { $0.id == workout.id } ?? workout
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentWorkout.name)
                        .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text("\(currentWorkout.exerciseCount) exercises")
                        .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                if currentWorkout.isPerformedToday {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorManager.successGreen)
                }
            }
            
            HStack {
                Text("Last completed:")
                    .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                
                Text(currentWorkout.lastPerformedText)
                    .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(currentWorkout.lastPerformed != nil ? ColorManager.accentBlue : ColorManager.secondaryText)
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.accentBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

struct LastCompletedWorkoutCard: View {
    let session: WorkoutSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 20))
                    .foregroundColor(ColorManager.accentBlue)
                
                Text("Last Completed")
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.workoutName)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                HStack {
                    Text(session.dayMonth)
                        .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.accentBlue)
                    
                    Text("•")
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Text("\(session.exerciseCount) exercises")
                        .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorManager.accentBlue.opacity(0.1),
                    ColorManager.accentOrange.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.accentBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    WorkoutsView()
        .environmentObject(WorkoutStore())
}
