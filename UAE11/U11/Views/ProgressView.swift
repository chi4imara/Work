import SwiftUI

struct WorkoutProgressView: View {
    @EnvironmentObject var viewModel: ExerciseViewModel
    @State private var selectedExercise: Exercise?
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Progress")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                if viewModel.exercises.isEmpty {
                    EmptyProgressView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            ExerciseSelectorView(
                                exercises: viewModel.exercises,
                                selectedExercise: $selectedExercise
                            )
                            
                            if let exercise = selectedExercise {
                                ProgressChartView(exercise: exercise)
                                
                                StatisticsView(exercise: exercise)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120) 
                    }
                }
            }
        }
        .onAppear {
            if selectedExercise == nil && !viewModel.exercises.isEmpty {
                selectedExercise = viewModel.exercises.first
            }
        }
    }
}

struct EmptyProgressView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            Text("Add results to see progress")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct ExerciseSelectorView: View {
    let exercises: [Exercise]
    @Binding var selectedExercise: Exercise?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Exercise")
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            Menu {
                ForEach(exercises) { exercise in
                    Button(exercise.name) {
                        selectedExercise = exercise
                    }
                }
            } label: {
                HStack {
                    Text(selectedExercise?.name ?? "Select Exercise")
                        .font(.playfairDisplay(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardGradient)
                )
            }
        }
    }
}

struct ProgressChartView: View {
    let exercise: Exercise
    @State private var animated = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    private var isCompact: Bool {
        verticalSizeClass == .compact || UIScreen.main.bounds.height < 700
    }
    
    private var chartHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight < 700 {
            return 160 
        } else if isCompact {
            return 180
        } else {
            return 220
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 12 : 16) {
            HStack {
                Text("Weight Progress")
                    .font(.playfairDisplay(size: isCompact ? 16 : 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if let lastResult = exercise.results.sorted(by: { $0.date < $1.date }).last {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Current")
                            .font(.playfairDisplay(size: isCompact ? 9 : 10, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                        Text("\(Int(lastResult.weight)) kg")
                            .font(.playfairDisplay(size: isCompact ? 14 : 16, weight: .bold))
                            .foregroundColor(AppColors.lightBlue)
                    }
                }
            }
            
            if exercise.results.count >= 1 {
                BarChartView(results: exercise.results, isCompact: isCompact)
                    .frame(height: chartHeight)
                    .padding(.horizontal, isCompact ? 12 : 20)
                    .padding(.vertical, isCompact ? 16 : 24)
                    .background(
                        RoundedRectangle(cornerRadius: isCompact ? 12 : 16)
                            .fill(AppColors.cardGradient)
                            .shadow(color: .black.opacity(0.2), radius: isCompact ? 4 : 8, x: 0, y: isCompact ? 2 : 4)
                    )
            } else {
                VStack(spacing: isCompact ? 12 : 16) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: isCompact ? 32 : 40, weight: .light))
                        .foregroundColor(AppColors.lightBlue.opacity(0.6))
                    
                    Text("Add results to see chart")
                        .font(.playfairDisplay(size: isCompact ? 12 : 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(height: chartHeight)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: isCompact ? 12 : 16)
                        .fill(AppColors.cardGradient)
                )
            }
        }
    }
}

struct StatisticsView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Max Weight",
                    value: "\(Int(exercise.maxWeight)) kg",
                    color: AppColors.lightBlue
                )
                
                StatCard(
                    title: "Best Reps",
                    value: "\(exercise.maxReps)",
                    color: AppColors.orange
                )
                
                StatCard(
                    title: "Total Records",
                    value: "\(exercise.totalRecords)",
                    color: AppColors.purple
                )
                
                StatCard(
                    title: "Days Active",
                    value: "\(daysBetween(exercise.firstRecordDate, exercise.lastRecordDate))",
                    color: AppColors.green
                )
            }
        }
    }
    
    private func daysBetween(_ start: Date?, _ end: Date?) -> Int {
        guard let start = start, let end = end else { return 0 }
        return Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 12, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
            
            Text(value)
                .font(.playfairDisplay(size: 18, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
    }
}

#Preview {
    WorkoutProgressView()
        .environmentObject(ExerciseViewModel())
}
