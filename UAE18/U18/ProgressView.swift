import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selectedExercise: ExerciseType = .pushUps
    @State private var selectedPeriod: ProgressPeriod = .month
    
    private var progressData: [(Date, Int)] {
        workoutManager.getProgressData(for: selectedExercise, in: selectedPeriod)
    }
    
    private var stats: ProgressStats {
        workoutManager.getProgressStats(for: selectedExercise, in: selectedPeriod)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                headerView
                
                exerciseSelectorView
                
                periodSelectorView
                
                ScrollView {
                    VStack(spacing: 24) {
                        if progressData.isEmpty {
                            emptyStateView
                        } else {
                            chartView
                            statisticsView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Progress")
                .font(.ubuntu(.bold, size: 32))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var exerciseSelectorView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ExerciseType.allCases, id: \.self) { exercise in
                    ExerciseButton(
                        exercise: exercise,
                        isSelected: selectedExercise == exercise
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedExercise = exercise
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(.horizontal, -20)
    }
    
    private var periodSelectorView: some View {
        HStack(spacing: 12) {
            ForEach(ProgressPeriod.allCases, id: \.self) { period in
                PeriodButton(
                    period: period,
                    isSelected: selectedPeriod == period
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedPeriod = period
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            Text("Not enough data to display progress")
                .font(.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Add more workouts to see your progress chart")
                .font(.ubuntu(.regular, size: 14))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var chartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(selectedExercise.rawValue) Progress")
                .font(.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            SimpleLineChart(data: progressData)
                .frame(height: 200)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var statisticsView: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Best Result",
                    value: "\(stats.bestResult)",
                    unit: selectedExercise.unit,
                    color: AppColors.orange
                )
                
                StatCard(
                    title: "Workouts",
                    value: "\(stats.workoutCount)",
                    unit: "total",
                    color: AppColors.lightBlue
                )
                
                StatCard(
                    title: "Average",
                    value: String(format: "%.1f", stats.averageResult),
                    unit: selectedExercise.unit,
                    color: AppColors.accent
                )
                
                StatCard(
                    title: "Last Workout",
                    value: stats.lastWorkoutDate?.formatted(.dateTime.day().month()) ?? "None",
                    unit: "",
                    color: AppColors.success
                )
            }
        }
        .padding(20)
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

struct ExerciseButton: View {
    let exercise: ExerciseType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(exercise.rawValue)
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

struct PeriodButton: View {
    let period: ProgressPeriod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(period.rawValue)
                .font(.ubuntu(.medium, size: 14))
                .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AnyShapeStyle(AppColors.orange) : AnyShapeStyle(AppColors.cardGradient))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.ubuntu(.medium, size: 14))
                .foregroundColor(AppColors.secondaryText)
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(value)
                    .font(.ubuntu(.bold, size: 20))
                    .foregroundColor(color)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.ubuntu(.regular, size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct SimpleLineChart: View {
    let data: [(Date, Int)]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    for i in 0...4 {
                        let y = height * CGFloat(i) / 4
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    
                    for i in 0...4 {
                        let x = width * CGFloat(i) / 4
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                
                if !data.isEmpty {
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        
                        let maxValue = data.map { $0.1 }.max() ?? 1
                        let minValue = data.map { $0.1 }.min() ?? 0
                        let valueRange = maxValue - minValue
                        
                        for (index, point) in data.enumerated() {
                            let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                            let normalizedValue = valueRange > 0 ? CGFloat(point.1 - minValue) / CGFloat(valueRange) : 0.5
                            let y = height * (1 - normalizedValue)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(AppColors.lightBlue, lineWidth: 3)
                    
                    ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        
                        let maxValue = data.map { $0.1 }.max() ?? 1
                        let minValue = data.map { $0.1 }.min() ?? 0
                        let valueRange = maxValue - minValue
                        
                        let x = width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                        let normalizedValue = valueRange > 0 ? CGFloat(point.1 - minValue) / CGFloat(valueRange) : 0.5
                        let y = height * (1 - normalizedValue)
                        
                        Circle()
                            .fill(AppColors.orange)
                            .frame(width: 8, height: 8)
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }
}

#Preview {
    ProgressView()
        .environmentObject(WorkoutManager())
}
