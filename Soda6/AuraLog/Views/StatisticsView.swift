import SwiftUI

struct StatisticsView: View {
    @ObservedObject var store: PerfumeStore
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if store.perfumes.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.primaryYellow.opacity(0.6))
                            
                            VStack(spacing: 12) {
                                Text("No statistics yet")
                                    .font(.ubuntu(20, weight: .medium))
                                    .foregroundColor(.primaryText)
                                
                                Text("Add at least one fragrance and mark usage to see statistics.")
                                    .font(.ubuntu(16))
                                    .foregroundColor(.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        ScrollView {
                            VStack(spacing: 24) {
                                VStack(spacing: 8) {
                                    Text("Statistics")
                                        .font(.ubuntu(28, weight: .bold))
                                        .foregroundColor(.primaryText)
                                    
                                    Text("Your fragrance insights")
                                        .font(.ubuntu(16))
                                        .foregroundColor(.secondaryText)
                                }
                                .padding(.top, 10)
                                
                                StatCardView(
                                    title: "Total Usage",
                                    value: "\(store.totalUsages)",
                                    subtitle: "times worn",
                                    icon: "sparkles",
                                    color: .primaryYellow
                                )
                                
                                if !store.topUsedPerfumes.isEmpty {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Most Used Fragrances")
                                            .font(.ubuntu(20, weight: .medium))
                                            .foregroundColor(.primaryText)
                                        
                                        VStack(spacing: 12) {
                                            ForEach(Array(store.topUsedPerfumes.enumerated()), id: \.element.id) { index, perfume in
                                                NavigationLink(destination: PerfumeDetailView(perfume: perfume, store: store)) {
                                                    TopPerfumeRowView(
                                                        rank: index + 1,
                                                        perfume: perfume
                                                    )
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                    .padding(20)
                                    .background(AppGradients.cardGradient)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("By Season")
                                        .font(.ubuntu(20, weight: .medium))
                                        .foregroundColor(.primaryText)
                                    
                                    VStack(spacing: 12) {
                                        ForEach(Perfume.Season.allCases, id: \.self) { season in
                                            let count = store.perfumesBySeason[season] ?? 0
                                            if count > 0 {
                                                StatRowView(
                                                    title: season.rawValue,
                                                    count: count,
                                                    total: store.perfumes.count,
                                                    color: seasonColor(for: season)
                                                )
                                            }
                                        }
                                    }
                                }
                                .padding(20)
                                .background(AppGradients.cardGradient)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("By Mood")
                                        .font(.ubuntu(20, weight: .medium))
                                        .foregroundColor(.primaryText)
                                    
                                    VStack(spacing: 12) {
                                        ForEach(Perfume.Mood.allCases, id: \.self) { mood in
                                            let count = store.perfumesByMood[mood] ?? 0
                                            if count > 0 {
                                                StatRowView(
                                                    title: mood.rawValue,
                                                    count: count,
                                                    total: store.perfumes.count,
                                                    color: moodColor(for: mood)
                                                )
                                            }
                                        }
                                    }
                                }
                                .padding(20)
                                .background(AppGradients.cardGradient)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                            .padding(20)
                        }
                    }
                }
            }
        }
    }
    
    private func seasonColor(for season: Perfume.Season) -> Color {
        switch season {
        case .spring: return .accentGreen
        case .summer: return .primaryYellow
        case .autumn: return .accentOrange
        case .winter: return .primaryBlue
        case .universal: return .primaryPurple
        }
    }
    
    private func moodColor(for mood: Perfume.Mood) -> Color {
        switch mood {
        case .energetic: return .accentOrange
        case .romantic: return .accentPink
        case .casual: return .accentGreen
        case .evening: return .primaryPurple
        case .fresh: return .primaryBlue
        case .mysterious: return .primaryPurple.opacity(0.8)
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(.primaryText)
                
                Text(subtitle)
                    .font(.ubuntu(14))
                    .foregroundColor(.secondaryText)
            }
            
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(AppGradients.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct TopPerfumeRowView: View {
    let rank: Int
    let perfume: Perfume
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(rank)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(.primaryText)
                .frame(width: 32, height: 32)
                .background(rankColor(for: rank))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(perfume.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.primaryText)
                    .lineLimit(1)
                
                Text(perfume.brand)
                    .font(.ubuntu(14))
                    .foregroundColor(.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(perfume.usageCount)")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.primaryYellow)
                
                Text("uses")
                    .font(.ubuntu(12))
                    .foregroundColor(.secondaryText)
            }
        }
        .padding(16)
        .background(Color.surfaceBackground)
        .cornerRadius(12)
    }
    
    private func rankColor(for rank: Int) -> Color {
        switch rank {
        case 1: return .primaryYellow
        case 2: return .primaryBlue.opacity(0.8)
        case 3: return .accentOrange
        default: return .primaryPurple.opacity(0.6)
        }
    }
}

struct StatRowView: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
    }
}
