import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Analytics")
                .font(FontManager.playfairBold(size: 28))
                .foregroundColor(ColorManager.primaryText)
                .padding(.vertical, 10)
            
            if recordsViewModel.records.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 60))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Text("No data for analytics.")
                        .font(FontManager.playfairRegular(size: 18))
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        OverviewCards(recordsViewModel: recordsViewModel)
                        
                        RecordsByTypeChart(recordsViewModel: recordsViewModel)
                        
                        MonthlyActivityChart(recordsViewModel: recordsViewModel)
                        
                        RecentActivitySection(recordsViewModel: recordsViewModel)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct OverviewCards: View {
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    
    var totalRecords: Int {
        recordsViewModel.records.count
    }
    
    var totalMileage: Double {
        recordsViewModel.records.compactMap { Double($0.mileage.replacingOccurrences(of: " ", with: "")) }.reduce(0, +)
    }
    
    var averageMileage: Double {
        let mileages = recordsViewModel.records.compactMap { Double($0.mileage.replacingOccurrences(of: " ", with: "")) }
        return mileages.isEmpty ? 0 : mileages.reduce(0, +) / Double(mileages.count)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                AnalyticsCard(
                    icon: "list.bullet",
                    title: "Total Records",
                    value: "\(totalRecords)",
                    color: ColorManager.lightBlue
                )
                
                AnalyticsCard(
                    icon: "speedometer",
                    title: "Avg Mileage",
                    value: formatMileage(averageMileage),
                    color: ColorManager.orange
                )
            }
        }
    }
    
    private func formatMileage(_ mileage: Double) -> String {
        if mileage == 0 {
            return "N/A"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: mileage)) ?? "0"
    }
}

struct AnalyticsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.playfairBold(size: 24))
                .foregroundColor(ColorManager.primaryText)
            
            Text(title)
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.darkBlue.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                }
        )
    }
}

struct RecordsByTypeChart: View {
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    
    var statistics: [RecordType: Int] {
        recordsViewModel.getStatistics()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Records by Type")
                .font(FontManager.playfairSemiBold(size: 20))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                ForEach(RecordType.allCases, id: \.self) { type in
                    let count = statistics[type] ?? 0
                    let total = statistics.values.reduce(0, +)
                    let percentage = total > 0 ? Double(count) / Double(total) * 100 : 0
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: type.icon)
                                .font(.system(size: 16))
                                .foregroundColor(ColorManager.lightBlue)
                                .frame(width: 20)
                            
                            Text(type.rawValue)
                                .font(FontManager.playfairMedium(size: 16))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorManager.orange)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(ColorManager.darkBlue.opacity(0.3))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(getColorForType(type))
                                    .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorManager.darkBlue.opacity(0.2))
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.darkBlue.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                }
        )
    }
    
    private func getColorForType(_ type: RecordType) -> Color {
        switch type {
        case .wash:
            return ColorManager.lightBlue
        case .fuel:
            return ColorManager.orange
        case .oilChange:
            return ColorManager.green
        case .maintenance:
            return ColorManager.red
        }
    }
}

struct MonthlyActivityChart: View {
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    
    var monthlyData: [(month: String, count: Int)] {
        let calendar = Calendar.current
        let now = Date()
        var data: [String: Int] = [:]
        
        for record in recordsViewModel.records {
            let month = calendar.component(.month, from: record.date)
            let year = calendar.component(.year, from: record.date)
            let monthKey = "\(year)-\(month)"
            
            if data[monthKey] == nil {
                data[monthKey] = 0
            }
            data[monthKey]? += 1
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        return data.map { key, count in
            let components = key.split(separator: "-")
            if components.count == 2,
               let year = Int(components[0]),
               let month = Int(components[1]) {
                let date = calendar.date(from: DateComponents(year: year, month: month)) ?? now
                return (month: formatter.string(from: date), count: count)
            }
            return (month: key, count: count)
        }
        .sorted { $0.month < $1.month }
        .suffix(6)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Monthly Activity")
                .font(FontManager.playfairSemiBold(size: 20))
                .foregroundColor(ColorManager.primaryText)
            
            if monthlyData.isEmpty {
                Text("No monthly data available.")
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorManager.secondaryText)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(monthlyData.enumerated()), id: \.offset) { index, item in
                        HStack(spacing: 12) {
                            Text(item.month)
                                .font(FontManager.playfairMedium(size: 14))
                                .foregroundColor(ColorManager.secondaryText)
                                .frame(width: 80, alignment: .leading)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(ColorManager.darkBlue.opacity(0.3))
                                        .frame(height: 20)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(ColorManager.accentGradient)
                                        .frame(width: geometry.size.width * CGFloat(item.count) / CGFloat(max(monthlyData.map { $0.count }.max() ?? 1, 1)), height: 20)
                                }
                            }
                            .frame(height: 20)
                            
                            Text("\(item.count)")
                                .font(FontManager.playfairSemiBold(size: 14))
                                .foregroundColor(ColorManager.orange)
                                .frame(width: 30, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.darkBlue.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                }
        )
    }
}

struct RecentActivitySection: View {
    @ObservedObject var recordsViewModel: CarRecordsViewModel
    
    var recentRecords: [CarRecord] {
        Array(recordsViewModel.records.prefix(5))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(FontManager.playfairSemiBold(size: 20))
                .foregroundColor(ColorManager.primaryText)
            
            if recentRecords.isEmpty {
                Text("No recent activity.")
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorManager.secondaryText)
                    .padding()
            } else {
                VStack(spacing: 10) {
                    ForEach(recentRecords) { record in
                        HStack(spacing: 12) {
                            Image(systemName: record.type.icon)
                                .font(.system(size: 18))
                                .foregroundColor(ColorManager.lightBlue)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(record.type.rawValue)
                                    .font(FontManager.playfairMedium(size: 14))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Text(record.formattedDate)
                                    .font(FontManager.playfairRegular(size: 12))
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text(record.mileage)
                                .font(FontManager.playfairRegular(size: 14))
                                .foregroundColor(ColorManager.secondaryText)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ColorManager.darkBlue.opacity(0.2))
                        )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.darkBlue.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                }
        )
    }
}

#Preview {
    AnalyticsView(recordsViewModel: {
        let vm = CarRecordsViewModel()
        vm.addRecord(CarRecord(type: .wash, date: Date(), mileage: "124530", comment: "Full wash"))
        vm.addRecord(CarRecord(type: .fuel, date: Date().addingTimeInterval(-86400), mileage: "124500", comment: "Filled 50 liters"))
        vm.addRecord(CarRecord(type: .oilChange, date: Date().addingTimeInterval(-172800), mileage: "124450", comment: "Oil change"))
        return vm
    }())
}
