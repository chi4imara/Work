import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: PrinciplesViewModel
    @State private var animateItems = false
    
    private var totalCount: Int {
        viewModel.principles.count
    }
    
    private var averageLength: Int {
        guard !viewModel.principles.isEmpty else { return 0 }
        let total = viewModel.principles.reduce(0) { $0 + $1.text.count }
        return total / viewModel.principles.count
    }
    
    private var thisWeekCount: Int {
        let calendar = Calendar.current
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return 0 }
        return viewModel.principles.filter { $0.createdAt >= weekStart }.count
    }
    
    private var thisMonthCount: Int {
        let calendar = Calendar.current
        return viewModel.principles.filter {
            calendar.isDate($0.createdAt, equalTo: Date(), toGranularity: .month)
        }.count
    }
    
    private var editedCount: Int {
        viewModel.principles.filter { $0.updatedAt != $0.createdAt }.count
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.15)
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        overviewSection
                        metricsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateItems = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.appTextBlue)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.appTextBlue)
            
            HStack(spacing: 16) {
                StatisticsCard(
                    title: "Total principles",
                    value: "\(totalCount)",
                    icon: "quote.bubble.fill",
                    color: Color.appTextBlue
                )
                .scaleEffect(animateItems ? 1.0 : 0.9)
                .opacity(animateItems ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: animateItems)
                
                StatisticsCard(
                    title: "This week",
                    value: "\(thisWeekCount)",
                    icon: "calendar",
                    color: Color.appAccentYellow
                )
                .scaleEffect(animateItems ? 1.0 : 0.9)
                .opacity(animateItems ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.5).delay(0.2), value: animateItems)
            }
            
            HStack(spacing: 16) {
                StatisticsCard(
                    title: "This month",
                    value: "\(thisMonthCount)",
                    icon: "doc.text.fill",
                    color: Color.appSoftPurple
                )
                .scaleEffect(animateItems ? 1.0 : 0.9)
                .opacity(animateItems ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: animateItems)
                
                StatisticsCard(
                    title: "Edited",
                    value: "\(editedCount)",
                    icon: "pencil",
                    color: Color.appSuccessGreen
                )
                .scaleEffect(animateItems ? 1.0 : 0.9)
                .opacity(animateItems ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: animateItems)
            }
        }
    }
    
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Metrics")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.appTextBlue)
            
            VStack(spacing: 12) {
                StatRow(label: "Average length", value: totalCount > 0 ? "\(averageLength) characters" : "—")
                StatRow(label: "Longest principle", value: viewModel.principles.map(\.text.count).max().map { "\($0) characters" } ?? "—")
                StatRow(label: "Shortest principle", value: viewModel.principles.map(\.text.count).min().map { "\($0) characters" } ?? "—")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: Color.appTextBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(animateItems ? 1.0 : 0.95)
            .opacity(animateItems ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.5).delay(0.5), value: animateItems)
        }
    }
}

struct StatisticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            Text(value)
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(Color.appTextBlue)
            Text(title)
                .font(.playfairDisplay(12, weight: .medium))
                .foregroundColor(Color.appDarkGray.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: Color.appTextBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(Color.appDarkGray)
            Spacer()
            Text(value)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(Color.appTextBlue)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StatisticsView(viewModel: PrinciplesViewModel())
}
