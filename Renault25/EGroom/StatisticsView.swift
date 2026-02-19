import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(FontManager.playfairDisplay(.bold, size: 28))
                            .foregroundColor(.primaryWhite)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    VStack(spacing: 16) {
                        StatCard(
                            title: "Total Procedures",
                            value: "\(viewModel.procedures.count)",
                            subtitle: "In your routine",
                            icon: "list.bullet.clipboard"
                        )
                        
                        StatCard(
                            title: "Completed (all time)",
                            value: "\(totalCompletions)",
                            subtitle: "Procedure completions",
                            icon: "checkmark.circle"
                        )
                        
                        StatCard(
                            title: "Favorites",
                            value: "\(viewModel.procedures.filter { $0.isFavorite }.count)",
                            subtitle: "Saved procedures",
                            icon: "star"
                        )
                        
                        StatCard(
                            title: "Days with progress",
                            value: "\(viewModel.dailyProgress.count)",
                            subtitle: "Recorded in history",
                            icon: "calendar"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    if !viewModel.procedures.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("By Category")
                                .font(FontManager.playfairDisplay(.semibold, size: 20))
                                .foregroundColor(.primaryWhite)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(Procedure.ProcedureCategory.allCases, id: \.self) { category in
                                    let items = viewModel.procedures.filter { $0.category == category }
                                    if !items.isEmpty {
                                        CategoryStatRow(
                                            category: category,
                                            count: items.count,
                                            completed: items.filter { $0.isCompleted }.count
                                        )
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardGradient)
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    let filledMetrics = viewModel.healthMetrics.filter { !$0.value.isEmpty }
                    if !filledMetrics.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Health Tracking")
                                .font(FontManager.playfairDisplay(.semibold, size: 20))
                                .foregroundColor(.primaryWhite)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(filledMetrics) { metric in
                                    HStack {
                                        Image(systemName: "heart")
                                            .font(.system(size: 18))
                                            .foregroundColor(.primaryOrange)
                                            .frame(width: 28)
                                        Text(metric.name)
                                            .font(FontManager.playfairDisplay(.medium, size: 16))
                                            .foregroundColor(.primaryWhite)
                                        Spacer()
                                        Text("\(metric.value) \(metric.unit)")
                                            .font(FontManager.playfairDisplay(.semibold, size: 14))
                                            .foregroundColor(.primaryOrange)
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardGradient)
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    if viewModel.procedures.isEmpty && viewModel.dailyProgress.isEmpty {
                        EmptyStatisticsView()
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private var totalCompletions: Int {
        viewModel.procedures.reduce(0) { $0 + $1.completionDates.count }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.playfairDisplay(.medium, size: 14))
                    .foregroundColor(.primaryWhite.opacity(0.8))
                Text(value)
                    .font(FontManager.playfairDisplay(.bold, size: 24))
                    .foregroundColor(.primaryWhite)
                Text(subtitle)
                    .font(FontManager.playfairDisplay(.regular, size: 12))
                    .foregroundColor(.primaryWhite.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
    }
}

struct CategoryStatRow: View {
    let category: Procedure.ProcedureCategory
    let count: Int
    let completed: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primaryOrange)
                .frame(width: 24)
            
            Text(category.rawValue)
                .font(FontManager.playfairDisplay(.medium, size: 16))
                .foregroundColor(.primaryWhite)
            
            Spacer()
            
            Text("\(count) total")
                .font(FontManager.playfairDisplay(.regular, size: 14))
                .foregroundColor(.primaryWhite.opacity(0.6))
            
            Text("\(completed) done")
                .font(FontManager.playfairDisplay(.semibold, size: 14))
                .foregroundColor(.primaryOrange)
        }
        .padding(.vertical, 8)
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.primaryWhite.opacity(0.3))
            
            Text("No data yet")
                .font(FontManager.playfairDisplay(.semibold, size: 20))
                .foregroundColor(.primaryWhite)
            
            Text("Complete procedures and track health to see your statistics here")
                .font(FontManager.playfairDisplay(.regular, size: 14))
                .foregroundColor(.primaryWhite.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 40)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(GroomingViewModel())
    }
}
