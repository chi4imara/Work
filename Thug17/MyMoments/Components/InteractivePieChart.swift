import SwiftUI

struct InteractivePieChart: View {
    let tagStatistics: [(tag: String, count: Int)]
    @State private var selectedSegment: String? = nil
    
    private var totalCount: Int {
        tagStatistics.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        ZStack {
            ForEach(Array(tagStatistics.enumerated()), id: \.element.tag) { index, stat in
                PieSegmentView(
                    tag: stat.tag,
                    count: stat.count,
                    totalCount: totalCount,
                    index: index,
                    totalSegments: tagStatistics.count,
                    allStatistics: tagStatistics,
                    isSelected: selectedSegment == stat.tag
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedSegment = selectedSegment == stat.tag ? nil : stat.tag
                    }
                }
            }
            
            Circle()
                .fill(Color.backgroundWhite)
                .frame(width: 100, height: 100)
                .shadow(color: .shadowColor, radius: 2, x: 0, y: 1)
            
            VStack(spacing: 2) {
                Text("\(totalCount)")
                    .font(.nunitoBold(size: 20))
                    .foregroundColor(.textPrimary)
                
                Text("Total")
                    .font(.nunitoRegular(size: 10))
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(width: 160, height: 160)
    }
}

struct PieSegmentView: View {
    let tag: String
    let count: Int
    let totalCount: Int
    let index: Int
    let totalSegments: Int
    let allStatistics: [(tag: String, count: Int)]
    let isSelected: Bool
    let onTap: () -> Void
    
    private var percentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(count) / Double(totalCount)
    }
    
    private var startAngle: Double {
        var cumulativeAngle: Double = -90 
        for i in 0..<index {
            let prevPercentage = Double(allStatistics[i].count) / Double(totalCount)
            cumulativeAngle += prevPercentage * 360
        }
        return cumulativeAngle
    }
    
    private var endAngle: Double {
        return startAngle + (percentage * 360)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: startAngle / 360, to: endAngle / 360)
                .stroke(
                    Color.tagColor(for: tag),
                    style: StrokeStyle(
                        lineWidth: isSelected ? 50 : 40,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
            
            Circle()
                .trim(from: startAngle / 360, to: endAngle / 360)
                .stroke(
                    Color.backgroundWhite,
                    style: StrokeStyle(
                        lineWidth: isSelected ? 30 : 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    let sampleData = [
        (tag: "work", count: 15),
        (tag: "travel", count: 8),
        (tag: "family", count: 12),
        (tag: "friends", count: 6),
        (tag: "hobby", count: 4)
    ]
    
    InteractivePieChart(tagStatistics: sampleData)
        .padding()
}
