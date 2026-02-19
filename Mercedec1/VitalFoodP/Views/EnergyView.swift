import SwiftUI

struct EnergyView: View {
    @StateObject private var viewModel = EnergyViewModel()
    @State private var showingAddEntry = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Energy Tracking")
                        .font(FontManager.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .padding(.top, 20)
                    
                    EnergyChartView(entries: viewModel.getEntriesForLast7Days())
                    
                    MoodCircleView(moodDistribution: viewModel.getMoodDistribution())
                    
                    VStack(spacing: 8) {
                        Text("Average Energy (7 days)")
                            .font(FontManager.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text(String(format: "%.1f/10", viewModel.getAverageEnergyForLast7Days()))
                            .font(FontManager.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.accentText)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Notes")
                            .font(FontManager.ubuntu(20, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(.horizontal, 20)
                        
                        if viewModel.energyEntries.isEmpty {
                            Text("No entries yet")
                                .font(FontManager.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.secondaryText)
                                .padding(.horizontal, 20)
                        } else {
                            ForEach(viewModel.energyEntries.prefix(5).sorted { $0.timestamp > $1.timestamp }) { entry in
                                EnergyEntryCard(entry: entry)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Button(action: { showingAddEntry = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            Text("Add Energy Entry")
                                .font(FontManager.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(ColorTheme.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorTheme.buttonBackground)
                        .cornerRadius(25)
                        .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            AddEnergyEntryView(viewModel: viewModel)
        }
    }
}

struct EnergyChartView: View {
    let entries: [EnergyEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Energy Level (Last 7 Days)")
                .font(FontManager.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 20)
            
            if entries.isEmpty {
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardBackground)
                    .frame(height: 200)
                    .overlay(
                        Text("No data available")
                            .font(FontManager.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                    )
                    .padding(.horizontal, 20)
            } else {
                VStack(spacing: 8) {
                    GeometryReader { geometry in
                        let maxValue: CGFloat = 10
                        let width = geometry.size.width
                        let height = geometry.size.height
                        
                        Path { path in
                            for (index, entry) in entries.enumerated() {
                                let x = CGFloat(index) * (width / CGFloat(max(entries.count - 1, 1)))
                                let y = height - (CGFloat(entry.energyLevel) / maxValue * height)
                                
                                if index == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(ColorTheme.primaryYellow, lineWidth: 3)
                        
                        ForEach(Array(entries.enumerated()), id: \.offset) { index, entry in
                            let x = CGFloat(index) * (width / CGFloat(max(entries.count - 1, 1)))
                            let y = height - (CGFloat(entry.energyLevel) / maxValue * height)
                            
                            Circle()
                                .fill(entry.mood.color)
                                .frame(width: 12, height: 12)
                                .position(x: x, y: y)
                        }
                    }
                    .frame(height: 150)
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text("0")
                            .font(FontManager.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                        Spacer()
                        Text("5")
                            .font(FontManager.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                        Spacer()
                        Text("10")
                            .font(FontManager.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
                .background(ColorTheme.cardBackground)
                .cornerRadius(16)
                .padding(.horizontal, 20)
            }
        }
    }
}

struct MoodCircleView: View {
    let moodDistribution: [MoodType: Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Distribution")
                .font(FontManager.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 20)
            
            HStack {
                ZStack {
                    Circle()
                        .fill(ColorTheme.cardBackground)
                        .frame(width: 120, height: 120)
                    
                    VStack(spacing: 4) {
                        let dominantMood = moodDistribution.max { $0.value < $1.value }?.key ?? .happy
                        
                        Image(systemName: dominantMood.icon)
                            .font(.system(size: 30))
                            .foregroundColor(dominantMood.color)
                        
                        Text("Most Common")
                            .font(FontManager.ubuntu(10, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Text(dominantMood.rawValue)
                            .font(FontManager.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(MoodType.allCases.prefix(4), id: \.self) { mood in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(mood.color)
                                .frame(width: 12, height: 12)
                            
                            Text(mood.rawValue)
                                .font(FontManager.ubuntu(12, weight: .regular))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                            
                            Text("\(moodDistribution[mood] ?? 0)")
                                .font(FontManager.ubuntu(12, weight: .medium))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }
}

struct EnergyEntryCard: View {
    let entry: EnergyEntry
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(entry.mood.color)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: entry.mood.icon)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.mood.rawValue)
                        .font(FontManager.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Text("Energy: \(entry.energyLevel)/10")
                        .font(FontManager.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.accentText)
                }
                
                if !entry.note.isEmpty {
                    Text(entry.note)
                        .font(FontManager.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(2)
                }
                
                Text(DateFormatter.timeFormatter.string(from: entry.timestamp))
                    .font(FontManager.ubuntu(10, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
}

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    EnergyView()
}
