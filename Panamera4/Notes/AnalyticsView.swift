import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var procedureStore: ProcedureStore
    
    private var totalProcedures: Int {
        procedureStore.totalProceduresCount()
    }
    
    private var mostFrequentCategory: ProcedureCategory? {
        procedureStore.mostFrequentCategory()
    }
    
    private var lastProcedure: HairCareProcedure? {
        procedureStore.lastProcedure()
    }
    
    private var categoryStatistics: [CategoryStatistics] {
        procedureStore.categoryStatistics()
    }
    
    private var recentProcedures: [HairCareProcedure] {
        procedureStore.recentProcedures()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Analytics")
                        .font(.bellGothic(28, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if totalProcedures == 0 {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                        
                        Text("Analytics will appear after adding procedures.")
                            .font(.bellGothic(18, weight: .regular))
                            .foregroundColor(AppColors.primaryWhite)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            AnalyticsSectionView(title: "General Statistics") {
                                VStack(spacing: 16) {
                                    StatisticRowView(
                                        title: "Total procedures:",
                                        value: "\(totalProcedures)"
                                    )
                                    
                                    if let mostFrequent = mostFrequentCategory {
                                        StatisticRowView(
                                            title: "Most frequent category:",
                                            value: mostFrequent.displayName
                                        )
                                    }
                                    
                                    if let last = lastProcedure {
                                        StatisticRowView(
                                            title: "Last procedure:",
                                            value: "\(last.name) • \(formattedDate(last.date))"
                                        )
                                    }
                                }
                            }
                            
                            if !categoryStatistics.isEmpty {
                                AnalyticsSectionView(title: "Category Frequency") {
                                    VStack(spacing: 12) {
                                        ForEach(categoryStatistics, id: \.category) { stat in
                                            CategoryStatRowView(statistic: stat)
                                        }
                                    }
                                }
                            }
                            
                            if !recentProcedures.isEmpty {
                                AnalyticsSectionView(title: "Recent Records") {
                                    VStack(spacing: 12) {
                                        ForEach(recentProcedures) { procedure in
                                            NavigationLink(destination: ProcedureDetailView(procedureId: procedure.id)
                                                .environmentObject(procedureStore)) {
                                                RecentProcedureRowView(procedure: procedure)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 120)
                    }
                }
                
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AnalyticsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.bellGothic(20, weight: .bold))
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 0) {
                content
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
}

struct StatisticRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.bellGothic(16, weight: .regular))
                .foregroundColor(AppColors.darkGray.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.darkGray)
        }
    }
}

struct CategoryStatRowView: View {
    let statistic: CategoryStatistics
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: statistic.category.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 30)
            
            Text(statistic.displayText)
                .font(.bellGothic(16, weight: .regular))
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
        }
    }
}

struct RecentProcedureRowView: View {
    let procedure: HairCareProcedure
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: procedure.date)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: procedure.category.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(procedure.name)
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(AppColors.darkGray)
                    .lineLimit(1)
                
                HStack {
                    Text(formattedDate)
                        .font(.bellGothic(14, weight: .regular))
                        .foregroundColor(AppColors.darkGray.opacity(0.7))
                    
                    if !procedure.effect.isEmpty {
                        Text("•")
                            .foregroundColor(AppColors.darkGray.opacity(0.5))
                        
                        Text(procedure.effect)
                            .font(.bellGothic(14, weight: .regular))
                            .foregroundColor(AppColors.darkGray.opacity(0.7))
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.darkGray.opacity(0.4))
        }
    }
}

#Preview {
    let store = ProcedureStore()
    store.addProcedure(HairCareProcedure(
        name: "Keratin Hair Mask",
        category: .masks,
        date: Date(),
        effect: "Smoother hair",
        description: "Great results"
    ))
    
    return AnalyticsView()
        .environmentObject(store)
        .primaryBackground()
}
