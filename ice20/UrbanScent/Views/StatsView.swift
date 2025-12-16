import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: ScentViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                if viewModel.entries.isEmpty {
                    emptyStateSection
                } else {
                    frequentScentsSection
                    
                    emotionStatsSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 80)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("City Atmosphere")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            Text("Your scent patterns and emotions")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
        }
    }
    
    private var frequentScentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Most Frequent Scents")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            VStack(spacing: 12) {
                ForEach(Array(viewModel.getMostFrequentScents().enumerated()), id: \.offset) { index, item in
                    ScentFrequencyRow(
                        scent: item.scent,
                        count: item.count,
                        rank: index + 1,
                        maxCount: viewModel.getMostFrequentScents().first?.count ?? 1
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private var emotionStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emotions and Atmosphere")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            VStack(spacing: 12) {
                ForEach(viewModel.getEmotionStatistics(), id: \.emotion) { item in
                    EmotionStatsRow(
                        emotion: item.emotion,
                        count: item.count,
                        maxCount: viewModel.getEmotionStatistics().first?.count ?? 1
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.appTextTertiary)
            
            Text("No statistics yet. Add entries, and you'll see how your city lives.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(40)
    }
}

struct ScentFrequencyRow: View {
    let scent: String
    let count: Int
    let rank: Int
    let maxCount: Int
    
    private var fillPercentage: Double {
        return Double(count) / Double(maxCount)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(rank).")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(.appPrimaryYellow)
                    .frame(width: 20, alignment: .leading)
                
                Text(scent)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                Text("\(count) days")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.appTextSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appCardBorder)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appPrimaryYellow)
                        .frame(width: geometry.size.width * fillPercentage, height: 6)
                        .animation(.easeInOut(duration: 0.8), value: fillPercentage)
                }
            }
            .frame(height: 6)
        }
        .padding(.vertical, 8)
    }
}

struct EmotionStatsRow: View {
    let emotion: Emotion
    let count: Int
    let maxCount: Int
    
    private var fillPercentage: Double {
        return Double(count) / Double(maxCount)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: emotion.icon)
                    .foregroundColor(.appPrimaryYellow)
                    .frame(width: 24)
                
                Text(emotion.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                Text("\(count)")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(.appTextSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appCardBorder)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(emotionColor)
                        .frame(width: geometry.size.width * fillPercentage, height: 6)
                        .animation(.easeInOut(duration: 0.8), value: fillPercentage)
                }
            }
            .frame(height: 6)
        }
        .padding(.vertical, 8)
    }
    
    private var emotionColor: Color {
        switch emotion {
        case .calm:
            return .appAccentGreen
        case .cozy:
            return .appPrimaryYellow
        case .sad:
            return .appPrimaryBlue
        case .energetic:
            return .appAccentRed
        case .fresh:
            return .appPrimaryBlue.opacity(0.8)
        }
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        StatsView(viewModel: ScentViewModel())
    }
}
