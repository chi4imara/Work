import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: RitualViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.appTitle())
                        .foregroundColor(AppColors.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.rituals.isEmpty || viewModel.totalCompletions == 0 {
                    emptyStateView
                    
                    Spacer()
                } else {
                    statisticsContent
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 80))
                .foregroundColor(AppColors.accentPurple.opacity(0.6))
                .padding(.bottom, 20)
            
            Text("Statistics will appear here when you add and mark at least one ritual.")
                .font(.appBody())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    StatisticCard(
                        title: "Total Rituals",
                        value: "\(viewModel.totalRituals)"
                    )
                    
                    StatisticCard(
                        title: "Repeating Rituals",
                        value: "\(viewModel.repeatingRitualsCount)"
                    )
                    
                    StatisticCard(
                        title: "Marked Completions",
                        value: "\(viewModel.totalCompletions)"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                if !viewModel.mostFrequentRituals.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Most Frequent Rituals")
                            .font(.appHeadline())
                            .foregroundColor(AppColors.textWhite)
                            .padding(.horizontal, 20)
                        
                        ForEach(viewModel.mostFrequentRituals) { ritual in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(ritual.title)
                                        .font(.appBody())
                                        .foregroundColor(AppColors.textWhite)
                                    
                                    Text("\(ritual.completionCount) completions")
                                        .font(.appCaption())
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.appCaption())
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(.appTitle())
                .foregroundColor(AppColors.textWhite)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}
