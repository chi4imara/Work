import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: StyleViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Statistics")
                            .font(.lumierepolis(size: 32, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                        
                        Text("Your style collection insights")
                            .font(.lumierepolis(size: 16))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 16) {
                        StatCard(
                            icon: "scissors.badge.ellipsis",
                            title: "Total Styles",
                            value: "\(viewModel.styles.count)",
                            subtitle: "styles in your catalog",
                            color: ColorTheme.orange
                        )
                        
                        HStack(spacing: 16) {
                            StatCard(
                                icon: "scissors",
                                title: "Haircuts",
                                value: "\(viewModel.styles.filter { $0.category == .haircut }.count)",
                                subtitle: "haircut styles",
                                color: ColorTheme.accent
                            )
                            
                            StatCard(
                                icon: "mustache",
                                title: "Beards",
                                value: "\(viewModel.styles.filter { $0.category == .beard }.count)",
                                subtitle: "beard styles",
                                color: ColorTheme.lightBlue
                            )
                        }
                        
                        StatCard(
                            icon: "heart.fill",
                            title: "Favorites",
                            value: "\(viewModel.favoriteStyles.count)",
                            subtitle: "favorite styles",
                            color: ColorTheme.orange
                        )
                        
                        if !viewModel.styles.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Length Distribution")
                                    .font(.lumierepolis(size: 18, weight: .bold))
                                    .foregroundColor(ColorTheme.white)
                                
                                VStack(spacing: 8) {
                                    let lengthGroups = Dictionary(grouping: viewModel.styles, by: { $0.length })
                                    ForEach(lengthGroups.keys.sorted(), id: \.self) { length in
                                        if let styles = lengthGroups[length], !length.isEmpty {
                                            LengthBar(
                                                length: length,
                                                count: styles.count,
                                                total: viewModel.styles.count
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(ColorTheme.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(ColorTheme.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 120)
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(color)
                }
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(.lumierepolis(size: 32, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Text(title)
                        .font(.lumierepolis(size: 14, weight: .bold))
                        .foregroundColor(ColorTheme.white.opacity(0.8))
                    
                    Text(subtitle)
                        .font(.lumierepolis(size: 12))
                        .foregroundColor(ColorTheme.white.opacity(0.6))
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct LengthBar: View {
    let length: String
    let count: Int
    let total: Int
    
    var percentage: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(count) / CGFloat(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(length)
                    .font(.lumierepolis(size: 14, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                
                Spacer()
                
                Text("\(count)")
                    .font(.lumierepolis(size: 14))
                    .foregroundColor(ColorTheme.white.opacity(0.7))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorTheme.white.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorTheme.orange)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}
