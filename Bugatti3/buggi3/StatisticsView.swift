import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: ExperimentViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                if viewModel.experiments.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60))
                            .foregroundColor(Color.theme.primaryYellow)
                        Text("No data yet.")
                            .font(.ubuntu(20, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        Text("Add experiments to see statistics.")
                            .font(.ubuntu(16))
                            .foregroundColor(Color.theme.secondaryText)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            StatCard(
                                title: "Total experiments",
                                value: "\(viewModel.experiments.count)",
                                icon: "flask"
                            )
                            
                            StatCard(
                                title: "This week",
                                value: "\(experimentsThisWeek)",
                                icon: "calendar"
                            )
                            
                            StatCard(
                                title: "This month",
                                value: "\(experimentsThisMonth)",
                                icon: "calendar.badge.clock"
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Recent activity")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(Color.theme.primaryYellow)
                                
                                ForEach(viewModel.experiments.sorted(by: { $0.updatedAt > $1.updatedAt }).prefix(5)) { experiment in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(experiment.tried)
                                                .font(.ubuntu(14, weight: .medium))
                                                .foregroundColor(Color.theme.primaryText)
                                                .lineLimit(1)
                                            Text(formatDate(experiment.updatedAt))
                                                .font(.ubuntu(12))
                                                .foregroundColor(Color.theme.secondaryText)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.theme.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                                    )
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var experimentsThisWeek: Int {
        let calendar = Calendar.current
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return 0 }
        return viewModel.experiments.filter { $0.createdAt >= weekStart }.count
    }
    
    private var experimentsThisMonth: Int {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
        return viewModel.experiments.filter { $0.createdAt >= startOfMonth }.count
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Color.theme.primaryYellow)
                .frame(width: 44, height: 44)
                .background(Color.theme.cardBackground)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14))
                    .foregroundColor(Color.theme.secondaryText)
                Text(value)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.theme.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

#Preview {
    StatisticsView(viewModel: ExperimentViewModel())
}
