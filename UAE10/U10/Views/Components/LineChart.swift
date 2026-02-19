import SwiftUI

struct LineChart: View {
    let dataPoints: [(Date, Double)]
    let zone: BodyZone
    
    private var sortedData: [(Date, Double)] {
        dataPoints.sorted { $0.0 < $1.0 }
    }
    
    private var minValue: Double {
        sortedData.map { $0.1 }.min() ?? 0
    }
    
    private var maxValue: Double {
        sortedData.map { $0.1 }.max() ?? 0
    }
    
    private var valueRange: Double {
        max(maxValue - minValue, 1)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if sortedData.count < 2 {
                EmptyChartView()
            } else {
                GeometryReader { geometry in
                    ZStack {
                        ChartGrid(geometry: geometry)
                        
                        ChartLine(
                            dataPoints: sortedData,
                            geometry: geometry,
                            minValue: minValue,
                            valueRange: valueRange
                        )
                        
                        ForEach(Array(sortedData.enumerated()), id: \.offset) { index, point in
                            ChartPoint(
                                point: point,
                                index: index,
                                geometry: geometry,
                                dataCount: sortedData.count,
                                minValue: minValue,
                                valueRange: valueRange,
                                zone: zone
                            )
                        }
                    }
                }
                .frame(height: 200)
                
                HStack {
                    if let firstDate = sortedData.first?.0 {
                        Text(formatAxisDate(firstDate))
                            .font(.ubuntu(10))
                            .foregroundColor(AppColors.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    if let lastDate = sortedData.last?.0 {
                        Text(formatAxisDate(lastDate))
                            .font(.ubuntu(10))
                            .foregroundColor(AppColors.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 5)
            }
        }
    }
    
    private func formatAxisDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: date)
    }
}

struct EmptyChartView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(AppColors.white.opacity(0.4))
            
            Text("Not enough data for chart")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.white.opacity(0.6))
            
            Text("Add at least 2 measurements to see progress")
                .font(.ubuntu(12))
                .foregroundColor(AppColors.white.opacity(0.4))
                .multilineTextAlignment(.center)
        }
        .frame(height: 200)
    }
}

struct ChartGrid: View {
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            ForEach(0..<5) { i in
                Path { path in
                    let y = CGFloat(i) * geometry.size.height / 4
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                .stroke(AppColors.white.opacity(0.1), lineWidth: 1)
            }
            
            ForEach(0..<5) { i in
                Path { path in
                    let x = CGFloat(i) * geometry.size.width / 4
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                .stroke(AppColors.white.opacity(0.1), lineWidth: 1)
            }
        }
    }
}

struct ChartLine: View {
    let dataPoints: [(Date, Double)]
    let geometry: GeometryProxy
    let minValue: Double
    let valueRange: Double
    
    var body: some View {
        Path { path in
            guard dataPoints.count > 1 else { return }
            
            let points = dataPoints.enumerated().map { index, point in
                CGPoint(
                    x: CGFloat(index) * geometry.size.width / CGFloat(dataPoints.count - 1),
                    y: geometry.size.height - CGFloat((point.1 - minValue) / valueRange) * geometry.size.height
                )
            }
            
            if let firstPoint = points.first {
                path.move(to: firstPoint)
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
            }
        }
        .stroke(
            LinearGradient(
                colors: [AppColors.lightBlue, AppColors.orange],
                startPoint: .leading,
                endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
        )
    }
}

struct ChartPoint: View {
    let point: (Date, Double)
    let index: Int
    let geometry: GeometryProxy
    let dataCount: Int
    let minValue: Double
    let valueRange: Double
    let zone: BodyZone
    
    @State private var showTooltip = false
    
    var body: some View {
        let x = CGFloat(index) * geometry.size.width / CGFloat(dataCount - 1)
        let y = geometry.size.height - CGFloat((point.1 - minValue) / valueRange) * geometry.size.height
        
        ZStack {
            Circle()
                .fill(AppColors.orange)
                .frame(width: 8, height: 8)
                .overlay(
                    Circle()
                        .stroke(AppColors.white, lineWidth: 2)
                )
                .scaleEffect(showTooltip ? 1.5 : 1.0)
            
            if showTooltip {
                VStack(spacing: 4) {
                    Text("\(String(format: "%.1f", point.1)) \(zone.unit)")
                        .font(.ubuntu(12, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Text(formatTooltipDate(point.0))
                        .font(.ubuntu(10))
                        .foregroundColor(AppColors.white.opacity(0.8))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.darkBlue.opacity(0.9))
                .cornerRadius(8)
                .offset(y: -40)
            }
        }
        .position(x: x, y: y)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                showTooltip.toggle()
            }
        }
    }
    
    private func formatTooltipDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
