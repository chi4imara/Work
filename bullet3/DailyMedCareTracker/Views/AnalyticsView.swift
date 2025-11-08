import SwiftUI

struct AnalyticsView: View {
    @ObservedObject private var viewModel = MedicationViewModel.shared
    @State private var selectedPeriod = 30
    
    private let periods = [7, 30]
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Analytics")
                                .font(AppFonts.largeTitle().bold())
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                        
                        periodSelector
                        
                        adherenceCard
                        
                        medicationAnalyticsCard
                        
                        dayAnalyticsCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
    }
    
    private var periodSelector: some View {
        HStack {
            Text("Analysis Period:")
                .font(AppFonts.callout())
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(periods, id: \.self) { period in
                    Button {
                        selectedPeriod = period
                    } label: {
                        Text("\(period) days")
                            .font(AppFonts.callout())
                            .foregroundColor(selectedPeriod == period ? .white : AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .frame(width: 100)
                            .background(selectedPeriod == period ? AppColors.accentBlue : AppColors.secondaryButton)
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var adherenceCard: some View {
        let analytics = viewModel.getAnalyticsData(for: selectedPeriod)
        
        return VStack(spacing: 20) {
            Text("Overall Adherence")
                .font(AppFonts.title2())
                .fontWeight(.semibold)
                .foregroundColor(AppColors.cardText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if analytics.totalDoses == 0 {
                VStack(spacing: 15) {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.cardSecondaryText)
                    
                    Text("Not enough data for analysis")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.cardSecondaryText)
                    
                    Text("Start marking doses on the calendar screen")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(analytics.adherencePercentage) / 100)
                            .stroke(
                                LinearGradient(
                                    colors: [analytics.adherenceLevel.color, analytics.adherenceLevel.color.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 2) {
                            Text("\(analytics.adherencePercentage)%")
                                .font(AppFonts.title1())
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.cardText)
                            
                            Text(analytics.adherenceLevel.displayName)
                                .font(AppFonts.caption())
                                .foregroundColor(analytics.adherenceLevel.color)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            StatItem(title: "Scheduled", value: "\(analytics.totalDoses)", color: AppColors.cardSecondaryText)
                            Spacer()
                            StatItem(title: "Taken", value: "\(analytics.takenDoses)", color: AppColors.successGreen)
                        }
                        
                        HStack {
                            StatItem(title: "Missed", value: "\(analytics.missedDoses)", color: AppColors.errorRed)
                            Spacer()
                            StatItem(title: "Unmarked", value: "\(analytics.unmarkedDoses)", color: AppColors.warningYellow)
                        }
                    }
                }
            }
        }
        .padding(20)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var medicationAnalyticsCard: some View {
        let medicationAnalytics = viewModel.getMedicationAnalytics(for: selectedPeriod)
        
        return VStack(spacing: 15) {
            Text("By Medications")
                .font(AppFonts.title3())
                .fontWeight(.semibold)
                .foregroundColor(AppColors.cardText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if medicationAnalytics.isEmpty {
                Text("No medication data available")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.cardSecondaryText)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(medicationAnalytics, id: \.medication.id) { item in
                        MedicationAnalyticsRow(
                            medication: item.medication,
                            taken: item.taken,
                            total: item.total,
                            percentage: item.percentage
                        )
                    }
                }
            }
        }
        .padding(20)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var dayAnalyticsCard: some View {
        VStack(spacing: 15) {
            Text("Daily Overview")
                .font(AppFonts.title3())
                .fontWeight(.semibold)
                .foregroundColor(AppColors.cardText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            let calendar = Calendar.current
            let endDate = Date()
            let startDate = calendar.date(byAdding: .day, value: -selectedPeriod, to: endDate) ?? endDate
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(getDaysInPeriod(start: startDate, end: endDate), id: \.self) { date in
                    DayAnalyticsCell(
                        date: date,
                        status: viewModel.getDayStatus(for: date)
                    )
                }
            }
            
            HStack(spacing: 20) {
                LegendItem(color: AppColors.successGreen, text: "All taken")
                LegendItem(color: AppColors.errorRed, text: "Missed")
                LegendItem(color: AppColors.warningYellow, text: "Unmarked")
                LegendItem(color: Color.gray.opacity(0.3), text: "No doses")
            }
            .font(AppFonts.caption2())
        }
        .padding(20)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private func getDaysInPeriod(start: Date, end: Date) -> [Date] {
        var days: [Date] = []
        var currentDate = start
        let calendar = Calendar.current
        
        while currentDate <= end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.cardSecondaryText)
            
            Text(value)
                .font(AppFonts.headline())
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

struct MedicationAnalyticsRow: View {
    let medication: Medication
    let taken: Int
    let total: Int
    let percentage: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(AppFonts.callout())
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.cardText)
                
                Text("Taken \(taken) of \(total) doses")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.cardSecondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(percentage)%")
                    .font(AppFonts.headline())
                    .fontWeight(.semibold)
                    .foregroundColor(adherenceColor(for: percentage))
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .clipShape(Capsule())
                        
                        Rectangle()
                            .fill(adherenceColor(for: percentage))
                            .frame(width: geometry.size.width * CGFloat(percentage) / 100, height: 4)
                            .clipShape(Capsule())
                    }
                }
                .frame(width: 60, height: 4)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func adherenceColor(for percentage: Int) -> Color {
        if percentage >= 80 { return AppColors.successGreen }
        else if percentage >= 50 { return AppColors.warningYellow }
        else { return AppColors.errorRed }
    }
}

struct DayAnalyticsCell: View {
    let date: Date
    let status: DayStatus
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(status.color.opacity(status == .noDoses ? 0.1 : 0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(status.color, lineWidth: status == .noDoses ? 1 : 2)
                )
            
            if isToday {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(AppColors.accentBlue, lineWidth: 2)
            }
            
            Text(dayNumber)
                .font(AppFonts.caption())
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(AppColors.cardText)
        }
        .frame(height: 30)
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .foregroundColor(AppColors.cardSecondaryText)
        }
    }
}

#Preview {
    AnalyticsView()
}
