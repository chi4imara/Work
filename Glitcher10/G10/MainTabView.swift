import SwiftUI
import Charts

struct MainTabView: View {
    @ObservedObject var viewModel: ShoppingViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            AddItemView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: TabSelection.add.iconName)
                    Text(TabSelection.add.title)
                }
                .tag(TabSelection.add)
            
            ShoppingListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: TabSelection.list.iconName)
                    Text(TabSelection.list.title)
                }
                .tag(TabSelection.list)
            
            CategoriesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: TabSelection.categories.iconName)
                    Text(TabSelection.categories.title)
                }
                .tag(TabSelection.categories)
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: TabSelection.statistics.iconName)
                    Text(TabSelection.statistics.title)
                }
                .tag(TabSelection.statistics)
            
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: TabSelection.settings.iconName)
                    Text(TabSelection.settings.title)
                }
                .tag(TabSelection.settings)
        }
        .accentColor(ColorManager.lightBlue)
    }
}

struct StatisticsView: View {
    @ObservedObject var viewModel: ShoppingViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("Statistics")
                        .font(FontManager.ubuntu(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    Text("Insights and analytics")
                        .font(FontManager.ubuntu(size: 16))
                        .foregroundColor(ColorManager.white.opacity(0.7))
                }
                .padding(.top, 20)
                
                if viewModel.hasItems {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                Text("Overview")
                                    .font(FontManager.ubuntu(size: 20, weight: .medium))
                                    .foregroundColor(ColorManager.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 16) {
                                    StatCard(
                                        title: "Total Items",
                                        value: "\(viewModel.items.count)",
                                        icon: "list.bullet",
                                        color: ColorManager.lightBlue
                                    )
                                    
                                    StatCard(
                                        title: "Categories",
                                        value: "\(viewModel.categories.count)",
                                        icon: "folder",
                                        color: ColorManager.orange
                                    )
                                    
                                    StatCard(
                                        title: "Items This Week",
                                        value: "\(itemsThisWeek)",
                                        icon: "calendar",
                                        color: ColorManager.success
                                    )
                                    
                                    StatCard(
                                        title: "Avg per Category",
                                        value: averageItemsPerCategory,
                                        icon: "chart.bar",
                                        color: ColorManager.accent
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                Text("Category Distribution")
                                    .font(FontManager.ubuntu(size: 20, weight: .medium))
                                    .foregroundColor(ColorManager.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CategoryChartView(categories: viewModel.categories)
                                    .frame(height: 250)
                                    .padding(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(ColorManager.cardGradient)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                    .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                Text("Items by Category")
                                    .font(FontManager.ubuntu(size: 20, weight: .medium))
                                    .foregroundColor(ColorManager.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CategoryBarChartView(categories: viewModel.categories)
                                    .frame(height: 250)
                                    .padding(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(ColorManager.cardGradient)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(ColorManager.orange.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                    .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                Text("Top Categories")
                                    .font(FontManager.ubuntu(size: 20, weight: .medium))
                                    .foregroundColor(ColorManager.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: 12) {
                                    ForEach(Array(topCategories.prefix(5)), id: \.name) { category in
                                        CategoryRowView(category: category, totalItems: viewModel.items.count)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                Text("Additional Information")
                                    .font(FontManager.ubuntu(size: 20, weight: .medium))
                                    .foregroundColor(ColorManager.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: 12) {
                                    InfoRow(
                                        icon: "star.fill",
                                        title: "Most Popular Category",
                                        value: mostPopularCategory,
                                        color: ColorManager.orange
                                    )
                                    
                                    InfoRow(
                                        icon: "clock.fill",
                                        title: "Latest Added",
                                        value: latestItemName,
                                        color: ColorManager.lightBlue
                                    )
                                    
                                    InfoRow(
                                        icon: "calendar.badge.plus",
                                        title: "First Item Added",
                                        value: firstItemDate,
                                        color: ColorManager.success
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 100)
                        }
                    }
                } else {
                    EmptyStateView(
                        iconName: "chart.bar",
                        title: "No Statistics Yet",
                        description: "Add some items to see statistics and charts.",
                        actionTitle: "Add First Item",
                        action: {
                            viewModel.selectedTab = .add
                        }
                    )
                }
            }
        }
    }
    
    private var itemsThisWeek: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        return viewModel.items.filter { $0.dateCreated >= weekAgo }.count
    }
    
    private var averageItemsPerCategory: String {
        guard !viewModel.categories.isEmpty else { return "0" }
        let total = viewModel.categories.reduce(0) { $0 + $1.itemCount }
        let average = Double(total) / Double(viewModel.categories.count)
        return String(format: "%.1f", average)
    }
    
    private var topCategories: [Category] {
        viewModel.categories.sorted { $0.itemCount > $1.itemCount }
    }
    
    private var mostPopularCategory: String {
        guard !viewModel.categories.isEmpty else { return "None" }
        let sorted = viewModel.categories.sorted { $0.itemCount > $1.itemCount }
        return sorted.first?.name ?? "None"
    }
    
    private var latestItemName: String {
        guard !viewModel.items.isEmpty else { return "None" }
        let sorted = viewModel.items.sorted { $0.dateCreated > $1.dateCreated }
        return sorted.first?.name ?? "None"
    }
    
    private var firstItemDate: String {
        guard !viewModel.items.isEmpty else { return "None" }
        let sorted = viewModel.items.sorted { $0.dateCreated < $1.dateCreated }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: sorted.first?.dateCreated ?? Date())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(FontManager.ubuntu(size: 20, weight: .bold))
                    .foregroundColor(ColorManager.white)
                    .lineLimit(1)
                
                Text(title)
                    .font(FontManager.ubuntu(size: 12))
                    .foregroundColor(ColorManager.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct CategoryChartView: View {
    let categories: [Category]
    
    private var totalItems: Int {
        categories.reduce(0) { $0 + $1.itemCount }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = size / 2 - 20
            let innerRadius = radius * 0.5
            
            ZStack {
                ForEach(Array(categories.prefix(6).enumerated()), id: \.element.id) { index, category in
                    PieSegment(
                        category: category,
                        total: totalItems,
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        center: center,
                        radius: radius,
                        innerRadius: innerRadius,
                        color: chartColor(for: index)
                    )
                }
                
                VStack(spacing: 4) {
                    Text("Total")
                        .font(FontManager.ubuntu(size: 14))
                        .foregroundColor(ColorManager.white.opacity(0.7))
                    Text("\(totalItems)")
                        .font(FontManager.ubuntu(size: 20, weight: .bold))
                        .foregroundColor(ColorManager.white)
                }
            }
        }
    }
    
    private func startAngle(for index: Int) -> Double {
        guard totalItems > 0 else { return 0 }
        var angle: Double = -90
        for i in 0..<index {
            let category = categories[i]
            let percentage = Double(category.itemCount) / Double(totalItems)
            angle += percentage * 360
        }
        return angle
    }
    
    private func endAngle(for index: Int) -> Double {
        guard totalItems > 0 else { return 0 }
        var angle: Double = -90
        for i in 0...index {
            let category = categories[i]
            let percentage = Double(category.itemCount) / Double(totalItems)
            angle += percentage * 360
        }
        return angle
    }
    
    private func chartColor(for index: Int) -> Color {
        let colors: [Color] = [
            ColorManager.lightBlue,
            ColorManager.orange,
            ColorManager.success,
            ColorManager.accent,
            ColorManager.warning,
            ColorManager.error
        ]
        return colors[index % colors.count]
    }
}

struct PieSegment: View {
    let category: Category
    let total: Int
    let startAngle: Double
    let endAngle: Double
    let center: CGPoint
    let radius: CGFloat
    let innerRadius: CGFloat
    let color: Color
    
    var body: some View {
        Path { path in
            let startRad = startAngle * .pi / 180
            let endRad = endAngle * .pi / 180
            
            let startInnerX = center.x + cos(startRad) * innerRadius
            let startInnerY = center.y + sin(startRad) * innerRadius
            path.move(to: CGPoint(x: startInnerX, y: startInnerY))
            
            let startOuterX = center.x + cos(startRad) * radius
            let startOuterY = center.y + sin(startRad) * radius
            path.addLine(to: CGPoint(x: startOuterX, y: startOuterY))
            
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
            
            let endInnerX = center.x + cos(endRad) * innerRadius
            let endInnerY = center.y + sin(endRad) * innerRadius
            path.addLine(to: CGPoint(x: endInnerX, y: endInnerY))
            
            path.addArc(
                center: center,
                radius: innerRadius,
                startAngle: .degrees(endAngle),
                endAngle: .degrees(startAngle),
                clockwise: true
            )
            
            path.closeSubpath()
        }
        .fill(color)
        .overlay(
            Group {
                if category.itemCount > 0 && (endAngle - startAngle) > 15 {
                    let midAngle = (startAngle + endAngle) / 2
                    let midRad = midAngle * .pi / 180
                    let labelRadius = (radius + innerRadius) / 2
                    let labelX = center.x + cos(midRad) * labelRadius
                    let labelY = center.y + sin(midRad) * labelRadius
                    
                    Text("\(category.itemCount)")
                        .font(FontManager.ubuntu(size: 11, weight: .bold))
                        .foregroundColor(ColorManager.white)
                        .position(x: labelX, y: labelY)
                }
            }
        )
    }
}

struct CategoryBarChartView: View {
    let categories: [Category]
    
    var body: some View {
        Chart {
            ForEach(Array(categories.sorted { $0.itemCount > $1.itemCount }.prefix(6).enumerated()), id: \.element.id) { index, category in
                BarMark(
                    x: .value("Category", category.name),
                    y: .value("Items", category.itemCount)
                )
                .foregroundStyle(barColor(for: index))
                .cornerRadius(4)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(ColorManager.white.opacity(0.3))
                AxisValueLabel()
                    .foregroundStyle(ColorManager.white.opacity(0.7))
                    .font(FontManager.ubuntu(size: 10))
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(ColorManager.white.opacity(0.3))
                AxisValueLabel()
                    .foregroundStyle(ColorManager.white.opacity(0.7))
                    .font(FontManager.ubuntu(size: 10))
            }
        }
    }
    
    private func barColor(for index: Int) -> Color {
        let colors: [Color] = [
            ColorManager.lightBlue,
            ColorManager.orange,
            ColorManager.success,
            ColorManager.accent,
            ColorManager.warning,
            ColorManager.error
        ]
        return colors[index % colors.count]
    }
}

struct CategoryRowView: View {
    let category: Category
    let totalItems: Int
    
    var percentage: Double {
        guard totalItems > 0 else { return 0 }
        return Double(category.itemCount) / Double(totalItems) * 100
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: categoryIcon(for: category.name))
                    .font(.system(size: 18))
                    .foregroundColor(categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(FontManager.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.white)
                
                Text("\(category.itemCount) items • \(String(format: "%.1f", percentage))%")
                    .font(FontManager.ubuntu(size: 12))
                    .foregroundColor(ColorManager.white.opacity(0.6))
            }
            
            Spacer()
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.darkGray.opacity(0.3))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(categoryColor)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                }
            }
            .frame(width: 60, height: 6)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(categoryColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var categoryColor: Color {
        let colors: [Color] = [
            ColorManager.lightBlue,
            ColorManager.orange,
            ColorManager.success,
            ColorManager.accent,
            ColorManager.warning
        ]
        let index = category.itemCount % colors.count
        return colors[index]
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "oils", "oil":
            return "drop.fill"
        case "parts", "part":
            return "gearshape.fill"
        case "tools", "tool":
            return "wrench.fill"
        case "materials", "material":
            return "cube.fill"
        default:
            return "tag.fill"
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.ubuntu(size: 14))
                    .foregroundColor(ColorManager.white.opacity(0.7))
                
                Text(value)
                    .font(FontManager.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.white)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.ubuntu(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.white)
                    
                    Text(subtitle)
                        .font(FontManager.ubuntu(size: 14))
                        .foregroundColor(ColorManager.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(ColorManager.white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView(viewModel: ShoppingViewModel())
}
