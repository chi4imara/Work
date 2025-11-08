import SwiftUI

struct StatisticsView: View {
    @ObservedObject var dreamStore: DreamStore
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(.dreamTitle)
                        .foregroundColor(.dreamWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if dreamStore.dreams.isEmpty {
                    StatisticsEmptyStateView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            OverviewStatsView(dreamStore: dreamStore)
                            
                            TagDistributionChartView(dreamStore: dreamStore)
                            
                            MonthlyDreamsChartView(dreamStore: dreamStore)
                            
                            Spacer(minLength: 50)
                        }
                        .padding(20)
                    }
                }
            }
        }
    }
}

struct OverviewStatsView: View {
    @ObservedObject var dreamStore: DreamStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.dreamHeadline)
                .foregroundColor(.dreamWhite)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCardView(
                    title: "Total Dreams",
                    value: "\(dreamStore.totalDreamsCount)",
                    icon: "moon.stars.fill",
                    color: .dreamYellow
                )
                
                StatCardView(
                    title: "Favorites",
                    value: "\(dreamStore.favoriteDreams.count)",
                    icon: "star.fill",
                    color: .dreamPink
                )
                
                StatCardView(
                    title: "Most Used Tag",
                    value: dreamStore.mostFrequentTag?.capitalized ?? "None",
                    icon: "tag.fill",
                    color: .dreamMint
                )
                
                StatCardView(
                    title: "Dreams/Week",
                    value: String(format: "%.1f", dreamStore.averageDreamsPerWeek),
                    icon: "calendar",
                    color: .dreamPurple
                )
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
            }
            
            Text(value)
                .font(.dreamHeadline)
                .foregroundColor(.dreamWhite)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Text(title)
                .font(.dreamCaption)
                .foregroundColor(.dreamWhite.opacity(0.7))
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct TagDistributionChartView: View {
    @ObservedObject var dreamStore: DreamStore
    
    private var chartData: [TagData] {
        let stats = dreamStore.tagStatistics
        let sortedStats = stats.sorted { $0.value > $1.value }
        let topTags = Array(sortedStats.prefix(6))
        
        return topTags.map { TagData(tag: $0.key, count: $0.value) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tag Distribution")
                .font(.dreamHeadline)
                .foregroundColor(.dreamWhite)
            
            if chartData.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 40))
                        .foregroundColor(.dreamWhite.opacity(0.5))
                    
                    Text("No tag data available")
                        .font(.dreamBody)
                        .foregroundColor(.dreamWhite.opacity(0.7))
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(Color.cardBackground)
                .cornerRadius(12)
            } else {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        ForEach(chartData, id: \.tag) { data in
                            TagBarView(data: data, maxCount: chartData.first?.count ?? 1)
                        }
                    }
                    .padding(16)
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct TagBarView: View {
    let data: TagData
    let maxCount: Int
    
    private var percentage: Double {
        guard maxCount > 0 else { return 0 }
        return Double(data.count) / Double(maxCount)
    }
    
    var body: some View {
        HStack {
            Text(data.tag.capitalized)
                .font(.dreamCaption)
                .foregroundColor(.dreamWhite)
                .frame(width: 80, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.dreamWhite.opacity(0.2))
                        .frame(height: 20)
                        .cornerRadius(10)
                    
                    Rectangle()
                        .fill(Color.tagColor(for: data.tag))
                        .frame(width: geometry.size.width * percentage, height: 20)
                        .cornerRadius(10)
                }
            }
            .frame(height: 20)
            
            Text("\(data.count)")
                .font(.dreamCaption)
                .foregroundColor(.dreamWhite)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

struct MonthlyDreamsChartView: View {
    @ObservedObject var dreamStore: DreamStore
    
    private var chartData: [MonthData] {
        return dreamStore.monthlyDreamCounts().map { MonthData(month: $0.month, count: $0.count) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dreams by Month")
                .font(.dreamHeadline)
                .foregroundColor(.dreamWhite)
            
            if chartData.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 40))
                        .foregroundColor(.dreamWhite.opacity(0.5))
                    
                    Text("No monthly data available")
                        .font(.dreamBody)
                        .foregroundColor(.dreamWhite.opacity(0.7))
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(Color.cardBackground)
                .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(chartData, id: \.month) { data in
                            MonthBarView(data: data, maxCount: chartData.map { $0.count }.max() ?? 1)
                        }
                    }
                    .padding(16)
                }
                .background(Color.cardBackground)
                .cornerRadius(12)
            }
        }
    }
}

struct MonthBarView: View {
    let data: MonthData
    let maxCount: Int
    
    private var height: CGFloat {
        guard maxCount > 0 else { return 0 }
        let percentage = Double(data.count) / Double(maxCount)
        return CGFloat(percentage * 120) 
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(data.count)")
                .font(.dreamSmall)
                .foregroundColor(.dreamWhite)
            
            Rectangle()
                .fill(Color.dreamYellow)
                .frame(width: 30, height: max(height, 4))
                .cornerRadius(4)
            
            Text(String(data.month.prefix(3)))
                .font(.dreamSmall)
                .foregroundColor(.dreamWhite.opacity(0.7))
                .rotationEffect(.degrees(-45))
        }
        .frame(width: 40)
    }
}

struct StatisticsEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(.dreamYellow.opacity(0.6))
            
            Text("Not Enough Data")
                .font(.dreamHeadline)
                .foregroundColor(.dreamWhite)
            
            Text("Add more dreams to see detailed statistics about your sleep patterns and dream themes")
                .font(.dreamBody)
                .foregroundColor(.dreamWhite.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct TagData {
    let tag: String
    let count: Int
}

struct MonthData {
    let month: String
    let count: Int
}

#Preview {
    StatisticsView(dreamStore: DreamStore())
}
