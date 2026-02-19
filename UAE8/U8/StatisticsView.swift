import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                if viewModel.hasWorkouts {
                    ScrollView {
                        VStack(spacing: 20) {
                            totalWorkoutsCard
                            completedWorkoutsCard
                            workoutTypeDistribution
                            weeklyCompletionRate
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
    }
    
    private var totalWorkoutsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Total Workouts")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
            
            Text("\(viewModel.workouts.count)")
                .font(.ubuntu(36, weight: .bold))
                .foregroundColor(ColorManager.lightBlue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(15)
    }
    
    private var completedWorkoutsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Workouts")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
            
            HStack(alignment: .bottom, spacing: 8) {
                Text("\(completedCount)")
                    .font(.ubuntu(36, weight: .bold))
                    .foregroundColor(ColorManager.green)
                
                Text("/ \(viewModel.workouts.count)")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            if viewModel.workouts.count > 0 {
                let percentage = Double(completedCount) / Double(viewModel.workouts.count) * 100
                Text("\(Int(percentage))% completion rate")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(15)
    }
    
    private var workoutTypeDistribution: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Workout Type Distribution")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            ForEach(WorkoutType.allCases, id: \.self) { type in
                let count = viewModel.workouts.filter { $0.type == type }.count
                if count > 0 {
                    HStack {
                        Text(type.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Text("\(count)")
                            .font(.ubuntu(14, weight: .bold))
                            .foregroundColor(ColorManager.lightBlue)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.1))
                    )
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(15)
    }
    
    private var weeklyCompletionRate: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("This Week")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            let weekWorkouts = viewModel.workouts
            let weekCompleted = weekWorkouts.filter { $0.isCompleted }.count
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(weekCompleted) of \(weekWorkouts.count) completed")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    if weekWorkouts.count > 0 {
                        let percentage = Double(weekCompleted) / Double(weekWorkouts.count) * 100
                        Text("\(Int(percentage))% this week")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                }
                
                Spacer()
                
                if weekWorkouts.count > 0 {
                    let percentage = Double(weekCompleted) / Double(weekWorkouts.count)
                    ZStack {
                        Circle()
                            .stroke(ColorManager.secondaryText.opacity(0.2), lineWidth: 8)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .trim(from: 0, to: percentage)
                            .stroke(
                                LinearGradient(
                                    colors: [ColorManager.green, ColorManager.lightBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(percentage * 100))%")
                            .font(.ubuntu(12, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(15)
    }
    
    private var emptyState: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "chart.bar")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.lightBlue)
                
                Text("No statistics yet")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add workouts to see your training statistics")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var completedCount: Int {
        viewModel.workouts.filter { $0.isCompleted }.count
    }
}

#Preview {
    StatisticsView(viewModel: WorkoutViewModel())
}
