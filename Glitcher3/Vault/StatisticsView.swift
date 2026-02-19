import SwiftUI

struct StatisticsView: View {
    @ObservedObject var gadgetViewModel: GadgetViewModel
    
    private var totalGadgets: Int {
        gadgetViewModel.gadgets.count
    }
    
    private var totalCategories: Int {
        gadgetViewModel.getCategories().count
    }
    
    private var totalValue: Double {
        gadgetViewModel.gadgets.compactMap { gadget in
            let priceString = gadget.price.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
            return Double(priceString)
        }.reduce(0, +)
    }
    
    private var averageServiceLife: Double {
        let serviceLives = gadgetViewModel.gadgets.compactMap { Double($0.serviceLife) }
        guard !serviceLives.isEmpty else { return 0 }
        return serviceLives.reduce(0, +) / Double(serviceLives.count)
    }
    
    private var categoryDistribution: [(String, Int)] {
        let categories = gadgetViewModel.getCategories()
        return categories.map { ($0.name, $0.count) }.sorted { $0.1 > $1.1 }
    }
    
    private var conditionDistribution: [String: Int] {
        Dictionary(grouping: gadgetViewModel.gadgets, by: { $0.condition })
            .mapValues { $0.count }
    }
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 8) {
                    Text("Statistics")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("Your gadget collection overview")
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(.vertical, 10)
                
                if gadgetViewModel.gadgets.isEmpty {
                    EmptyStatisticsView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
                                StatCard(
                                    icon: "laptopcomputer",
                                    title: "Total Devices",
                                    value: "\(totalGadgets)",
                                    color: Color.theme.lightBlue
                                )
                                
                                StatCard(
                                    icon: "folder.fill",
                                    title: "Categories",
                                    value: "\(totalCategories)",
                                    color: Color.theme.orange
                                )
                                
                                StatCard(
                                    icon: "dollarsign.circle.fill",
                                    title: "Total Value",
                                    value: formatCurrency(totalValue),
                                    color: Color.theme.orange
                                )
                                
                                StatCard(
                                    icon: "clock.fill",
                                    title: "Avg Service Life",
                                    value: String(format: "%.1f years", averageServiceLife),
                                    color: Color.theme.lightBlue
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            if !categoryDistribution.isEmpty {
                                StatSection(title: "Category Distribution") {
                                    VStack(spacing: 12) {
                                        ForEach(Array(categoryDistribution.prefix(5)), id: \.0) { category, count in
                                            CategoryStatRow(category: category, count: count, total: totalGadgets)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            if !conditionDistribution.isEmpty {
                                StatSection(title: "Condition Overview") {
                                    VStack(spacing: 12) {
                                        ForEach(Array(conditionDistribution.sorted { $0.value > $1.value }), id: \.key) { condition, count in
                                            ConditionStatRow(condition: condition, count: count, total: totalGadgets)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            if gadgetViewModel.gadgets.count > 0 {
                                StatSection(title: "Recent Additions") {
                                    VStack(spacing: 8) {
                                        ForEach(Array(gadgetViewModel.gadgets.sorted { $0.purchaseDate > $1.purchaseDate }.prefix(3)), id: \.id) { gadget in
                                            RecentGadgetRow(gadget: gadget)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.playfairDisplay(size: 20, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text(title)
                    .font(.playfairDisplay(size: 12))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                }
        )
    }
}

struct StatSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.playfairDisplay(size: 20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                }
        )
    }
}

struct CategoryStatRow: View {
    let category: String
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category)
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(size: 14, weight: .bold))
                    .foregroundColor(Color.theme.lightBlue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.mediumGray.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.accentGradient)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

struct ConditionStatRow: View {
    let condition: String
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        HStack {
            Text(condition)
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
                .frame(width: 100, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.mediumGray.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.orange)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
            
            Text("\(count)")
                .font(.playfairDisplay(size: 12, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .frame(width: 40, alignment: .trailing)
        }
    }
}

struct RecentGadgetRow: View {
    let gadget: Gadget
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "laptopcomputer")
                .font(.system(size: 16))
                .foregroundColor(Color.theme.lightBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(gadget.name)
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Text(gadget.category)
                    .font(.playfairDisplay(size: 11))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: gadget.purchaseDate))
                .font(.playfairDisplay(size: 11))
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(.vertical, 4)
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.mediumGray)
            
            VStack(spacing: 8) {
                Text("No Statistics Available")
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add some gadgets to see statistics")
                    .font(.playfairDisplay(size: 14))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

#Preview {
    StatisticsView(gadgetViewModel: {
        let vm = GadgetViewModel()
        vm.gadgets = [
            Gadget(name: "iPhone 13", category: "Phone", purchaseDate: Date(), price: "$899", condition: "Excellent", serviceLife: "2", comment: ""),
            Gadget(name: "MacBook Pro", category: "Laptop", purchaseDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(), price: "$2499", condition: "Good", serviceLife: "5", comment: ""),
            Gadget(name: "AirPods Pro", category: "Headphones", purchaseDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(), price: "$249", condition: "Excellent", serviceLife: "3", comment: "")
        ]
        return vm
    }())
}
