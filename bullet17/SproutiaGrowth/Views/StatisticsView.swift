import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var selectedGrowthPeriod: GrowthPeriod = .week
    @State private var selectedCarePeriod: CarePeriod = .week
    @State private var showingAddEntry = false
    
    enum GrowthPeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            }
        }
    }
    
    enum CarePeriod: String, CaseIterable {
        case week = "7 days"
        case month = "30 days"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            }
        }
    }
    
    private var appSummary: (plants: Int, entries7: Int, entries30: Int, frequency: Double) {
        return dataManager.getAppSummary()
    }
    
    private var dailyGrowthData: [(date: Date, plant: String, growth: String, care: String)] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentEntries = dataManager.entries.filter { $0.date >= thirtyDaysAgo }
        
        var dailyData: [(date: Date, plant: String, growth: String, care: String)] = []
        
        let groupedEntries = Dictionary(grouping: recentEntries) { entry in
            let dateKey = Calendar.current.startOfDay(for: entry.date)
            let plantName = dataManager.getPlant(by: entry.plantId)?.name ?? "Unknown"
            return "\(dateKey.timeIntervalSince1970)_\(plantName)"
        }
        
        for (key, entries) in groupedEntries {
            let components = key.components(separatedBy: "_")
            let date = Date(timeIntervalSince1970: Double(components[0]) ?? 0)
            let plantName = components.dropFirst().joined(separator: "_")
            
            let heightEntries = entries.filter { $0.height > 0 }.sorted { $0.date < $1.date }
            
            let growth: String
            if heightEntries.count >= 2 {
                let firstHeight = heightEntries.first!.height
                let lastHeight = heightEntries.last!.height
                let delta = lastHeight - firstHeight
                growth = delta > 0 ? "+\(String(format: "%.1f", delta))" : "\(String(format: "%.1f", delta))"
            } else {
                growth = "—"
            }
            
            let careActions = Set(entries.flatMap { $0.careTags.map { $0.displayName } })
            let care = careActions.isEmpty ? "—" : Array(careActions).joined(separator: ", ")
            
            dailyData.append((date: date, plant: plantName, growth: growth, care: care))
        }
        
        return dailyData.sorted { $0.date > $1.date }
    }
    
    private var growthLeaders: [(plant: String, growth: Double, entries: Int)] {
        let leaders = dataManager.getGrowthLeaders(period: selectedGrowthPeriod.days)
        return leaders.map { (plant: $0.plant.name, growth: $0.growth, entries: $0.entries) }
    }
    
    private var careQuality: (watering: Int, spraying: Int, fertilizing: Int, repotting: Int) {
        return dataManager.getCareQuality(period: selectedCarePeriod.days)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if dataManager.plants.isEmpty {
                VStack(spacing: 20) {
                    HStack(alignment: .top) {
                        Text("Statistics")
                            .font(.playfair(.bold, size: 28))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    
                    emptyStateView
                 
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        HStack {
                            Text("Statistics")
                                .font(.playfair(.bold, size: 28))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                        
                        appSummarySection
                        
                        if !dataManager.entries.isEmpty {
                            dailyGrowthSection
                            growthLeadersSection
                            careQualitySection
                        } else {
                            noDataSection
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            if let firstPlant = dataManager.plants.first {
                AddPlantEntryView(mode: .newEntry(plant: firstPlant, selectedDate: nil))
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 80))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 12) {
                Text("No Data Available")
                    .font(.playfair(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some plants to see statistics")
                    .font(.playfair(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var appSummarySection: some View {
        let summary = appSummary
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("App Summary")
                .font(.playfair(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(title: "Plants", value: "\(summary.plants)", color: AppColors.softGreen)
                StatCard(title: "Entries (7 days)", value: "\(summary.entries7)", color: AppColors.primaryBlue)
                StatCard(title: "Entries (30 days)", value: "\(summary.entries30)", color: AppColors.primaryYellow)
                StatCard(title: "Avg. Frequency", value: String(format: "%.1f", summary.frequency), color: AppColors.warningOrange)
            }
        }
    }
    
    private var dailyGrowthSection: some View {
        let data = dailyGrowthData
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Growth Dynamics (30 days)")
                .font(.playfair(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            if data.isEmpty {
                Text("No growth data available")
                    .font(.playfair(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .padding()
            } else {
                VStack(spacing: 8) {
                    HStack {
                        Text("Date")
                            .font(.playfair(.medium, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Plant")
                            .font(.playfair(.medium, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Growth")
                            .font(.playfair(.medium, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 12)
                    
                    Divider()
                        .background(AppColors.lightBlue)
                    
                    ForEach(Array(data.prefix(10).enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text(formatShortDate(item.date))
                                .font(.playfair(.regular, size: 13))
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(item.plant)
                                .font(.playfair(.regular, size: 13))
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                            
                            Text(item.growth)
                                .font(.playfair(.medium, size: 13))
                                .foregroundColor(item.growth.hasPrefix("+") ? AppColors.healthyGreen : AppColors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        
                        if index < data.prefix(10).count - 1 {
                            Divider()
                                .background(AppColors.lightGray)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
    
    private var growthLeadersSection: some View {
        let leaders = growthLeaders
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Growth Leaders")
                    .font(.playfair(.semiBold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Picker("Period", selection: $selectedGrowthPeriod) {
                    ForEach(GrowthPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 120)
            }
            
            if leaders.isEmpty {
                Text("No growth data available")
                    .font(.playfair(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .padding()
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(leaders.enumerated()), id: \.offset) { index, leader in
                        HStack {
                            Text("\(index + 1).")
                                .font(.playfair(.medium, size: 14))
                                .foregroundColor(AppColors.secondaryText)
                                .frame(width: 20)
                            
                            Text(leader.plant)
                                .font(.playfair(.regular, size: 14))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Text(leader.growth > 0 ? "+\(String(format: "%.1f", leader.growth)) cm" : "\(String(format: "%.1f", leader.growth)) cm")
                                .font(.playfair(.semiBold, size: 14))
                                .foregroundColor(leader.growth > 0 ? AppColors.healthyGreen : AppColors.alertRed)
                            
                            Text("(\(leader.entries) entries)")
                                .font(.playfair(.regular, size: 12))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        
                        if index < leaders.count - 1 {
                            Divider()
                                .background(AppColors.lightGray)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
    
    private var careQualitySection: some View {
        let care = careQuality
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Care Quality")
                    .font(.playfair(.semiBold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Picker("Period", selection: $selectedCarePeriod) {
                    ForEach(CarePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 120)
            }
            
            HStack {
                CareTagView(title: "Watering", count: care.watering, color: AppColors.primaryBlue)
                CareTagView(title: "Spraying", count: care.spraying, color: AppColors.lightBlue)
                CareTagView(title: "Fertilizing", count: care.fertilizing, color: AppColors.softGreen)
                CareTagView(title: "Repotting", count: care.repotting, color: AppColors.warningOrange)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
    
    private var noDataSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 50))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 8) {
                Text("Insufficient data for analysis")
                    .font(.playfair(.semiBold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some entries to see statistics")
                    .font(.playfair(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if !dataManager.plants.isEmpty {
                Button(action: { showingAddEntry = true }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Entry")
                    }
                    .font(.playfair(.semiBold, size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(20)
                }
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
    
    private func formatShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.playfair(.bold, size: 24))
                .foregroundColor(color)
            
            Text(title)
                .font(.playfair(.medium, size: 14))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.2), radius: 2, x: 0, y: 1)
        )
    }
}

struct CareTagView: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.playfair(.bold, size: 18))
                .foregroundColor(color)
            
            Text(title)
                .font(.playfair(.regular, size: 12))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(DataManager.shared)
}
