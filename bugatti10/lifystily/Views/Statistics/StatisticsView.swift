import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "chart.bar.doc.horizontal.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.primaryBlue)
                        Text("Statistics")
                            .font(.ubuntuTitle())
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    .padding(.top, 20)
                    
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Total Entries",
                            value: "\(diaryViewModel.entries.count)",
                            icon: "book.closed.fill",
                            color: ColorTheme.primaryBlue
                        )
                        StatCard(
                            title: "Favorites",
                            value: "\(diaryViewModel.favoriteEntries.count)",
                            icon: "heart.fill",
                            color: ColorTheme.softPink
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    if !diaryViewModel.entries.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Mood Overview")
                                .font(.ubuntuHeadline())
                                .foregroundColor(ColorTheme.accentText)
                            
                            VStack(spacing: 12) {
                                ForEach(MoodType.allCases, id: \.self) { mood in
                                    let count = diaryViewModel.entries.filter { $0.mood == mood || $0.emotions.contains(mood) }.count
                                    if count > 0 {
                                        MoodStatRow(mood: mood, count: count, total: diaryViewModel.entries.count)
                                    }
                                }
                            }
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(16)
                            .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    if diaryViewModel.entries.isEmpty {
                        VStack(spacing: 16) {
                            Text("Your statistics will appear here as you add entries")
                                .font(.ubuntuBody())
                                .foregroundColor(ColorTheme.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 40)
                    }
                }
                .padding(.bottom, 120)
            }
        }
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
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.ubuntuTitle())
                .foregroundColor(ColorTheme.primaryText)
            Text(title)
                .font(.ubuntuCaption())
                .foregroundColor(ColorTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct MoodStatRow: View {
    let mood: MoodType
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: mood.icon)
                    .font(.body)
                    .foregroundColor(mood.color)
                Text(mood.displayName)
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.primaryText)
                Spacer()
                Text("\(count)")
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.accentText)
                Text(String(format: "%.0f%%", percentage))
                    .font(.ubuntuCaption())
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorTheme.gridBlue)
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(mood.color)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(DiaryViewModel())
}
