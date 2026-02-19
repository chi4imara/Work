import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: WishViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Overview of your entries")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.leading, 60)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if viewModel.entries.isEmpty {
                    EmptyStatisticsView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                HStack(spacing: 16) {
                                    StatCard(
                                        title: "Wants",
                                        count: viewModel.wantCount,
                                        color: AppColors.wantColor,
                                        icon: "heart.fill"
                                    )
                                    
                                    StatCard(
                                        title: "Don't Wants",
                                        count: viewModel.dontWantCount,
                                        color: AppColors.dontWantColor,
                                        icon: "heart.slash.fill"
                                    )
                                }
                                
                                StatCard(
                                    title: "Total Entries",
                                    count: viewModel.totalCount,
                                    color: AppColors.primaryPurple,
                                    icon: "list.bullet",
                                    isWide: true
                                )
                            }
                            
                            if viewModel.totalCount > 0 {
                                VStack(spacing: 16) {
                                    Text("Distribution")
                                        .font(.ubuntu(20, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    RatioVisualization(
                                        wantCount: viewModel.wantCount,
                                        dontWantCount: viewModel.dontWantCount
                                    )
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                            }
                            
                            InsightsView(viewModel: viewModel)
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "chart.bar")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
                
                VStack(spacing: 12) {
                    Text("No Data Yet")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("No statistics available yet. Add your first entry to see insights about your desires and refusals.")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct StatCard: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String
    var isWide: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                if !isWide {
                    Spacer()
                }
            }
            
            VStack(alignment: isWide ? .center : .leading, spacing: 4) {
                Text("\(count)")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: isWide ? .center : .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct RatioVisualization: View {
    let wantCount: Int
    let dontWantCount: Int
    
    private var total: Int {
        wantCount + dontWantCount
    }
    
    private var wantPercentage: Double {
        total > 0 ? Double(wantCount) / Double(total) : 0
    }
    
    private var dontWantPercentage: Double {
        total > 0 ? Double(dontWantCount) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(AppColors.wantColor)
                        .frame(width: geometry.size.width * wantPercentage)
                    
                    Rectangle()
                        .fill(AppColors.dontWantColor)
                        .frame(width: geometry.size.width * dontWantPercentage)
                }
            }
            .frame(height: 12)
            .background(AppColors.cardBackground)
            .cornerRadius(6)
            
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(AppColors.wantColor)
                        .frame(width: 12, height: 12)
                    
                    Text("Wants: \(Int(wantPercentage * 100))%")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(AppColors.dontWantColor)
                        .frame(width: 12, height: 12)
                    
                    Text("Don't Wants: \(Int(dontWantPercentage * 100))%")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

struct InsightsView: View {
    @ObservedObject var viewModel: WishViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                InsightRow(
                    icon: "calendar",
                    title: "Most recent entry",
                    value: mostRecentEntryText
                )
                
                InsightRow(
                    icon: "clock",
                    title: "Average per day",
                    value: averageEntriesPerDay
                )
                
                InsightRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Dominant type",
                    value: dominantType
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var mostRecentEntryText: String {
        guard let mostRecent = viewModel.entries.max(by: { $0.createdAt < $1.createdAt }) else {
            return "No entries"
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: mostRecent.createdAt, relativeTo: Date())
    }
    
    private var averageEntriesPerDay: String {
        guard !viewModel.entries.isEmpty else { return "0" }
        
        let oldestEntry = viewModel.entries.min(by: { $0.createdAt < $1.createdAt })
        let newestEntry = viewModel.entries.max(by: { $0.createdAt < $1.createdAt })
        
        guard let oldest = oldestEntry, let newest = newestEntry else { return "0" }
        
        let daysDifference = Calendar.current.dateComponents([.day], from: oldest.createdAt, to: newest.createdAt).day ?? 1
        let days = max(daysDifference, 1)
        let average = Double(viewModel.entries.count) / Double(days)
        
        return String(format: "%.1f", average)
    }
    
    private var dominantType: String {
        if viewModel.wantCount > viewModel.dontWantCount {
            return "Wants (\(viewModel.wantCount))"
        } else if viewModel.dontWantCount > viewModel.wantCount {
            return "Don't Wants (\(viewModel.dontWantCount))"
        } else {
            return "Balanced"
        }
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppColors.primaryPurple)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
    }
}
