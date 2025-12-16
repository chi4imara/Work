import SwiftUI
import Combine

struct AnalyticsView: View {
    @StateObject private var viewModel = CareJournalViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.entries.isEmpty {
                    emptyStateView
                } else {
                    analyticsContentView
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Hair Care Analytics")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                viewModel.objectWillChange.send()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.yellow)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private var analyticsContentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                overallStatsView
                
                frequentProductsView
                
                recentProceduresView
                
                monthlyBreakdownView
            }
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
    
    private var overallStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall Statistics")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            let stats = viewModel.totalStats
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Entries",
                    value: "\(stats.total)",
                    icon: "list.bullet",
                    color: AppColors.yellow
                )
                
                StatCard(
                    title: "Products",
                    value: "\(stats.products)",
                    icon: "drop.fill",
                    color: AppColors.lightBlue
                )
                
                StatCard(
                    title: "Procedures",
                    value: "\(stats.procedures)",
                    icon: "scissors",
                    color: AppColors.success
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var frequentProductsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Frequently Used Products")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            let frequentProducts = viewModel.productUsageStats
                .filter { $0.value >= 3 }
                .sorted { $0.value > $1.value }
                .prefix(5)
            
            if frequentProducts.isEmpty {
                Text("No frequently used products yet. Use a product 3+ times to see it here.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(frequentProducts), id: \.key) { product, count in
                        FrequentProductRow(
                            productName: product,
                            usageCount: count
                        )
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var recentProceduresView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Procedures")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            let recentProcedures = viewModel.recentProcedures
            
            if recentProcedures.isEmpty {
                Text("No procedures recorded yet.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(recentProcedures) { procedure in
                        RecentProcedureRow(procedure: procedure)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var monthlyBreakdownView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Month")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            let thisMonthEntries = getThisMonthEntries()
            let thisMonthProducts = thisMonthEntries.filter { $0.type == .product }.count
            let thisMonthProcedures = thisMonthEntries.filter { $0.type == .procedure }.count
            
            VStack(spacing: 12) {
                MonthlyStatRow(
                    title: "Total Entries",
                    value: thisMonthEntries.count,
                    icon: "calendar"
                )
                
                MonthlyStatRow(
                    title: "Products Used",
                    value: thisMonthProducts,
                    icon: "drop.fill"
                )
                
                MonthlyStatRow(
                    title: "Procedures Done",
                    value: thisMonthProcedures,
                    icon: "scissors"
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryText.opacity(0.5))
            
            Text("Not enough data for analysis")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Add at least one entry to your journal to see analytics.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func getThisMonthEntries() -> [CareEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        return viewModel.entries.filter { entry in
            calendar.isDate(entry.date, equalTo: now, toGranularity: .month)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(12)
    }
}

struct FrequentProductRow: View {
    let productName: String
    let usageCount: Int
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(AppColors.yellow)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(productName)
                    .font(AppFonts.bodyBold)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(usageCount) times")
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text("\(usageCount)")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.yellow)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.yellow.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
}

struct RecentProcedureRow: View {
    let procedure: CareEntry
    
    var body: some View {
        HStack {
            Image(systemName: procedure.type.icon)
                .foregroundColor(AppColors.success)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(procedure.name)
                    .font(AppFonts.bodyBold)
                    .foregroundColor(AppColors.primaryText)
                
                Text(procedure.date, style: .date)
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text(timeAgo(from: procedure.date))
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.vertical, 4)
    }
    
    private func timeAgo(from date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        if days == 0 {
            return "Today"
        } else if days == 1 {
            return "1 day ago"
        } else {
            return "\(days) days ago"
        }
    }
}

struct MonthlyStatRow: View {
    let title: String
    let value: Int
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.yellow)
                .font(.system(size: 16))
                .frame(width: 24)
            
            Text(title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text("\(value)")
                .font(AppFonts.bodyBold)
                .foregroundColor(AppColors.yellow)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AnalyticsView()
}
