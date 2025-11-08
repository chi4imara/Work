import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: DiaryViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Journey")
                    .font(AppFonts.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryBlue)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            if hasData {
                ScrollView {
                    VStack(spacing: 24) {
                        SummaryStatsView(viewModel: viewModel)
                        
                        ActivityChartView(viewModel: viewModel)
                        
                        MoodDistributionView(viewModel: viewModel)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            } else {
                EmptyStatisticsView()
            }
        }
    }
    
    private var hasData: Bool {
        let stats = viewModel.getStatistics()
        return stats.totalEntries > 0
    }
}

struct SummaryStatsView: View {
    @ObservedObject var viewModel: DiaryViewModel
    
    var body: some View {
        let stats = viewModel.getStatistics()
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary (Last 30 Days)")
                .font(AppFonts.headline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 12) {
                StatRow(
                    title: "Total Entries",
                    value: "\(stats.totalEntries)"
                )
                
                StatRow(
                    title: "Last Entry",
                    value: stats.lastEntryDate?.formatted(date: .abbreviated, time: .omitted) ?? "—"
                )
                
                StatRow(
                    title: "Most Frequent Mood",
                    value: stats.mostFrequentMood?.displayName ?? "—",
                    icon: stats.mostFrequentMood?.icon
                )
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    let icon: String?
    
    init(title: String, value: String, icon: String? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
            
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                Text(value)
                    .font(AppFonts.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryBlue)
            }
        }
    }
}

struct ActivityChartView: View {
    @ObservedObject var viewModel: DiaryViewModel
    
    var body: some View {
        let activityData = viewModel.getActivityData()
        let entriesCount = activityData.filter { $0 }.count
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity (30 Days)")
                .font(AppFonts.headline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 16) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 10), spacing: 4) {
                    ForEach(0..<30, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(activityData[index] ? AppColors.primaryBlue : AppColors.lightPurple.opacity(0.3))
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.white, lineWidth: 1)
                            }
                            .frame(height: 20)
                    }
                }
                
                Text("Entries this month: \(entriesCount) of 30")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }
}

struct MoodDistributionView: View {
    @ObservedObject var viewModel: DiaryViewModel
    
    var body: some View {
        let moodData = viewModel.getMoodDistribution()
        let totalEntries = moodData.values.reduce(0, +)
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Distribution")
                .font(AppFonts.headline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.primaryBlue)
            
            if totalEntries > 0 {
                VStack(spacing: 16) {
                    VStack(spacing: 12) {
                        ForEach(Mood.allCases, id: \.self) { mood in
                            let count = moodData[mood] ?? 0
                            let percentage = totalEntries > 0 ? Double(count) / Double(totalEntries) : 0.0
                            
                            MoodBar(
                                mood: mood,
                                count: count,
                                percentage: percentage
                            )
                        }
                    }
                }
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardGradient)
                        .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
                }
            } else {
                Text("No data available")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(40)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardGradient)
                    }
            }
        }
    }
}

struct MoodBar: View {
    let mood: Mood
    let count: Int
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: mood.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.primaryBlue)
                .frame(width: 24)
            
            Text(mood.displayName)
                .font(AppFonts.body)
                .foregroundColor(AppColors.darkGray)
                .frame(width: 60, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.lightPurple.opacity(0.3))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.primaryBlue)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
            
            Text("\(Int(percentage * 100))%")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.darkGray)
                .frame(width: 40, alignment: .trailing)
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.lightPurple.opacity(0.3))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            VStack(spacing: 16) {
                Text("Statistics will appear after your first entries")
                    .font(AppFonts.headline)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text("Start writing your daily moments to see insights about your journey.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    StatisticsView(viewModel: DiaryViewModel())
        .background(AppColors.mainBackgroundGradient)
}
