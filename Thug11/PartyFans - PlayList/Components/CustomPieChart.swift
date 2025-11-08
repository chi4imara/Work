import SwiftUI

struct CustomPieChart: View {
    let distribution: [TaskCategory: Int]
    let total: Int
    @State private var animationProgress: Double = 0
    @State private var selectedSegment: TaskCategory? = nil
    @State private var hoveredSegment: TaskCategory? = nil
    
    init(distribution: [TaskCategory: Int]) {
        self.distribution = distribution
        self.total = distribution.values.reduce(0, +)
    }
    
    var body: some View {
        ZStack {
            if total > 0 {
                GeometryReader { geometry in
                    let size = min(geometry.size.width, geometry.size.height)
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    let radius = (size - 40) / 2
                    
                    ZStack {
                        Circle()
                            .stroke(Color.theme.cardBorder, lineWidth: 2)
                            .frame(width: size - 40, height: size - 40)
                        
                        ForEach(Array(distribution.keys.sorted(by: { distribution[$0] ?? 0 > distribution[$1] ?? 0 })), id: \.self) { category in
                            PieSegment(
                                category: category,
                                value: distribution[category] ?? 0,
                                total: total,
                                startAngle: startAngle(for: category),
                                endAngle: endAngle(for: category),
                                center: center,
                                radius: radius,
                                isSelected: selectedSegment == category,
                                isHovered: hoveredSegment == category,
                                animationProgress: animationProgress,
                                onTap: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedSegment = selectedSegment == category ? nil : category
                                    }
                                },
                                onHover: { isHovered in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        hoveredSegment = isHovered ? category : nil
                                    }
                                }
                            )
                        }
                        
                        VStack(spacing: 4) {
                            if let selected = selectedSegment {
                                Text(selected.displayName)
                                    .font(.nunitoBold(size: 16))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Text("\(distribution[selected] ?? 0)")
                                    .font(.nunitoBold(size: 24))
                                    .foregroundColor(categoryColor(for: selected))
                                
                                Text("tasks")
                                    .font(.nunitoRegular(size: 10))
                                    .foregroundColor(Color.theme.secondaryText)
                            } else {
                                Text("\(total)")
                                    .font(.nunitoBold(size: 28))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Text("Total Tasks")
                                    .font(.nunitoRegular(size: 12))
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                        }
                        .scaleEffect(animationProgress)
                        .opacity(animationProgress)
                        .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                }
                .frame(height: 200)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        animationProgress = 1.0
                    }
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("No data available")
                        .font(.nunitoRegular(size: 14))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .frame(height: 200)
            }
        }
    }
    
    private func startAngle(for category: TaskCategory) -> Angle {
        let sortedCategories = distribution.keys.sorted(by: { distribution[$0] ?? 0 > distribution[$1] ?? 0 })
        guard let index = sortedCategories.firstIndex(of: category) else { return .degrees(0) }
        
        var currentAngle: Double = -90 
        for i in 0..<index {
            let categoryValue = distribution[sortedCategories[i]] ?? 0
            let percentage = Double(categoryValue) / Double(total)
            currentAngle += percentage * 360
        }
        
        return .degrees(currentAngle)
    }
    
    private func endAngle(for category: TaskCategory) -> Angle {
        let categoryValue = distribution[category] ?? 0
        let percentage = Double(categoryValue) / Double(total)
        let segmentAngle = percentage * 360
        
        return startAngle(for: category) + .degrees(segmentAngle)
    }
    
    private func categoryColor(for category: TaskCategory) -> Color {
        switch category {
        case .singing:
            return Color.theme.accentPurple
        case .dancing:
            return Color.theme.accentOrange
        case .animals:
            return Color.theme.accentGreen
        case .funny:
            return Color.theme.accentYellow
        case .other:
            return Color.theme.accentPink
        }
    }
}

struct PieSegment: View {
    let category: TaskCategory
    let value: Int
    let total: Int
    let startAngle: Angle
    let endAngle: Angle
    let center: CGPoint
    let radius: CGFloat
    let isSelected: Bool
    let isHovered: Bool
    let animationProgress: Double
    let onTap: () -> Void
    let onHover: (Bool) -> Void
    
    var body: some View {
        Path { path in
            let adjustedStartAngle = startAngle
            let adjustedEndAngle = startAngle + .degrees((endAngle.degrees - startAngle.degrees) * animationProgress)
            
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: adjustedStartAngle,
                endAngle: adjustedEndAngle,
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(categoryColor.opacity(isSelected ? 1.0 : (isHovered ? 0.9 : 0.8)))
        .overlay(
            Path { path in
                let adjustedStartAngle = startAngle
                let adjustedEndAngle = startAngle + .degrees((endAngle.degrees - startAngle.degrees) * animationProgress)
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: adjustedStartAngle,
                    endAngle: adjustedEndAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .stroke(categoryColor, lineWidth: isSelected ? 3 : 2)
        )
        .scaleEffect(isSelected ? 1.08 : (isHovered ? 1.03 : 1.0))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onTapGesture {
            onTap()
        }
        .onHover { hovering in
            onHover(hovering)
        }
        .shadow(
            color: isSelected ? categoryColor.opacity(0.3) : Color.clear,
            radius: isSelected ? 8 : 0,
            x: 0,
            y: isSelected ? 4 : 0
        )
    }
    
    private var categoryColor: Color {
        switch category {
        case .singing:
            return Color.theme.accentPurple
        case .dancing:
            return Color.theme.accentOrange
        case .animals:
            return Color.theme.accentGreen
        case .funny:
            return Color.theme.accentYellow
        case .other:
            return Color.theme.accentPink
        }
    }
}

struct SegmentDetailView: View {
    let category: TaskCategory
    let value: Int
    let total: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 16, height: 16)
                
                Text(category.displayName)
                    .font(.nunitoSemiBold(size: 16))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(value)")
                        .font(.nunitoBold(size: 24))
                        .foregroundColor(color)
                    
                    Text("tasks")
                        .font(.nunitoRegular(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(percentage)%")
                        .font(.nunitoBold(size: 20))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("of total")
                        .font(.nunitoRegular(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int(round(Double(value) / Double(total) * 100))
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomPieChart(distribution: [
            .singing: 5,
            .dancing: 3,
            .animals: 2,
            .funny: 4,
            .other: 1
        ])
        
        CustomPieChart(distribution: [:])
        
        SegmentDetailView(
            category: .singing,
            value: 5,
            total: 15,
            color: Color.theme.accentPurple
        )
    }
    .padding()
    .background(Color.theme.backgroundGradientStart)
}
