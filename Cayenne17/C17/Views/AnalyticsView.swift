import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var appState: AppState
    
    var phaseDistribution: [PhaseTypeCount] {
        var distribution: [PhaseType: Int] = [:]
        
        for phase in appState.phases {
            distribution[phase.name, default: 0] += 1
        }
        
        return distribution.map { PhaseTypeCount(type: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }
    
    var workoutFrequency: [WorkoutFrequencyData] {
        let calendar = Calendar.current
        var frequency: [String: Int] = [:]
        
        for phase in appState.phases {
            for workout in phase.workouts {
                let weekKey = calendar.dateInterval(of: .weekOfYear, for: workout.date)?.start ?? workout.date
                let weekString = DateFormatter.shortWeek.string(from: weekKey)
                frequency[weekString, default: 0] += 1
            }
        }
        
        return frequency.map { WorkoutFrequencyData(week: $0.key, count: $0.value) }
            .sorted { $0.week < $1.week }
            .suffix(8)
            .map { $0 }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Analytics")
                        .font(.playfairDisplay(.bold, size: 32))
                        .foregroundColor(AppColors.white)
                        .padding(.vertical, 20)
                    
                    if appState.phases.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.lightBlue.opacity(0.6))
                            
                            Text("No data to analyze yet.")
                                .font(.playfairDisplay(.medium, size: 18))
                                .foregroundColor(AppColors.white.opacity(0.7))
                            
                            Text("Create phases and add workouts to see analytics.")
                                .font(.playfairDisplay(.regular, size: 14))
                                .foregroundColor(AppColors.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding(40)
                    } else {
                        VStack(spacing: 15) {
                            HStack {
                                Text("Phase Distribution")
                                    .font(.playfairDisplay(.semiBold, size: 20))
                                    .foregroundColor(AppColors.white)
                                
                                Spacer()
                            }
                            
                            VStack(spacing: 10) {
                                ForEach(phaseDistribution, id: \.type) { data in
                                    PhaseDistributionBar(data: data, total: appState.phases.count)
                                }
                            }
                        }
                        .padding(20)
                        .background(AppColors.cardGradient)
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        
                        if !workoutFrequency.isEmpty {
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Workout Frequency")
                                        .font(.playfairDisplay(.semiBold, size: 20))
                                        .foregroundColor(AppColors.white)
                                    
                                    Spacer()
                                }
                                
                                HStack(alignment: .bottom, spacing: 8) {
                                    ForEach(workoutFrequency, id: \.week) { data in
                                        WorkoutFrequencyBar(data: data, maxCount: workoutFrequency.map { $0.count }.max() ?? 1)
                                    }
                                }
                                .frame(height: 120)
                            }
                            .padding(20)
                            .background(AppColors.cardGradient)
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(spacing: 15) {
                            HStack {
                                Text("Summary")
                                    .font(.playfairDisplay(.semiBold, size: 20))
                                    .foregroundColor(AppColors.white)
                                
                                Spacer()
                            }
                            
                            VStack(spacing: 12) {
                                SummaryRow(
                                    title: "Average workouts per phase",
                                    value: String(format: "%.1f", averageWorkoutsPerPhase())
                                )
                                
                                SummaryRow(
                                    title: "Most active phase type",
                                    value: mostActivePhaseType()
                                )
                                
                                SummaryRow(
                                    title: "Total training days",
                                    value: "\(totalTrainingDays())"
                                )
                            }
                        }
                        .padding(20)
                        .background(AppColors.cardGradient)
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private func averageWorkoutsPerPhase() -> Double {
        guard !appState.phases.isEmpty else { return 0 }
        let totalWorkouts = appState.phases.reduce(0) { $0 + $1.workouts.count }
        return Double(totalWorkouts) / Double(appState.phases.count)
    }
    
    private func mostActivePhaseType() -> String {
        var workoutCounts: [PhaseType: Int] = [:]
        
        for phase in appState.phases {
            workoutCounts[phase.name, default: 0] += phase.workouts.count
        }
        
        return workoutCounts.max { $0.value < $1.value }?.key.rawValue ?? "None"
    }
    
    private func totalTrainingDays() -> Int {
        var uniqueDates: Set<String> = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for phase in appState.phases {
            for workout in phase.workouts {
                uniqueDates.insert(formatter.string(from: workout.date))
            }
        }
        
        return uniqueDates.count
    }
}

struct PhaseTypeCount {
    let type: PhaseType
    let count: Int
}

struct WorkoutFrequencyData {
    let week: String
    let count: Int
}

struct PhaseDistributionBar: View {
    let data: PhaseTypeCount
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(data.count) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(data.type.rawValue)
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                Text("\(data.count)")
                    .font(.playfairDisplay(.semiBold, size: 16))
                    .foregroundColor(AppColors.orange)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.white.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(AppColors.orange)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct WorkoutFrequencyBar: View {
    let data: WorkoutFrequencyData
    let maxCount: Int
    
    private var height: CGFloat {
        guard maxCount > 0 else { return 0 }
        return CGFloat(data.count) / CGFloat(maxCount) * 100
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(data.count)")
                .font(.playfairDisplay(.medium, size: 12))
                .foregroundColor(AppColors.white)
            
            Rectangle()
                .fill(AppColors.lightBlue)
                .frame(height: height)
                .cornerRadius(4)
            
            Text(data.week)
                .font(.playfairDisplay(.regular, size: 10))
                .foregroundColor(AppColors.white.opacity(0.7))
                .rotationEffect(.degrees(-45))
        }
        .frame(maxWidth: .infinity)
    }
}

struct SummaryRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(.regular, size: 16))
                .foregroundColor(AppColors.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(.semiBold, size: 16))
                .foregroundColor(AppColors.lightBlue)
        }
    }
}

extension DateFormatter {
    static let shortWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
}

#Preview {
    AnalyticsView()
        .environmentObject(AppState())
}
