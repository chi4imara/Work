import SwiftUI

struct WorkoutSavedView: View {
    let workout: Workout
    let onDismiss: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(AppColors.green.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .opacity(isAnimating ? 0.3 : 0.8)
                        
                        Circle()
                            .fill(AppColors.green)
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.white)
                    }
                    
                    Text("Workout Saved!")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.white)
                        .opacity(isAnimating ? 1.0 : 0.0)
                }
                
                VStack(spacing: 16) {
                    WorkoutDetailRow(title: "Type", value: workout.type)
                    WorkoutDetailRow(title: "Duration", value: workout.formattedDuration)
                    WorkoutDetailRow(title: "Distance", value: workout.formattedDistance)
                    WorkoutDetailRow(title: "Date", value: workout.formattedDate)
                    
                    if workout.hasComment {
                        WorkoutDetailRow(title: "Comment", value: workout.comment)
                    } else {
                        WorkoutDetailRow(title: "Comment", value: "No comment added.")
                    }
                }
                .padding(24)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
                .padding(.horizontal, 24)
                .scaleEffect(isAnimating ? 1.0 : 0.9)
                .opacity(isAnimating ? 1.0 : 0.0)
                
                Button(action: onDismiss) {
                    HStack {
                        Text("Done")
                            .font(.ubuntu(18, weight: .medium))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(AppColors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [AppColors.lightBlue, AppColors.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(28)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
                .scaleEffect(isAnimating ? 1.0 : 0.9)
                .opacity(isAnimating ? 1.0 : 0.0)
            }
            .padding(.top, 30)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

struct WorkoutDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.white)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    WorkoutSavedView(
        workout: Workout(
            type: "Running",
            duration: 30,
            distance: 5.2,
            date: Date(),
            comment: "Great morning run!"
        ),
        onDismiss: {}
    )
}
