import SwiftUI

struct CategoryPieChart: View {
    let experiences: [FirstExperience]
    
    @State private var selectedCategory: String? = nil
    @State private var animateChart = false
    
    private var categoryData: [CategoryData] {
        let grouped = Dictionary(grouping: experiences) { experience in
            experience.category ?? "Uncategorized"
        }
        
        let colors: [Color] = [
            AppColors.accentYellow,
            AppColors.lightPurple,
            AppColors.softPink,
            AppColors.mintGreen,
            AppColors.peachOrange,
            AppColors.primaryBlue,
            AppColors.pureWhite,
            Color.orange,
            Color.purple,
            Color.green,
            Color.red,
            Color.cyan,
            Color.pink,
            Color.indigo,
            Color.teal
        ]
        
        let sortedCategories = grouped.map { (category, exps) in
            (category: category, count: exps.count)
        }.sorted { $0.count > $1.count }
        
        return sortedCategories.enumerated().map { index, item in
            CategoryData(
                category: item.category,
                count: item.count,
                color: colors[index % colors.count]
            )
        }
    }
    
    private var totalCount: Int {
        experiences.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Categories Distribution")
                    .font(FontManager.title3)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Text("\(totalCount) total")
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.pureWhite.opacity(0.7))
            }
            
            if categoryData.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.pureWhite.opacity(0.5))
                    
                    Text("No categories yet")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.pureWhite.opacity(0.7))
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.pureWhite.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.pureWhite.opacity(0.2), lineWidth: 1)
                        }
                )
            } else {
                HStack(spacing: 20) {
                    ZStack {
                        ForEach(Array(categoryData.enumerated()), id: \.offset) { index, data in
                            PieSlice(
                                startAngle: getStartAngle(for: index),
                                endAngle: getEndAngle(for: index),
                                color: data.color,
                                isSelected: selectedCategory == data.category
                            )
                            .scaleEffect(selectedCategory == data.category ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: selectedCategory)
                            .onTapGesture {
                                selectedCategory = selectedCategory == data.category ? nil : data.category
                            }
                        }
                    }
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateChart ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8), value: animateChart)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(categoryData.prefix(5), id: \.category) { data in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(data.color)
                                    .frame(width: 12, height: 12)
                                
                                Text(data.category)
                                    .font(FontManager.caption1)
                                    .foregroundColor(AppColors.pureWhite)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Text("\(data.count)")
                                    .font(FontManager.caption1)
                                    .foregroundColor(AppColors.pureWhite.opacity(0.7))
                            }
                            .opacity(selectedCategory == nil || selectedCategory == data.category ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 0.3), value: selectedCategory)
                        }
                        
                        if categoryData.count > 5 {
                            Text("+ \(categoryData.count - 5) more")
                                .font(FontManager.caption2)
                                .foregroundColor(AppColors.pureWhite.opacity(0.6))
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.pureWhite.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.pureWhite.opacity(0.2), lineWidth: 1)
                        }
                )
            }
        }
        .onAppear {
            animateChart = true
        }
    }
    
    private func getStartAngle(for index: Int) -> Angle {
        let previousCount = categoryData.prefix(index).reduce(0) { $0 + $1.count }
        return Angle(degrees: Double(previousCount) / Double(totalCount) * 360)
    }
    
    private func getEndAngle(for index: Int) -> Angle {
        let currentCount = categoryData[index].count
        let previousCount = categoryData.prefix(index).reduce(0) { $0 + $1.count }
        return Angle(degrees: Double(previousCount + currentCount) / Double(totalCount) * 360)
    }
    
}

struct CategoryData {
    let category: String
    let count: Int
    let color: Color
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        PieSliceShape(
            startAngle: startAngle,
            endAngle: endAngle,
            isSelected: isSelected
        )
        .fill(color)
        .overlay(
            PieSliceShape(
                startAngle: startAngle,
                endAngle: endAngle,
                isSelected: isSelected
            )
            .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

struct PieSliceShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let isSelected: Bool
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - (isSelected ? 5 : 0)
        
        var path = Path()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}


