import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingResetAlert = false
    @State private var selectedTimeframe: TimeFrame = .all
    
    enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
    }
    
    private var filteredProcedures: [Procedure] {
        switch selectedTimeframe {
        case .week:
            return dataManager.getProceduresForPeriod(days: 7)
        case .month:
            return dataManager.getProceduresForPeriod(days: 30)
        case .year:
            return dataManager.getProceduresForPeriod(days: 365)
        case .all:
            return dataManager.procedures
        }
    }
    
    private var serviceCounts: [ServiceCategory: Int] {
        return dataManager.getCategoryCounts()
    }
    
    private var monthlyData: [MonthlyData] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredProcedures) { procedure in
            calendar.dateInterval(of: .month, for: procedure.date)?.start ?? procedure.date
        }
        
        return grouped.map { date, procedures in
            MonthlyData(month: date, count: procedures.count)
        }.sorted { $0.month < $1.month }
    }
    
    var body: some View {
        ZStack {
            ColorManager.shared.primaryBackground
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Insights")
                        .font(FontManager.playfairBold(size: 32))
                        .foregroundColor(ColorManager.shared.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if dataManager.procedures.isEmpty {
                            EmptyInsightsView()
                            
                            Spacer()
                        } else {
                            VStack(spacing: 20) {
                                TimeFrameSelector(selectedTimeframe: $selectedTimeframe)
                                
                                OverviewCards(
                                    totalVisits: filteredProcedures.count,
                                    haircuts: serviceCounts[.haircuts] ?? 0,
                                    shaves: serviceCounts[.shaving] ?? 0,
                                    care: serviceCounts[.care] ?? 0
                                )
                                
                                if let mostFrequentBarber = dataManager.getMostFrequentBarber() {
                                    BarberInfoCard(barberName: mostFrequentBarber)
                                }
                                
                                if !monthlyData.isEmpty {
                                    MonthlyTrendChart(data: monthlyData)
                                }
                                
                                ServiceDistributionView(serviceCounts: dataManager.getServiceCounts())
                                
                                RecentActivityView(procedures: Array(dataManager.procedures.prefix(5)))
                                
                                DataManagementSection(showingResetAlert: $showingResetAlert)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Delete All", role: .destructive) {
                dataManager.clearAllData()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete all data? This action cannot be undone.")
        }
    }
}

struct TimeFrameSelector: View {
    @Binding var selectedTimeframe: InsightsView.TimeFrame
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(InsightsView.TimeFrame.allCases, id: \.self) { timeframe in
                    Button(action: { selectedTimeframe = timeframe }) {
                        Text(timeframe.rawValue)
                            .font(FontManager.playfairMedium(size: 14))
                            .foregroundColor(selectedTimeframe == timeframe ? ColorManager.shared.primaryText : ColorManager.shared.secondaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedTimeframe == timeframe ? ColorManager.shared.accentBlue : ColorManager.shared.cardBackground)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

struct OverviewCards: View {
    let totalVisits: Int
    let haircuts: Int
    let shaves: Int
    let care: Int
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            InsightCard(
                title: "Total Visits",
                value: "\(totalVisits)",
                icon: "calendar",
                color: ColorManager.shared.accentBlue
            )
            
            InsightCard(
                title: "Haircuts",
                value: "\(haircuts)",
                icon: "scissors",
                color: ColorManager.shared.accentOrange
            )
            
            InsightCard(
                title: "Shaves",
                value: "\(shaves)",
                icon: "mustache",
                color: ColorManager.shared.successColor
            )
            
            InsightCard(
                title: "Care",
                value: "\(care)",
                icon: "sparkles",
                color: ColorManager.shared.warningColor
            )
        }
    }
}

struct InsightCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.playfairBold(size: 24))
                .foregroundColor(ColorManager.shared.primaryText)
            
            Text(title)
                .font(FontManager.playfairRegular(size: 12))
                .foregroundColor(ColorManager.shared.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.shared.cardBackground)
        )
    }
}

struct BarberInfoCard: View {
    let barberName: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorManager.shared.accentBlue.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(ColorManager.shared.accentBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Most Frequent Barber")
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorManager.shared.secondaryText)
                
                Text(barberName)
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(ColorManager.shared.primaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.shared.cardBackground)
        )
    }
}

struct MonthlyData: Identifiable {
    let id = UUID()
    let month: Date
    let count: Int
}

struct MonthlyTrendChart: View {
    let data: [MonthlyData]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Trend")
                .font(FontManager.playfairSemiBold(size: 18))
                .foregroundColor(ColorManager.shared.primaryText)
            
            Chart(data) { item in
                BarMark(
                    x: .value("Month", dateFormatter.string(from: item.month)),
                    y: .value("Visits", item.count)
                )
                .foregroundStyle(ColorManager.shared.accentBlue)
                .cornerRadius(4)
            }
            .frame(height: 200)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.shared.cardBackground)
            )
        }
    }
}

struct ServiceDistributionView: View {
    let serviceCounts: [ServiceType: Int]
    
    private var sortedServices: [(ServiceType, Int)] {
        serviceCounts.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Service Distribution")
                .font(FontManager.playfairSemiBold(size: 18))
                .foregroundColor(ColorManager.shared.primaryText)
            
            VStack(spacing: 8) {
                ForEach(Array(sortedServices.prefix(5).enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text("\(index + 1).")
                            .font(FontManager.playfairMedium(size: 14))
                            .foregroundColor(ColorManager.shared.secondaryText)
                            .frame(width: 30, alignment: .leading)
                        
                        Text(item.0.rawValue)
                            .font(FontManager.playfairRegular(size: 14))
                            .foregroundColor(ColorManager.shared.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(item.1)")
                            .font(FontManager.playfairSemiBold(size: 14))
                            .foregroundColor(ColorManager.shared.accentBlue)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.shared.cardBackground)
                    )
                }
            }
        }
    }
}

struct RecentActivityView: View {
    let procedures: [Procedure]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(FontManager.playfairSemiBold(size: 18))
                .foregroundColor(ColorManager.shared.primaryText)
            
            VStack(spacing: 8) {
                ForEach(procedures) { procedure in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(ColorManager.shared.accentBlue)
                            .frame(width: 8, height: 8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dateFormatter.string(from: procedure.date))
                                .font(FontManager.playfairMedium(size: 14))
                                .foregroundColor(ColorManager.shared.primaryText)
                            
                            Text(procedure.servicesDisplayText)
                                .font(FontManager.playfairRegular(size: 12))
                                .foregroundColor(ColorManager.shared.secondaryText)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorManager.shared.cardBackground)
                    )
                }
            }
        }
    }
}

struct DataManagementSection: View {
    @Binding var showingResetAlert: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Divider()
                .background(ColorManager.shared.secondaryText.opacity(0.3))
            
            VStack(spacing: 12) {
                Text("Data Management")
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(ColorManager.shared.primaryText)
                
                Text("This will permanently delete all your procedures and statistics. This action cannot be undone.")
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorManager.shared.secondaryText)
                    .multilineTextAlignment(.center)
                
                Button(action: { showingResetAlert = true }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Reset All Data")
                            .font(FontManager.playfairSemiBold(size: 16))
                    }
                    .foregroundColor(ColorManager.shared.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorManager.shared.errorColor)
                    )
                }
            }
        }
    }
}

struct EmptyInsightsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.shared.secondaryText)
            
            Text("No Data Available")
                .font(FontManager.playfairSemiBold(size: 18))
                .foregroundColor(ColorManager.shared.primaryText)
            
            Text("Add procedures to see insights and analytics")
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(ColorManager.shared.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(40)
    }
}

#Preview {
    InsightsView()
        .environmentObject(DataManager.shared)
}
