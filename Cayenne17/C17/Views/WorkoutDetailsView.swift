import SwiftUI

struct WorkoutDetailsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let workout: Workout
    let phaseId: UUID
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(AppColors.lightBlue)
                    
                    Spacer()
                    
                    Text("Workout")
                        .font(.playfairDisplay(.bold, size: 24))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                    
                    Text("")
                        .font(.playfairDisplay(.medium, size: 16))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.playfairDisplay(.medium, size: 16))
                                .foregroundColor(AppColors.lightBlue)
                            
                            Text(workout.date, style: .date)
                                .font(.playfairDisplay(.regular, size: 18))
                                .foregroundColor(AppColors.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .background(AppColors.white.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Workout Type")
                                .font(.playfairDisplay(.medium, size: 16))
                                .foregroundColor(AppColors.lightBlue)
                            
                            Text(workout.type)
                                .font(.playfairDisplay(.regular, size: 18))
                                .foregroundColor(AppColors.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .background(AppColors.white.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Result")
                                .font(.playfairDisplay(.medium, size: 16))
                                .foregroundColor(AppColors.lightBlue)
                            
                            Text(workout.result)
                                .font(.playfairDisplay(.regular, size: 18))
                                .foregroundColor(AppColors.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .background(AppColors.white.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.playfairDisplay(.medium, size: 16))
                                .foregroundColor(AppColors.lightBlue)
                            
                            Text(workout.comment.isEmpty ? "Comment not added." : workout.comment)
                                .font(.playfairDisplay(.regular, size: 18))
                                .foregroundColor(AppColors.white)
                                .opacity(workout.comment.isEmpty ? 0.7 : 1.0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(25)
                .background(AppColors.cardGradient)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: deleteWorkout) {
                    Text("Delete Workout")
                        .font(.playfairDisplay(.semiBold, size: 18))
                        .foregroundColor(AppColors.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.red)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
    
    private func deleteWorkout() {
        appState.deleteWorkoutFromPhase(workout, phaseId: phaseId)
        dismiss()
    }
}

#Preview {
    WorkoutDetailsView(
        workout: Workout(
            date: Date(),
            type: "Chest",
            result: "Bench press 100kg x 5",
            comment: "Good session"
        ),
        phaseId: UUID()
    )
    .environmentObject(AppState())
}
