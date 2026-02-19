import SwiftUI

struct BarChartView: View {
    let results: [WorkoutResult]
    let isCompact: Bool
    @State private var animated = false
    
    init(results: [WorkoutResult], isCompact: Bool = false) {
        self.results = results
        self.isCompact = isCompact
    }
    
    private var needsScroll: Bool {
        sortedResults.count > 8
    }
    
    private var sortedResults: [WorkoutResult] {
        results.sorted(by: { $0.date < $1.date })
    }
    
    private var minWeight: Double {
        let weights = sortedResults.map { $0.weight }
        return (weights.min() ?? 0) - 5
    }
    
    private var maxWeight: Double {
        let weights = sortedResults.map { $0.weight }
        return (weights.max() ?? 100) + 5
    }
    
    private var weightRange: Double {
        maxWeight - minWeight
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryBackground.opacity(0.2))
                
                if sortedResults.count > 0 {
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .bottom, spacing: isCompact ? 6 : 8) {
                                ForEach(Array(sortedResults.enumerated()), id: \.element.id) { index, result in
                                    VStack(spacing: isCompact ? 4 : 8) {
                                        ZStack(alignment: .bottom) {
                                            RoundedRectangle(cornerRadius: isCompact ? 4 : 6)
                                                .fill(AppColors.secondaryBackground.opacity(0.3))
                                                .frame(
                                                    width: barWidth(geometry: geometry),
                                                    height: geometry.size.height - (isCompact ? 40 : 50)
                                                )
                                            
                                            RoundedRectangle(cornerRadius: isCompact ? 4 : 6)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            AppColors.lightBlue,
                                                            AppColors.orange
                                                        ]),
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                                .frame(
                                                    width: barWidth(geometry: geometry),
                                                    height: animated ? barHeight(for: result, geometry: geometry) : 0
                                                )
                                                .animation(
                                                    .spring(response: 0.6, dampingFraction: 0.8)
                                                    .delay(Double(index) * 0.1),
                                                    value: animated
                                                )
                                            
                                            if animated && (!isCompact || index >= sortedResults.count - 3) {
                                                Text("\(Int(result.weight))")
                                                    .font(.playfairDisplay(size: isCompact ? 9 : 11, weight: .bold))
                                                    .foregroundColor(AppColors.primaryText)
                                                    .padding(.horizontal, isCompact ? 4 : 6)
                                                    .padding(.vertical, isCompact ? 1 : 2)
                                                    .background(
                                                        Capsule()
                                                            .fill(AppColors.lightBlue.opacity(0.9))
                                                    )
                                                    .offset(y: -barHeight(for: result, geometry: geometry) - (isCompact ? 15 : 20))
                                                    .opacity(animated ? 1.0 : 0.0)
                                                    .animation(
                                                        .easeInOut(duration: 0.3)
                                                        .delay(Double(index) * 0.1 + 0.3),
                                                        value: animated
                                                    )
                                            }
                                        }
                                        
                                        Text(shortDateString(from: result.date))
                                            .font(.playfairDisplay(size: isCompact ? 8 : 9, weight: .medium))
                                            .foregroundColor(AppColors.secondaryText)
                                            .frame(width: barWidth(geometry: geometry))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.6)
                                    }
                                    .frame(minWidth: barWidth(geometry: geometry))
                                }
                            }
                            .padding(.horizontal, isCompact ? 12 : 16)
                            .padding(.top, isCompact ? 12 : 20)
                            .padding(.vertical, 8)
                        }
                        .padding(.horizontal,  isCompact ? -12 : -16)
                        .frame(height: geometry.size.height - (isCompact ? 40 : 50))
                        
                        HStack {
                            Text("\(Int(minWeight))")
                                .font(.playfairDisplay(size: isCompact ? 8 : 10, weight: .medium))
                                .foregroundColor(AppColors.secondaryText.opacity(0.6))
                            
                            Spacer()
                            
                            Text("\(Int(maxWeight))")
                                .font(.playfairDisplay(size: isCompact ? 8 : 10, weight: .medium))
                                .foregroundColor(AppColors.secondaryText.opacity(0.6))
                        }
                        .padding(.horizontal, isCompact ? 12 : 20)
                        .padding(.top, isCompact ? 4 : 8)
                        .frame(height: isCompact ? 24 : 30)
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                animated = true
            }
        }
    }
    
    private func barWidth(geometry: GeometryProxy) -> CGFloat {
        if needsScroll {
            return isCompact ? 28 : 32
        } else {
            let totalWidth = geometry.size.width - (isCompact ? 24 : 32)
            let spacing: CGFloat = isCompact ? 6 : 8
            let totalSpacing = spacing * CGFloat(max(0, sortedResults.count - 1))
            return max(isCompact ? 18 : 20, (totalWidth - totalSpacing) / CGFloat(sortedResults.count))
        }
    }
    
    private func barHeight(for result: WorkoutResult, geometry: GeometryProxy) -> CGFloat {
        let height = geometry.size.height - (isCompact ? 40 : 50)
        let normalizedWeight = (result.weight - minWeight) / weightRange
        return CGFloat(normalizedWeight) * height
    }
    
    private func shortDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
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
    
    BarChartView(results: sampleResults)
        .frame(height: 240)
        .padding()
        .background(AppColors.primaryGradient)
}

