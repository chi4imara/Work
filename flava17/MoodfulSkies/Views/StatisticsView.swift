import SwiftUI

struct StatisticsView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var appColors = AppColors.shared
    @State private var selectedPeriod: StatisticsPeriod = .month
    @State private var showingDateList = false
    @State private var selectedDates: [Date] = []
    @State private var listTitle = ""
    
    @Binding var selectedTab: Int
    
    var body: some View {
            ZStack {
                appColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Text("Statistics")
                                .font(.builderSans(.bold, size: 28))
                                .foregroundColor(appColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding()
                        
                        periodSelector
                        
                        if periodEntries.isEmpty {
                            emptyState
                        } else {
                            statisticsCards
                            
                            moodChart
                            
                            weatherChart
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .sheet(isPresented: $showingDateList) {
                DateListView(dates: selectedDates, title: listTitle)
            }
    }
    
    private var periodSelector: some View {
        HStack(spacing: 0) {
            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                periodButton(for: period)
            }
        }
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(12)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private func periodButton(for period: StatisticsPeriod) -> some View {
        let isSelected = selectedPeriod == period
        
        return Button(action: {
            selectedPeriod = period
        }) {
            Text(period.rawValue)
                .font(.builderSans(.medium, size: 16))
                .foregroundColor(isSelected ? .white : appColors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? AnyShapeStyle(appColors.primaryGradient) : AnyShapeStyle(Color.clear))
                .cornerRadius(isSelected ? 12 : 0)
        }
    }
    
    private var statisticsCards: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            StatCard(
                title: "Entries",
                value: "\(periodEntries.count)",
                icon: "calendar",
                color: appColors.primaryBlue
            )
            
            StatCard(
                title: "Avg Temperature",
                value: String(format: "%.1f°C", averageTemperature),
                icon: "thermometer",
                color: appColors.primaryOrange
            )
            
            StatCard(
                title: "Most Common Weather",
                value: mostCommonWeather?.displayName ?? "N/A",
                icon: mostCommonWeather?.icon ?? "cloud",
                color: appColors.accentGreen
            )
            
            StatCard(
                title: "Most Common Mood",
                value: mostCommonMood?.displayName ?? "N/A",
                icon: mostCommonMood?.icon ?? "face.smiling",
                color: appColors.accentPurple
            )
        }
    }
    
    private var moodChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Distribution")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            HStack(alignment: .bottom, spacing: 8) {
                Spacer()
                
                ForEach(moodData, id: \.mood) { item in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(appColors.primaryGradient)
                            .frame(width: 40, height: max(4, CGFloat(item.count) * 20))
                        
                        VStack(spacing: 2) {
                            Image(systemName: item.mood.icon)
                                .font(.system(size: 12))
                                .foregroundColor(appColors.textSecondary)
                            
                            Text("\(item.count)")
                                .font(.builderSans(.regular, size: 10))
                                .foregroundColor(appColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var weatherChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weather Distribution")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(weatherData.prefix(5), id: \.weather) { item in
                    HStack {
                        Image(systemName: item.weather.icon)
                            .font(.system(size: 16))
                            .foregroundColor(colorForWeather(item.weather))
                            .frame(width: 24)
                        
                        Text(item.weather.displayName)
                            .font(.builderSans(.medium, size: 14))
                            .foregroundColor(appColors.textPrimary)
                        
                        Spacer()
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.2))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(colorForWeather(item.weather))
                                    .frame(width: geometry.size.width * (Double(item.count) / Double(periodEntries.count)), height: 8)
                            }
                        }
                        .frame(width: 80, height: 8)
                        
                        Text("\(item.count)")
                            .font(.builderSans(.medium, size: 12))
                            .foregroundColor(appColors.textSecondary)
                            .frame(width: 20)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var temperatureChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Temperature Trend")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 8) {
                if !temperatureData.isEmpty {
                    let minTemp = temperatureData.map(\.temperature).min() ?? 0
                    let maxTemp = temperatureData.map(\.temperature).max() ?? 0
                    let tempRange = max(1, maxTemp - minTemp)
                    
                    HStack {
                        Text("Min: \(String(format: "%.1f", minTemp))°C")
                            .font(.builderSans(.regular, size: 12))
                            .foregroundColor(appColors.textSecondary)
                        
                        Spacer()
                        
                        Text("Max: \(String(format: "%.1f", maxTemp))°C")
                            .font(.builderSans(.regular, size: 12))
                            .foregroundColor(appColors.textSecondary)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(Array(temperatureData.enumerated()), id: \.offset) { index, item in
                                VStack(spacing: 4) {
                                    let normalizedHeight = CGFloat((item.temperature - minTemp) / tempRange) * 120 + 20
                                    
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(appColors.primaryOrange)
                                        .frame(width: 8, height: normalizedHeight)
                                    
                                    if index % max(1, temperatureData.count / 5) == 0 {
                                        Text(item.date.formatted(.dateTime.day().month(.abbreviated)))
                                            .font(.builderSans(.regular, size: 8))
                                            .foregroundColor(appColors.textSecondary)
                                            .rotationEffect(.degrees(-45))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    .frame(height: 160)
                } else {
                    Text("No temperature data available")
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                        .frame(height: 160)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 60))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.6))
            
            Text("Insufficient data for statistics")
                .font(.builderSans(.semiBold, size: 18))
                .foregroundColor(appColors.textPrimary)
            
            Text("Add some entries to see your statistics")
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(appColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button {
                selectedTab = 0
            } label: {
                Text("Add Entry")
                    .font(.builderSans(.semiBold, size: 16))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 48)
                    .background(appColors.buttonGradient)
                    .cornerRadius(24)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(20)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
        
    private var periodEntries: [MoodEntry] {
        dataManager.getEntriesForPeriod(selectedPeriod)
    }
    
    private var averageTemperature: Double {
        guard !periodEntries.isEmpty else { return 0 }
        let sum = periodEntries.reduce(0) { $0 + $1.temperature }
        return sum / Double(periodEntries.count)
    }
    
    private var mostCommonWeather: WeatherType? {
        let weatherCounts = Dictionary(grouping: periodEntries, by: { $0.weather })
            .mapValues { $0.count }
        
        return weatherCounts.max(by: { $0.value < $1.value })?.key
    }
    
    private var mostCommonMood: MoodType? {
        let moodCounts = Dictionary(grouping: periodEntries, by: { $0.mood })
            .mapValues { $0.count }
        
        return moodCounts.max(by: { $0.value < $1.value })?.key
    }
    
    private var moodData: [MoodChartData] {
        let moodCounts = Dictionary(grouping: periodEntries, by: { $0.mood })
            .mapValues { $0.count }
        
        return MoodType.allCases.map { mood in
            MoodChartData(mood: mood, count: moodCounts[mood] ?? 0)
        }
    }
    
    private var weatherData: [WeatherChartData] {
        let weatherCounts = Dictionary(grouping: periodEntries, by: { $0.weather })
            .mapValues { $0.count }
        
        return weatherCounts.map { weather, count in
            WeatherChartData(weather: weather, count: count)
        }.sorted { $0.count > $1.count }
    }
    
    private var temperatureData: [TemperatureChartData] {
        return periodEntries
            .sorted { $0.date < $1.date }
            .map { entry in
                TemperatureChartData(date: entry.date, temperature: entry.temperature)
            }
    }
    
    private func colorForWeather(_ weather: WeatherType) -> Color {
        switch weather {
        case .sunny: return appColors.primaryOrange
        case .partlyCloudy: return appColors.primaryBlue
        case .cloudy: return appColors.textSecondary
        case .rainy: return appColors.accentGreen
        case .stormy: return appColors.accentPurple
        case .snowy: return appColors.backgroundWhite
        case .foggy: return Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.7)
        case .windy: return appColors.accentPink
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.builderSans(.bold, size: 20))
                    .foregroundColor(appColors.textPrimary)
                
                Text(title)
                    .font(.builderSans(.medium, size: 12))
                    .foregroundColor(appColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(12)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 5, x: 0, y: 2)
    }
}

struct DateListView: View {
    let dates: [Date]
    let title: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(dates, id: \.self) { date in
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.builderSans(.regular, size: 16))
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct MoodChartData {
    let mood: MoodType
    let count: Int
}

struct WeatherChartData {
    let weather: WeatherType
    let count: Int
}

struct TemperatureChartData {
    let date: Date
    let temperature: Double
}

