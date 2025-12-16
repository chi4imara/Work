import SwiftUI

struct ActivityChartView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var monthlyData: [(month: String, count: Int)] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        var monthlyCounts: [String: Int] = [:]
        
        for procedure in dataManager.procedures {
            let monthKey = dateFormatter.string(from: procedure.date)
            monthlyCounts[monthKey, default: 0] += 1
        }
        
        let sortedMonths = monthlyCounts.sorted { first, second in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            guard let firstDate = formatter.date(from: first.key),
                  let secondDate = formatter.date(from: second.key) else {
                return false
            }
            return firstDate < secondDate
        }
        
        return sortedMonths.map { (month: $0.key, count: $0.value) }
    }
    
    private var maxCount: Int {
        monthlyData.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Activity Chart")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if monthlyData.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("No data available")
                            .font(.custom("PlayfairDisplay-Regular", size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            Text("Activity Overview")
                                .font(.custom("PlayfairDisplay-Bold", size: 24))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.top, 20)
                            
                            ChartView(monthlyData: monthlyData, maxCount: maxCount)
                            
                            MonthlyStatsView(monthlyData: monthlyData)
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

struct ChartView: View {
    let monthlyData: [(month: String, count: Int)]
    let maxCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(monthlyData, id: \.month) { data in
                    VStack(spacing: 8) {
                        Text("\(data.count)")
                            .font(.custom("PlayfairDisplay-Bold", size: 12))
                            .foregroundColor(AppColors.primaryText)
                        
                        Rectangle()
                            .fill(AppColors.purpleGradient)
                            .frame(width: 30, height: CGFloat(data.count) / CGFloat(maxCount) * 150)
                            .cornerRadius(4)
                        
                        Text(data.month)
                            .font(.custom("PlayfairDisplay-Regular", size: 10))
                            .foregroundColor(AppColors.secondaryText)
                            .rotationEffect(.degrees(-45))
                            .frame(width: 40)
                    }
                }
            }
            .frame(height: 200)
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
    }
}

struct MonthlyStatsView: View {
    let monthlyData: [(month: String, count: Int)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Statistics")
                .font(.custom("PlayfairDisplay-Bold", size: 20))
                .foregroundColor(AppColors.primaryText)
            
            ForEach(monthlyData, id: \.month) { data in
                HStack {
                    Text(data.month)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 60, alignment: .leading)
                    
                    Spacer()
                    
                    Text("\(data.count) procedure\(data.count == 1 ? "" : "s")")
                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ActivityChartView()
        .environmentObject(DataManager())
}

