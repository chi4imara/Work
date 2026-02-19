import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var totalPracticesCompleted: Int {
        dataManager.history.reduce(0) { $0 + $1.completedPractices.count }
    }
    
    private var totalChallengesCompleted: Int {
        dataManager.history.reduce(0) { $0 + $1.completedChallenges.count }
    }
    
    private var bestStreak: Int {
        dataManager.practices.map(\.streak).max() ?? 0
    }
    
    private var averageCareLevel: Double {
        let entries = dataManager.history.filter { $0.careLevel > 0 }
        guard !entries.isEmpty else { return 0 }
        return entries.map(\.careLevel).reduce(0, +) / Double(entries.count)
    }
    
    private var activeDaysCount: Int {
        dataManager.history.filter { $0.careLevel > 0 }.count
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.playfair(24, weight: .bold))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        CardView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Overview")
                                    .font(.playfair(20, weight: .semibold))
                                    .foregroundColor(ColorTheme.textColor)
                                
                                HStack(spacing: 16) {
                                    StatItem(value: "\(activeDaysCount)", label: "Active days")
                                    StatItem(value: "\(totalPracticesCompleted)", label: "Practices done")
                                    StatItem(value: "\(totalChallengesCompleted)", label: "Challenges")
                                }
                            }
                        }
                        
                        CardView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Average Care Level")
                                    .font(.playfair(20, weight: .semibold))
                                    .foregroundColor(ColorTheme.textColor)
                                
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorTheme.secondaryColor.opacity(0.2))
                                            .frame(height: 24)
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorTheme.accentColor)
                                            .frame(width: max(0, geo.size.width * CGFloat(averageCareLevel)), height: 24)
                                    }
                                }
                                .frame(height: 24)
                                
                                Text("\(Int(averageCareLevel * 100))%")
                                    .font(.playfair(18, weight: .bold))
                                    .foregroundColor(ColorTheme.accentColor)
                            }
                        }
                        
                        CardView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Best Streak")
                                    .font(.playfair(20, weight: .semibold))
                                    .foregroundColor(ColorTheme.textColor)
                                
                                HStack(alignment: .bottom) {
                                    Text("\(bestStreak)")
                                        .font(.playfair(40, weight: .bold))
                                        .foregroundColor(ColorTheme.accentColor)
                                    
                                    Text("days in a row")
                                        .font(.playfair(16))
                                        .foregroundColor(ColorTheme.secondaryColor)
                                        .padding(.bottom, 8)
                                }
                            }
                        }
                        
                        if !dataManager.practices.isEmpty {
                            CardView {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Practices by Type")
                                        .font(.playfair(20, weight: .semibold))
                                        .foregroundColor(ColorTheme.textColor)
                                    
                                    ForEach(PracticeType.allCases, id: \.self) { type in
                                        let count = dataManager.practices.filter { $0.type == type }.count
                                        if count > 0 {
                                            HStack {
                                                Image(systemName: type.icon)
                                                    .foregroundColor(ColorTheme.accentColor)
                                                    .frame(width: 24)
                                                Text(type.rawValue)
                                                    .font(.playfair(16))
                                                    .foregroundColor(ColorTheme.textColor)
                                                Spacer()
                                                Text("\(count)")
                                                    .font(.playfair(16, weight: .medium))
                                                    .foregroundColor(ColorTheme.accentColor)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.playfair(22, weight: .bold))
                .foregroundColor(ColorTheme.accentColor)
            Text(label)
                .font(.playfair(12))
                .foregroundColor(ColorTheme.secondaryColor)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(DataManager.shared)
}
