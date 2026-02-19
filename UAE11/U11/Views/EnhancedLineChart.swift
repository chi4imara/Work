import SwiftUI

struct EnhancedLineChart: View {
    let results: [WorkoutResult]
    @State private var animated = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryBackground.opacity(0.2))
                
                if results.count >= 2 {
                    VStack(spacing: 0) {
                        ZStack {
                            EnhancedGridLines(geometry: geometry, results: results)
                            
                            AreaChartPath(results: results, geometry: geometry)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            AppColors.lightBlue.opacity(0.3),
                                            AppColors.lightBlue.opacity(0.05)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .opacity(animated ? 1.0 : 0.0)
                            
                            EnhancedLineChartPath(results: results, geometry: geometry)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            AppColors.lightBlue,
                                            AppColors.orange
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                                )
                                .opacity(animated ? 1.0 : 0.0)
                            
                            EnhancedDataPoints(results: results, geometry: geometry)
                                .opacity(animated ? 1.0 : 0.0)
                        }
                        .frame(height: geometry.size.height - 50)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        EnhancedXAxisLabels(results: results)
                            .frame(height: 30)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animated = true
            }
        }
    }
}

struct EnhancedGridLines: View {
    let geometry: GeometryProxy
    let results: [WorkoutResult]
    
    private var minWeight: Double {
        let weights = results.map { $0.weight }
        return (weights.min() ?? 0) - 5
    }
    
    private var maxWeight: Double {
        let weights = results.map { $0.weight }
        return (weights.max() ?? 100) + 5
    }
    
    private var weightRange: Double {
        maxWeight - minWeight
    }
    
    var body: some View {
        ZStack {
            ForEach(0...4, id: \.self) { i in
                let weight = minWeight + (Double(i) * weightRange / 4)
                let y = CGFloat(geometry.size.height - 50) - (CGFloat(i) * (geometry.size.height - 50) / 4)
                
                VStack(spacing: 0) {
                    Text("\(Int(weight))")
                        .font(.playfairDisplay(size: 10, weight: .medium))
                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 20, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width - 20, y: 0))
                    }
                    .stroke(AppColors.secondaryText.opacity(0.15), lineWidth: 1)
                }
                .offset(y: y - 10)
            }
        }
    }
}

struct EnhancedLineChartPath: Shape {
    let results: [WorkoutResult]
    let geometry: GeometryProxy
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = geometry.size.width - 40
        let height = geometry.size.height - 50
        
        let weights = results.map { $0.weight }
        let minWeight = (weights.min() ?? 0) - 5
        let maxWeight = (weights.max() ?? 100) + 5
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

struct AreaChartPath: Shape {
    let results: [WorkoutResult]
    let geometry: GeometryProxy
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = geometry.size.width - 40
        let height = geometry.size.height - 50
        
        let weights = results.map { $0.weight }
        let minWeight = (weights.min() ?? 0) - 5
        let maxWeight = (weights.max() ?? 100) + 5
        let weightRange = maxWeight - minWeight
        
        guard weightRange > 0 else { return path }
        
        path.move(to: CGPoint(x: 20, y: height + 20))
        
        for (index, result) in results.enumerated() {
            let x = CGFloat(index) * width / CGFloat(results.count - 1) + 20
            let normalizedWeight = (result.weight - minWeight) / weightRange
            let y = height - (normalizedWeight * height) + 20
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        let lastX = CGFloat(results.count - 1) * width / CGFloat(results.count - 1) + 20
        path.addLine(to: CGPoint(x: lastX, y: height + 20))
        
        path.closeSubpath()
        
        return path
    }
}

struct EnhancedDataPoints: View {
    let results: [WorkoutResult]
    let geometry: GeometryProxy
    
    private var minWeight: Double {
        let weights = results.map { $0.weight }
        return (weights.min() ?? 0) - 5
    }
    
    private var maxWeight: Double {
        let weights = results.map { $0.weight }
        return (weights.max() ?? 100) + 5
    }
    
    private var weightRange: Double {
        maxWeight - minWeight
    }
    
    var body: some View {
        ZStack {
            let width = geometry.size.width - 40
            let height = geometry.size.height - 50
            
            ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                let x = CGFloat(index) * width / CGFloat(results.count - 1) + 20
                let normalizedWeight = (result.weight - minWeight) / weightRange
                let y = height - (normalizedWeight * height) + 20
                
                VStack(spacing: 4) {
                    Text("\(Int(result.weight))")
                        .font(.playfairDisplay(size: 11, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(AppColors.lightBlue.opacity(0.9))
                        )
                        .offset(y: -25)
                        .opacity(index == results.count - 1 ? 1.0 : 0.0)
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.primaryText)
                            .frame(width: 12, height: 12)
                        
                        Circle()
                            .fill(AppColors.orange)
                            .frame(width: 8, height: 8)
                    }
                }
                .position(x: x, y: y)
            }
        }
    }
}

struct EnhancedXAxisLabels: View {
    let results: [WorkoutResult]
    
    var body: some View {
        HStack {
            if let first = results.first {
                VStack(alignment: .leading, spacing: 2) {
                    Text(first.formattedDate)
                        .font(.playfairDisplay(size: 10, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            if results.count > 2 {
                let middle = results[results.count / 2]
                VStack(alignment: .center, spacing: 2) {
                    Text(middle.formattedDate)
                        .font(.playfairDisplay(size: 10, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            if let last = results.last {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(last.formattedDate)
                        .font(.playfairDisplay(size: 10, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
    }
}

#Preview {
    let sampleResults = [
        WorkoutResult(weight: 80, reps: 5, date: Date().addingTimeInterval(-86400 * 7)),
        WorkoutResult(weight: 85, reps: 5, date: Date().addingTimeInterval(-86400 * 5)),
        WorkoutResult(weight: 90, reps: 4, date: Date().addingTimeInterval(-86400 * 3)),
        WorkoutResult(weight: 87, reps: 5, date: Date().addingTimeInterval(-86400 * 1)),
        WorkoutResult(weight: 92, reps: 5, date: Date())
    ]
    
    EnhancedLineChart(results: sampleResults)
        .frame(height: 240)
        .padding()
        .background(AppColors.primaryGradient)
}

