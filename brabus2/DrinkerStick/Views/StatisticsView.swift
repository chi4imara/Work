import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: DrinkViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.drinks.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "chart.bar")
                            .font(.system(size: 80))
                            .foregroundColor(ColorTheme.primaryPink.opacity(0.6))
                        
                        Text("Add at least one drink to see statistics")
                            .font(.playfair(20, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            HStack(spacing: 16) {
                                StatCard(
                                    title: "Total Drinks",
                                    value: "\(viewModel.totalDrinks)",
                                    icon: "wineglass",
                                    color: ColorTheme.accentBlue
                                )
                                
                                StatCard(
                                    title: "Average Strength",
                                    value: String(format: "%.1f%%", viewModel.averageStrength),
                                    icon: "thermometer",
                                    color: ColorTheme.accentGreen
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Distribution by Type")
                                    .font(.playfair(20, weight: .semibold))
                                    .foregroundColor(ColorTheme.textPrimary)
                                    .padding(.horizontal, 20)
                                
                                TypesChartView(data: viewModel.drinksByType)
                                    .frame(height: 200)
                                    .padding(.horizontal, 20)
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Distribution by Country")
                                    .font(.playfair(20, weight: .semibold))
                                    .foregroundColor(ColorTheme.textPrimary)
                                    .padding(.horizontal, 20)
                                
                                CountriesListView(data: viewModel.drinksByCountry)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.playfair(24, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Text(title)
                .font(.playfair(14, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct TypesChartView: View {
    let data: [DrinkType: Int]
    
    var chartData: [(type: String, count: Int, color: Color)] {
        let colors = [
            ColorTheme.primaryPink,
            ColorTheme.accentBlue,
            ColorTheme.accentGreen,
            ColorTheme.accentPurple,
            ColorTheme.primaryYellow,
            ColorTheme.warning
        ]
        
        return data.sorted { $0.value > $1.value }
            .enumerated()
            .map { index, item in
                (
                    type: item.key.displayName,
                    count: item.value,
                    color: colors[index % colors.count]
                )
            }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(Array(chartData.enumerated()), id: \.offset) { index, item in
                            VStack(spacing: 4) {
                                Text("\(item.count)")
                                    .font(.playfair(12, weight: .semibold))
                                    .foregroundColor(ColorTheme.textSecondary)
                                
                                Rectangle()
                                    .fill(item.color)
                                    .frame(width: 30, height: CGFloat(item.count) * 20 + 20)
                                    .cornerRadius(4)
                                
                                Text(String(item.type.prefix(3)))
                                    .font(.playfair(10, weight: .medium))
                                    .foregroundColor(ColorTheme.textTertiary)
                                    .rotationEffect(.degrees(-45))
                                    .frame(width: 30, height: 30)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ColorTheme.cardBackground)
            .cornerRadius(12)
        }
    }
}

struct CountriesListView: View {
    let data: [String: Int]
    
    var sortedData: [(country: String, count: Int)] {
        data.sorted { $0.value > $1.value }
            .map { (country: $0.key, count: $0.value) }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(sortedData.enumerated()), id: \.offset) { index, item in
                HStack {
                    Text(item.country)
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Spacer()
                    
                    Text("\(item.count)")
                        .font(.playfair(16, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryYellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(ColorTheme.primaryYellow.opacity(0.2))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ColorTheme.cardBackground)
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    StatisticsView(viewModel: DrinkViewModel())
}
