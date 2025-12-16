import SwiftUI
import Combine

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingActivityChart = false
    
    private var statistics: Statistics {
        dataManager.getStatistics()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Refresh Statistics") {
                        dataManager.objectWillChange.send()
                    }
                    .font(.custom("PlayfairDisplay-Medium", size: 14))
                    .foregroundColor(AppColors.primaryText)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if dataManager.procedures.isEmpty {
                    StatisticsEmptyStateView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            ActivityChartButton {
                                showingActivityChart = true
                            }
                            
                            StatisticsSectionView(title: "By Categories") {
                                VStack(spacing: 12) {
                                    ForEach(ProcedureCategory.allCases, id: \.self) { category in
                                        let count = statistics.proceduresByCategory[category] ?? 0
                                        CategoryStatRow(
                                            category: category,
                                            count: count
                                        )
                                    }
                                }
                            }
                            
                            if !statistics.topProducts.isEmpty {
                                StatisticsSectionView(title: "Frequently Used Products") {
                                    VStack(spacing: 12) {
                                        ForEach(statistics.topProducts.prefix(5)) { product in
                                            ProductStatRow(product: product)
                                        }
                                    }
                                }
                            }
                            
                            if !statistics.recentProcedures.isEmpty {
                                StatisticsSectionView(title: "Recent Procedures") {
                                    VStack(spacing: 12) {
                                        ForEach(statistics.recentProcedures.prefix(5)) { procedure in
                                            RecentProcedureRow(procedure: procedure)
                                        }
                                    }
                                }
                            }
                            
                            Spacer(minLength: 40)
                        }
                        .padding(20)
                    }
                }
            }
            .sheet(isPresented: $showingActivityChart) {
                ActivityChartView()
            }
        }
    }
}

struct StatisticsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("PlayfairDisplay-Bold", size: 20))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
}

struct CategoryStatRow: View {
    let category: ProcedureCategory
    let count: Int
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        Button(action: {
            dataManager.selectedCategory = category
            dataManager.selectedProduct = nil
            NotificationCenter.default.post(name: NSNotification.Name("SwitchToMySalonTab"), object: nil)
        }) {
            HStack {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 30)
                
                Text(category.rawValue)
                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(count) procedure\(count == 1 ? "" : "s")")
                    .font(.custom("PlayfairDisplay-Regular", size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProductStatRow: View {
    let product: ProductUsage
    
    var body: some View {
        HStack {
            Image(systemName: "waterbottle")
                .font(.title3)
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(product.name)
                    .font(.custom("PlayfairDisplay-Medium", size: 14))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text("\(product.usageCount) uses")
                    .font(.custom("PlayfairDisplay-Regular", size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct RecentProcedureRow: View {
    let procedure: Procedure
    
    var body: some View {
        HStack {
            Image(systemName: procedure.category.icon)
                .font(.title3)
                .foregroundColor(AppColors.primaryText)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(procedure.name)
                    .font(.custom("PlayfairDisplay-Medium", size: 14))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(DateFormatter.shortDate.string(from: procedure.date))
                    .font(.custom("PlayfairDisplay-Regular", size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ActivityChartButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryText)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("View Activity Chart")
                        .font(.custom("PlayfairDisplay-Bold", size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("See your monthly activity trends")
                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(20)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatisticsEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No data for analysis yet. Add at least one procedure.")
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(DataManager())
}
