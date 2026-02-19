import SwiftUI

struct SimpleLineChart: View {
    let results: [WorkoutResult]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.secondaryBackground.opacity(0.3))
                
                if results.count >= 2 {
                    VStack {
                        ZStack {
                            GridLinesView(geometry: geometry)
                            
                            LineChartPath(results: results, geometry: geometry)
                                .stroke(AppColors.lightBlue, lineWidth: 3)
                            
                            DataPointsView(results: results, geometry: geometry)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        
                        ChartLabelsView(results: results)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                    }
                }
            }
        }
    }
}

struct GridLinesView: View {
    let geometry: GeometryProxy
    
    var body: some View {
        Path { path in
            let width = geometry.size.width - 40
            let height = geometry.size.height - 60
            
            for i in 0...4 {
                let y = CGFloat(i) * height / 4 + 20
                path.move(to: CGPoint(x: 20, y: y))
                path.addLine(to: CGPoint(x: width + 20, y: y))
            }
            
            for i in 0...4 {
                let x = CGFloat(i) * width / 4 + 20
                path.move(to: CGPoint(x: x, y: 20))
                path.addLine(to: CGPoint(x: x, y: height + 20))
            }
        }
        .stroke(AppColors.secondaryText.opacity(0.2), lineWidth: 1)
    }
}

struct LineChartPath: Shape {
    let results: [WorkoutResult]
    let geometry: GeometryProxy
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = geometry.size.width - 40
        let height = geometry.size.height - 60
        
        let minWeight = results.map { $0.weight }.min() ?? 0
        let maxWeight = results.map { $0.weight }.max() ?? 100
        let weightRange = maxWeight - minWeight
        
        guard weightRange > 0 else { return path }
        
        for (index, result) in results.enumerated() {
            let x = CGFloat(index) * width / CGFloat(results.count - 1) + 20
            let normalizedWeight = (result.weight - minWeight) / weightRange
            let y = height - (normalizedWeight * height) + 20
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

struct DataPointsView: View {
    let results: [WorkoutResult]
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            let width = geometry.size.width - 40
            let height = geometry.size.height - 60
            
            let minWeight = results.map { $0.weight }.min() ?? 0
            let maxWeight = results.map { $0.weight }.max() ?? 100
            let weightRange = maxWeight - minWeight
            
            if weightRange > 0 {
                ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                    let x = CGFloat(index) * width / CGFloat(results.count - 1) + 20
                    let normalizedWeight = (result.weight - minWeight) / weightRange
                    let y = height - (normalizedWeight * height) + 20
                    
                    Circle()
                        .fill(AppColors.orange)
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                }
            }
        }
    }
}

struct ChartLabelsView: View {
    let results: [WorkoutResult]
    
    var body: some View {
        HStack {
            if let first = results.first {
                Text(first.formattedDate)
                    .font(.playfairDisplay(size: 10))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            if let last = results.last {
                Text(last.formattedDate)
                    .font(.playfairDisplay(size: 10))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
}

#Preview {
    let sampleResults = [
        WorkoutResult(weight: 80, reps: 5, date: Date().addingTimeInterval(-86400 * 7)),
        WorkoutResult(weight: 85, reps: 5, date: Date().addingTimeInterval(-86400 * 5)),
        WorkoutResult(weight: 90, reps: 4, date: Date().addingTimeInterval(-86400 * 3)),
        WorkoutResult(weight: 87, reps: 5, date: Date())
    ]
    
    SimpleLineChart(results: sampleResults)
        .frame(height: 200)
        .padding()
        .background(AppColors.primaryGradient)
}
