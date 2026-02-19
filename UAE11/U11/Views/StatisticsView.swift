import SwiftUI

struct StatisticsFullView: View {
    @EnvironmentObject var viewModel: ExerciseViewModel
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Statistics")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 24) {
                        StatisticsFullSection(viewModel: viewModel)
                        
                        AdditionalStatisticsSection(viewModel: viewModel)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120) 
                }
            }
        }
    }
}

struct StatisticsFullSection: View {
    @ObservedObject var viewModel: ExerciseViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatisticsStatCard(
                    title: "Total Exercises",
                    value: "\(viewModel.totalExercises)",
                    icon: "dumbbell",
                    color: AppColors.lightBlue
                )
                
                StatisticsStatCard(
                    title: "Total Records",
                    value: "\(viewModel.totalRecords)",
                    icon: "chart.bar.fill",
                    color: AppColors.orange
                )
            }
            
            StatisticsStatCard(
                title: "Most Frequent Training Day",
                value: viewModel.mostFrequentTrainingDay,
                icon: "calendar",
                color: AppColors.purple,
                isWide: true
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
        )
    }
}

struct StatisticsStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var isWide: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(size: 11, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.playfairDisplay(size: 16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.secondaryBackground.opacity(0.5))
        )
    }
}

struct AdditionalStatisticsSection: View {
    @ObservedObject var viewModel: ExerciseViewModel
    
    private var averageRecordsPerExercise: Double {
        guard viewModel.totalExercises > 0 else { return 0 }
        return Double(viewModel.totalRecords) / Double(viewModel.totalExercises)
    }
    
    private var totalWorkoutDays: Int {
        let allDates = viewModel.exercises.flatMap { $0.results.map { $0.date } }
        let uniqueDates = Set(allDates.map { Calendar.current.startOfDay(for: $0) })
        return uniqueDates.count
    }
    
    private var averageWeight: Double {
        let allWeights = viewModel.exercises.flatMap { $0.results.map { $0.weight } }
        guard !allWeights.isEmpty else { return 0 }
        return allWeights.reduce(0, +) / Double(allWeights.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Additional Statistics")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            if viewModel.exercises.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.lightBlue.opacity(0.6))
                    
                    Text("No data available")
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    AdditionalStatCard(
                        title: "Workout Days",
                        value: "\(totalWorkoutDays)",
                        icon: "calendar.badge.clock",
                        color: AppColors.green
                    )
                    
                    AdditionalStatCard(
                        title: "Avg Records",
                        value: String(format: "%.1f", averageRecordsPerExercise),
                        icon: "chart.line.uptrend.xyaxis",
                        color: AppColors.pink
                    )
                    
                    AdditionalStatCard(
                        title: "Avg Weight",
                        value: String(format: "%.1f kg", averageWeight),
                        icon: "scalemass",
                        color: AppColors.lightBlue
                    )
                    
                    AdditionalStatCard(
                        title: "Total Progress",
                        value: calculateTotalProgress(),
                        icon: "arrow.up.right",
                        color: AppColors.orange
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
        )
    }
    
    private func calculateTotalProgress() -> String {
        var totalIncrease: Double = 0
        var exercisesWithProgress = 0
        
        for exercise in viewModel.exercises {
            let sortedResults = exercise.results.sorted(by: { $0.date < $1.date })
            if let first = sortedResults.first, let last = sortedResults.last, sortedResults.count >= 2 {
                let increase = last.weight - first.weight
                if increase > 0 {
                    totalIncrease += increase
                    exercisesWithProgress += 1
                }
            }
        }
        
        if exercisesWithProgress > 0 {
            return String(format: "+%.1f kg", totalIncrease)
        }
        return "0 kg"
    }
}

struct AdditionalStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.playfairDisplay(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.playfairDisplay(size: 11, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.secondaryBackground.opacity(0.5))
        )
    }
}

#Preview {
    StatisticsFullView()
        .environmentObject(ExerciseViewModel())
}
