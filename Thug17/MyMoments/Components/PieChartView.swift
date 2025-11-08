import SwiftUI

struct PieChartView: View {
    let tagStatistics: [(tag: String, count: Int)]
    @State private var selectedSegment: String? = nil
    
    private var totalCount: Int {
        tagStatistics.reduce(0) { $0 + $1.count }
    }
    
    private var chartData: [(tag: String, count: Int, percentage: Double, startAngle: Double, endAngle: Double)] {
        guard totalCount > 0 else { return [] }
        
        var data: [(tag: String, count: Int, percentage: Double, startAngle: Double, endAngle: Double)] = []
        var currentAngle: Double = -90
        
        for stat in tagStatistics {
            let percentage = Double(stat.count) / Double(totalCount)
            let angle = percentage * 360
            let endAngle = currentAngle + angle
            
            data.append((
                tag: stat.tag,
                count: stat.count,
                percentage: percentage,
                startAngle: currentAngle,
                endAngle: endAngle
            ))
            
            currentAngle = endAngle
        }
        
        return data
    }
    
    var body: some View {
        ZStack {
            ForEach(chartData, id: \.tag) { data in
                PieSliceView(
                    startAngle: .degrees(data.startAngle),
                    endAngle: .degrees(data.endAngle),
                    color: Color.tagColor(for: data.tag),
                    isSelected: selectedSegment == data.tag
                )
            }
            
            VStack(spacing: 4) {
                Text("\(totalCount)")
                    .font(.nunitoBold(size: 24))
                    .foregroundColor(.textPrimary)
                
                Text("Total")
                    .font(.nunitoRegular(size: 12))
                    .foregroundColor(.textSecondary)
            }
            
            Circle()
                .fill(Color.clear)
                .frame(width: 180, height: 180)
                .contentShape(Circle())
                .onTapGesture { location in
                    handleTap(at: location)
                }
        }
        .frame(width: 180, height: 180)
    }
    
    private func handleTap(at location: CGPoint) {
        let center = CGPoint(x: 90, y: 90)
        let dx = location.x - center.x
        let dy = location.y - center.y
        let distance = sqrt(dx * dx + dy * dy)
        
        guard distance > 50 && distance < 90 else { return }
        
        let angle = atan2(dy, dx) * 180 / .pi
        let normalizedAngle = (angle + 90).truncatingRemainder(dividingBy: 360)
        let positiveAngle = normalizedAngle < 0 ? normalizedAngle + 360 : normalizedAngle
        
        for data in chartData {
            let startAngle = data.startAngle < 0 ? data.startAngle + 360 : data.startAngle
            let endAngle = data.endAngle < 0 ? data.endAngle + 360 : data.endAngle
            
            if positiveAngle >= startAngle && positiveAngle <= endAngle {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedSegment = selectedSegment == data.tag ? nil : data.tag
                }
                break
            }
        }
    }
}

struct PieSliceView: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    let isSelected: Bool
    
    private var normalizedStartAngle: Double {
        let start = startAngle.degrees
        return start < 0 ? start + 360 : start
    }
    
    private var normalizedEndAngle: Double {
        let end = endAngle.degrees
        return end < 0 ? end + 360 : end
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: normalizedStartAngle / 360, to: normalizedEndAngle / 360)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: isSelected ? 60 : 50,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
            
            Circle()
                .trim(from: normalizedStartAngle / 360, to: normalizedEndAngle / 360)
                .stroke(
                    Color.backgroundWhite,
                    style: StrokeStyle(
                        lineWidth: isSelected ? 40 : 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
    }
}

struct SimplePieChartView: View {
    let tagStatistics: [(tag: String, count: Int)]
    
    private var totalCount: Int {
        tagStatistics.reduce(0) { $0 + $1.count }
    }
    
    private var chartData: [(tag: String, count: Int, startAngle: Double, endAngle: Double)] {
        guard totalCount > 0 else { return [] }
        
        var data: [(tag: String, count: Int, startAngle: Double, endAngle: Double)] = []
        var currentAngle: Double = -90 
        
        for stat in tagStatistics {
            let percentage = Double(stat.count) / Double(totalCount)
            let angle = percentage * 360
            let endAngle = currentAngle + angle
            
            data.append((
                tag: stat.tag,
                count: stat.count,
                startAngle: currentAngle,
                endAngle: endAngle
            ))
            
            currentAngle = endAngle
        }
        
        return data
    }
    
    var body: some View {
        ZStack {
            ForEach(chartData, id: \.tag) { data in
                Circle()
                    .trim(from: data.startAngle / 360, to: data.endAngle / 360)
                    .stroke(
                        Color.tagColor(for: data.tag),
                        style: StrokeStyle(lineWidth: 40, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
            }
            
            Circle()
                .fill(Color.backgroundWhite)
                .frame(width: 100, height: 100)
            
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

#Preview {
    let sampleData = [
        (tag: "work", count: 15),
        (tag: "travel", count: 8),
        (tag: "family", count: 12),
        (tag: "friends", count: 6),
        (tag: "hobby", count: 4)
    ]
    
    VStack(spacing: 20) {
        PieChartView(tagStatistics: sampleData)
        
        SimplePieChartView(tagStatistics: sampleData)
    }
    .padding()
}
