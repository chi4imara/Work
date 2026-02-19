import SwiftUI

struct PhaseDetailsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let phase: Phase
    
    @State private var workoutDate = Date()
    @State private var workoutType = ""
    @State private var workoutResult = ""
    @State private var selectedWorkout: Workout?
    @State private var showingWorkoutDetails = false
    @State private var showingEditPhase = false
    
    var currentPhase: Phase {
        appState.phases.first { $0.id == phase.id } ?? phase
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                        Button("Close") {
                            dismiss()
                        }
                        .font(.playfairDisplay(.medium, size: 16))
                        .foregroundColor(AppColors.lightBlue)
                        
                        Spacer()
                        
                        Text(currentPhase.name.rawValue)
                            .font(.playfairDisplay(.bold, size: 24))
                            .foregroundColor(AppColors.white)
                        
                        Spacer()
                        
                        Button("Edit") {
                            showingEditPhase = true
                        }
                        .font(.playfairDisplay(.medium, size: 16))
                        .foregroundColor(AppColors.orange)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Start Date:")
                                .font(.playfairDisplay(.medium, size: 16))
                                .foregroundColor(AppColors.lightBlue)
                            
                            Spacer()
                            
                            Text(currentPhase.startDate, style: .date)
                                .font(.playfairDisplay(.regular, size: 16))
                                .foregroundColor(AppColors.white)
                        }
                        
                        if !currentPhase.comment.isEmpty {
                            Divider()
                                .background(AppColors.white.opacity(0.3))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment:")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(AppColors.lightBlue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(currentPhase.comment)
                                    .font(.playfairDisplay(.regular, size: 16))
                                    .foregroundColor(AppColors.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding(20)
                    .background(AppColors.cardGradient)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 20) {
                        Text("Add Workout")
                            .font(.playfairDisplay(.semiBold, size: 20))
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Workout Date")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(AppColors.white)
                                
                                DatePicker("", selection: $workoutDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .colorScheme(.dark)
                                    .padding()
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Workout Type")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(AppColors.white)
                                
                                TextField("e.g., Chest, Back, Legs, Cardio", text: $workoutType)
                                    .font(.playfairDisplay(.regular, size: 16))
                                    .foregroundColor(AppColors.white)
                                    .padding()
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Result")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(AppColors.white)
                                
                                TextField("e.g., Bench 100kg x 5, Run 5km in 27:40", text: $workoutResult, axis: .vertical)
                                    .font(.playfairDisplay(.regular, size: 16))
                                    .foregroundColor(AppColors.white)
                                    .padding()
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(12)
                                    .lineLimit(2...4)
                            }
                            
                            Button(action: addWorkout) {
                                Text("Save")
                                    .font(.playfairDisplay(.semiBold, size: 16))
                                    .foregroundColor(AppColors.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(AppColors.orange)
                                    .cornerRadius(22)
                            }
                            .disabled(workoutType.isEmpty || workoutResult.isEmpty)
                            .opacity(workoutType.isEmpty || workoutResult.isEmpty ? 0.6 : 1.0)
                        }
                    }
                    .padding(20)
                    .background(AppColors.cardGradient)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 15) {
                        Text("Workouts")
                            .font(.playfairDisplay(.semiBold, size: 20))
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if currentPhase.workouts.isEmpty {
                            Text("You haven't added workouts yet.")
                                .font(.playfairDisplay(.regular, size: 16))
                                .foregroundColor(AppColors.white.opacity(0.7))
                                .padding(40)
                        } else {
                            LazyVStack(spacing: 10) {
                                ForEach(currentPhase.workouts.sorted { $0.date > $1.date }) { workout in
                                    WorkoutCard(workout: workout) {
                                        selectedWorkout = workout
                                        showingWorkoutDetails = true
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 15) {
                        Button {
                            showingEditPhase = true
                        } label: {
                            Text("Edit Phase")
                                .font(.playfairDisplay(.medium, size: 16))
                                .foregroundColor(AppColors.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(AppColors.lightBlue)
                                .cornerRadius(22)
                        }
                        
                        Button {
                            appState.deletePhase(currentPhase)
                            dismiss()
                        } label: {
                            Text("Delete Phase")
                                .font(.playfairDisplay(.medium, size: 16))
                                .foregroundColor(AppColors.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(AppColors.red)
                                .cornerRadius(22)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showingWorkoutDetails) {
            if let workout = selectedWorkout {
                WorkoutDetailsView(workout: workout, phaseId: currentPhase.id)
            }
        }
        .sheet(isPresented: $showingEditPhase) {
            EditPhaseView(phase: currentPhase)
        }
    }
    
    private func addWorkout() {
        let newWorkout = Workout(
            date: workoutDate,
            type: workoutType,
            result: workoutResult
        )
        
        appState.addWorkoutToPhase(newWorkout, phaseId: phase.id)
        
        workoutDate = Date()
        workoutType = ""
        workoutResult = ""
    }
}

struct WorkoutCard: View {
    let workout: Workout
    let onOpen: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(workout.date, style: .date)
                    .font(.playfairDisplay(.medium, size: 14))
                    .foregroundColor(AppColors.lightBlue)
                
                Text(workout.type)
                    .font(.playfairDisplay(.semiBold, size: 16))
                    .foregroundColor(AppColors.white)
                
                Text(workout.result)
                    .font(.playfairDisplay(.regular, size: 14))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(action: onOpen) {
                Text("Open")
                    .font(.playfairDisplay(.medium, size: 14))
                    .foregroundColor(AppColors.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(AppColors.orange)
                    .cornerRadius(15)
            }
        }
        .padding(15)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

#Preview {
    PhaseDetailsView(phase: Phase(name: .mass, startDate: Date(), comment: "Test phase"))
        .environmentObject(AppState())
}
