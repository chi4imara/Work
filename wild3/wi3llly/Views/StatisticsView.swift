import SwiftUI
import Charts
import CoreGraphics

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.builderSans(.bold, size: 28))
                        .foregroundColor(Color.app.textPrimary)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if !viewModel.hasEnoughData() {
                    EmptyStatisticsView()
                    
                    Spacer()
                } else {
                    statisticsContent
                }
            }
        }
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                OverviewStatsView(dreamCount: viewModel.dreamCount, tagCount: viewModel.tagCount)
                
                FrequentTagsView(tagFrequencies: viewModel.tagFrequencies)
                
                DreamsOverTimeView(dreamsByDate: viewModel.dreamsByDate)
                
                DreamsByTagsView(tagFrequencies: viewModel.tagFrequencies)
            }
            .padding(16)
            .padding(.bottom, 84)
        }
    }
}

struct OverviewStatsView: View {
    let dreamCount: Int
    let tagCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(Color.app.textPrimary)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Dreams",
                    value: "\(dreamCount)",
                    icon: "moon.stars.fill",
                    color: Color.app.primaryPurple
                )
                
                StatCard(
                    title: "Unique Tags",
                    value: "\(tagCount)",
                    icon: "tag.fill",
                    color: Color.app.accentPink
                )
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
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.builderSans(.bold, size: 24))
                .foregroundColor(Color.app.textPrimary)
            
            Text(title)
                .font(.builderSans(.medium, size: 12))
                .foregroundColor(Color.app.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.app.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.app.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct FrequentTagsView: View {
    let tagFrequencies: [(String, Int)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Most Frequent Tags")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(Color.app.textPrimary)
            
            if tagFrequencies.isEmpty {
                Text("No tags with dreams yet")
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(Color.app.textTertiary)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.app.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.app.cardBorder, lineWidth: 1)
                            )
                    )
            } else {
                TagCloudView(tagFrequencies: tagFrequencies)
            }
        }
    }
}

struct TagCloudView: View {
    let tagFrequencies: [(String, Int)]
    
    private let colors = [
        Color.app.primaryPurple,
        Color.app.accentPink,
        Color.app.accentGreen,
        Color.app.accentOrange,
        Color.app.primaryBlue
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(tagFrequencies.enumerated()), id: \.offset) { index, tagData in
                let (tagName, count) = tagData
                let fontSize = max(12, min(24, 12 + count * 2))
                let color = colors[index % colors.count]
                
                HStack {
                    Text(tagName.capitalized)
                        .font(.builderSans(.semiBold, size: CGFloat(fontSize)))
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    Text("\(count)")
                        .font(.builderSans(.medium, size: 14))
                        .foregroundColor(Color.app.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(color.opacity(0.1))
                        )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.app.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.app.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct DreamsOverTimeView: View {
    let dreamsByDate: [DreamDateData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dreams Over Time (Last 30 Days)")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(Color.app.textPrimary)
            
            if dreamsByDate.isEmpty {
                Text("No dream data available")
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(Color.app.textTertiary)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.app.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.app.cardBorder, lineWidth: 1)
                            )
                    )
            } else {
                Chart(dreamsByDate) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Dreams", data.count)
                    )
                    .foregroundStyle(Color.app.primaryPurple)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    PointMark(
                        x: .value("Date", data.date),
                        y: .value("Dreams", data.count)
                    )
                    .foregroundStyle(Color.app.primaryPurple)
                    .symbolSize(50)
                }
                .frame(height: 200)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.app.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.app.cardBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
}

struct DreamsByTagsView: View {
    let tagFrequencies: [(String, Int)]
    
    private var tagData: [TagChartData] {
        let colors = [
            Color.app.primaryPurple,
            Color.app.accentPink,
            Color.app.accentGreen,
            Color.app.accentOrange,
            Color.app.primaryBlue
        ]
        
        return tagFrequencies.prefix(5).enumerated().map { index, tagFreq in
            TagChartData(
                name: tagFreq.0,
                count: tagFreq.1,
                color: colors[index % colors.count]
            )
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dreams by Tags (Top 5)")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(Color.app.textPrimary)
            
            if tagData.isEmpty {
                Text("No tag data available")
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(Color.app.textTertiary)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.app.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.app.cardBorder, lineWidth: 1)
                            )
                    )
            } else {
                VStack(spacing: 12) {
                    PieChartView(data: tagData)
                        .frame(height: 200)
                    
                    VStack(spacing: 8) {
                        ForEach(tagData, id: \.name) { data in
                            HStack {
                                Circle()
                                    .fill(data.color)
                                    .frame(width: 12, height: 12)
                                
                                Text(data.name.capitalized)
                                    .font(.builderSans(.medium, size: 14))
                                    .foregroundColor(Color.app.textPrimary)
                                
                                Spacer()
                                
                                Text("\(data.count)")
                                    .font(.builderSans(.semiBold, size: 14))
                                    .foregroundColor(Color.app.textSecondary)
                            }
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.app.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.app.cardBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
}

struct PieChartView: View {
    let data: [TagChartData]
    
    private var total: Int {
        data.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = size / 2 - 10
            let innerRadius = radius * 0.5
            
            ZStack {
                ForEach(Array(data.enumerated()), id: \.element.name) { index, item in
                    PieSlice(
                        startAngle: angleForSlice(at: index),
                        endAngle: angleForSlice(at: index + 1),
                        innerRadius: innerRadius,
                        outerRadius: radius
                    )
                    .fill(item.color)
                    .overlay(
                        PieSlice(
                            startAngle: angleForSlice(at: index),
                            endAngle: angleForSlice(at: index + 1),
                            innerRadius: innerRadius,
                            outerRadius: radius
                        )
                        .stroke(Color.app.cardBackground, lineWidth: 2)
                    )
                    .position(center)
                }
                
                Circle()
                    .fill(Color.app.cardBackground)
                    .frame(width: innerRadius * 2, height: innerRadius * 2)
                    .overlay(
                        VStack(spacing: 4) {
                            Text("Total")
                                .font(.builderSans(.medium, size: 12))
                                .foregroundColor(Color.app.textSecondary)
                            Text("\(total)")
                                .font(.builderSans(.bold, size: 18))
                                .foregroundColor(Color.app.textPrimary)
                        }
                    )
                    .position(center)
            }
        }
    }
    
    private func angleForSlice(at index: Int) -> Double {
        guard total > 0 else { return -Double.pi / 2 }
        
        if index == 0 {
            return -Double.pi / 2
        }
        
        let cumulative = data.prefix(index).reduce(0) { $0 + $1.count }
        let angle = (Double(cumulative) / Double(total)) * 2 * Double.pi
        return angle - Double.pi / 2
    }
}

struct PieSlice: Shape {
    let startAngle: Double
    let endAngle: Double
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.addArc(
            center: center,
            radius: outerRadius,
            startAngle: Angle(radians: startAngle),
            endAngle: Angle(radians: endAngle),
            clockwise: false
        )
        
        let innerEndPoint = CGPoint(
            x: center.x + innerRadius * cos(endAngle),
            y: center.y + innerRadius * sin(endAngle)
        )
        path.addLine(to: innerEndPoint)
        
        path.addArc(
            center: center,
            radius: innerRadius,
            startAngle: Angle(radians: endAngle),
            endAngle: Angle(radians: startAngle),
            clockwise: true
        )
        
        path.closeSubpath()
        return path
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.app.textTertiary)
            
            VStack(spacing: 8) {
                Text("Insufficient Data")
                    .font(.builderSans(.semiBold, size: 24))
                    .foregroundColor(Color.app.textPrimary)
                
                Text("Record at least 2 dreams to see statistics")
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(Color.app.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(32)
    }
}

struct DreamDateData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct TagChartData: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let color: Color
}

#Preview {
    StatisticsView()
}
