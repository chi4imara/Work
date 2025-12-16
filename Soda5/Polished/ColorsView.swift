import SwiftUI

struct ColorsView: View {
    @EnvironmentObject var manicureStore: ManicureStore
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    private var availableYears: [Int] {
        let years = Set(manicureStore.manicures.map { Calendar.current.component(.year, from: $0.date) })
        return Array(years).sorted(by: >)
    }
    
    private var filteredColorStatistics: [ColorStatistic] {
        let filteredManicures = manicureStore.manicures.filter { manicure in
            Calendar.current.component(.year, from: manicure.date) == selectedYear
        }
        
        let groupedByColor = Dictionary(grouping: filteredManicures) { $0.color.lowercased() }
        
        return groupedByColor.map { (color, manicures) in
            let sortedManicures = manicures.sorted { $0.date > $1.date }
            return ColorStatistic(
                color: color.capitalized,
                count: manicures.count,
                lastUsed: sortedManicures.first?.date ?? Date(),
                manicures: sortedManicures
            )
        }.sorted { $0.color < $1.color }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My Colors")
                            .font(.playfairDisplay(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if !availableYears.isEmpty {
                        yearFilterView
                    }
                    
                    if manicureStore.manicures.isEmpty {
                        emptyStateView
                    } else if filteredColorStatistics.isEmpty {
                        noDataForYearView
                    } else {
                        colorsList
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var yearFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(availableYears, id: \.self) { year in
                    Button(action: { selectedYear = year }) {
                        Text("\(year)")
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(selectedYear == year ? AppColors.contrastText : AppColors.blueText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                selectedYear == year ?
                                AnyShapeStyle(AppColors.purpleGradient) :
                                    AnyShapeStyle(AppColors.backgroundWhite.opacity(0.6))
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "paintpalette")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No data yet")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add at least one record to see the list of used colors.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var noDataForYearView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No colors for \(selectedYear)")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Try selecting a different year or add new records.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var colorsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredColorStatistics) { colorStat in
                    NavigationLink(destination: ColorDetailView(colorStatistic: colorStat)) {
                        ColorCardView(colorStatistic: colorStat, dateFormatter: dateFormatter)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

struct ColorCardView: View {
    let colorStatistic: ColorStatistic
    let dateFormatter: DateFormatter
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(AppColors.purpleGradient)
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(colorStatistic.color.prefix(2)).uppercased())
                        .font(.playfairDisplay(16, weight: .bold))
                        .foregroundColor(AppColors.contrastText)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(colorStatistic.color)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(colorStatistic.count) time\(colorStatistic.count == 1 ? "" : "s")")
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.blueText)
                
                Text("last used: \(dateFormatter.string(from: colorStatistic.lastUsed))")
                    .font(.playfairDisplay(12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
