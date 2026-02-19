import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var selectedPeriod: TimePeriod = .all
    
    enum TimePeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
    }
    
    var filteredPurchases: [Purchase] {
        let now = Date()
        let calendar = Calendar.current
        
        switch selectedPeriod {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            return viewModel.purchases.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return viewModel.purchases.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return viewModel.purchases.filter { $0.date >= yearAgo }
        case .all:
            return viewModel.purchases
        }
    }
    
    var purchasesByDay: [(day: String, count: Int)] {
        let calendar = Calendar.current
        let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        return daysOfWeek.map { day in
            let dayIndex = daysOfWeek.firstIndex(of: day) ?? 0
            let count = filteredPurchases.filter { purchase in
                let weekday = calendar.component(.weekday, from: purchase.date)
                let adjustedWeekday = (weekday + 5) % 7
                return adjustedWeekday == dayIndex
            }.count
            return (day: day, count: count)
        }
    }
    
    var purchasesByMonth: [(month: String, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredPurchases) { purchase in
            calendar.dateInterval(of: .month, for: purchase.date)?.start ?? purchase.date
        }
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        return grouped.map { (date, purchases) in
            (month: monthFormatter.string(from: date), count: purchases.count)
        }.sorted { first, second in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            guard let firstDate = formatter.date(from: first.month),
                  let secondDate = formatter.date(from: second.month) else {
                return false
            }
            return firstDate < secondDate
        }
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 8...18))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 5...10))
                            .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            }
            
            VStack {
                HStack {
                    Text("Analytics")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.purchases.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                        
                        VStack(spacing: 8) {
                            Text("No Data Yet")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorTheme.white)
                            
                            Text("Add purchases to see analytics")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            Picker("Period", selection: $selectedPeriod) {
                                ForEach(TimePeriod.allCases, id: \.self) { period in
                                    Text(period.rawValue).tag(period)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            
                            VStack(spacing: 20) {
                                StatCardView(
                                    title: "Total Purchases",
                                    value: "\(filteredPurchases.count)",
                                    icon: "bag.fill",
                                    color: ColorTheme.yellow
                                )
                                
                                StatCardView(
                                    title: "This Period",
                                    value: selectedPeriod.rawValue,
                                    icon: "calendar",
                                    color: ColorTheme.green
                                )
                                
                                if !purchasesByDay.isEmpty {
                                    ChartCardView(
                                        title: "Purchases by Day of Week",
                                        data: purchasesByDay.map { ($0.day, $0.count) },
                                        color: ColorTheme.primaryBlue
                                    )
                                }
                                
                                if !purchasesByMonth.isEmpty && selectedPeriod == .all {
                                    ChartCardView(
                                        title: "Purchases by Month",
                                        data: purchasesByMonth.map { ($0.month, $0.count) },
                                        color: ColorTheme.orange
                                    )
                                }
                                
                                TopLocationsView(purchases: filteredPurchases)
                                
                                RecentPurchasesView(purchases: Array(filteredPurchases.prefix(5)))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(title == "This Period" ? Color.white : color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.white.opacity(0.8))
                
                Text(value)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorTheme.white)
            }
            
            Spacer()
        }
        .padding(20)
        .background(ColorTheme.cardBackground.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ChartCardView: View {
    let title: String
    let data: [(String, Int)]
    let color: Color
    
    var maxValue: Int {
        data.map { $0.1 }.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.white)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            VStack(spacing: 12) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 12) {
                        Text(item.0)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.white)
                            .frame(width: 50, alignment: .leading)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(ColorTheme.white.opacity(0.1))
                                    .frame(height: 24)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(color)
                                    .frame(width: maxValue > 0 ? geometry.size.width * CGFloat(item.1) / CGFloat(maxValue) : 0, height: 24)
                            }
                        }
                        .frame(height: 24)
                        
                        Text("\(item.1)")
                            .font(.ubuntu(14, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(ColorTheme.cardBackground.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct TopLocationsView: View {
    let purchases: [Purchase]
    
    var topLocations: [(location: String, count: Int)] {
        let grouped = Dictionary(grouping: purchases.filter { !$0.whereBought.isEmpty }) { $0.whereBought }
        return grouped.map { (location: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
            .prefix(5)
            .map { $0 }
    }
    
    var body: some View {
        if !topLocations.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Top Locations")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                VStack(spacing: 12) {
                    ForEach(Array(topLocations.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text("\(index + 1).")
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(ColorTheme.yellow)
                                .frame(width: 30)
                            
                            Text(item.location)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.white)
                            
                            Spacer()
                            
                            Text("\(item.count)")
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(ColorTheme.white.opacity(0.8))
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(ColorTheme.cardBackground.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct RecentPurchasesView: View {
    let purchases: [Purchase]
    
    var body: some View {
        if !purchases.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Purchases")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                VStack(spacing: 12) {
                    ForEach(purchases) { purchase in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(purchase.whatBought)
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorTheme.white)
                                    .lineLimit(1)
                                
                                Text(purchase.date, style: .date)
                                    .font(.ubuntu(12, weight: .regular))
                                    .foregroundColor(ColorTheme.white.opacity(0.7))
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(ColorTheme.cardBackground.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
}
