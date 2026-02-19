import SwiftUI
import Combine

struct StatisticsView: View {
    @ObservedObject var viewModel: OutfitViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                    
                    Button("Refresh") {
                        viewModel.objectWillChange.send()
                    }
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.outfits.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    statisticsContent
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            Text("No Data Available")
                .font(.playfairDisplay(24, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            Text("Not enough data for statistics. Add at least one outfit to see your style insights.")
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                overviewSection
                
                comfortSection
                
                moodSection
                
                reactionSection
                
                topTagsSection
                
                bestOutfitsSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Total Outfits",
                    value: "\(viewModel.outfits.count)",
                    icon: "tshirt",
                    color: ColorManager.primaryText
                )
                
                StatCard(
                    title: "Average Comfort",
                    value: String(format: "%.1f/10", viewModel.averageComfort),
                    icon: "heart",
                    color: ColorManager.successGreen
                )
                
                StatCard(
                    title: "Total Tags",
                    value: "\(viewModel.tags.count)",
                    icon: "tag",
                    color: ColorManager.accentYellow
                )
                
                StatCard(
                    title: "This Month",
                    value: "\(outfitsThisMonth)",
                    icon: "calendar",
                    color: ColorManager.purpleDark
                )
            }
        }
    }
    
    private var comfortSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Comfort Analysis")
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Average Comfort Level")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                    
                    Text(String(format: "%.1f/10", viewModel.averageComfort))
                        .font(.playfairDisplay(18, weight: .bold))
                        .foregroundColor(ColorManager.accentYellow)
                }
                
                HStack(spacing: 2) {
                    ForEach(1...10, id: \.self) { index in
                        Rectangle()
                            .fill(Double(index) <= viewModel.averageComfort ? ColorManager.accentYellow : ColorManager.neutralGray.opacity(0.3))
                            .frame(height: 8)
                            .cornerRadius(4)
                    }
                }
                
                VStack(spacing: 8) {
                    Text("Comfort Distribution")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    ForEach(comfortRanges, id: \.range) { item in
                        HStack {
                            Text(item.range)
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(width: 80, alignment: .leading)
                            
                            GeometryReader { geometry in
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(ColorManager.primaryText)
                                        .frame(width: geometry.size.width * item.percentage)
                                        .cornerRadius(4)
                                    
                                    Spacer(minLength: 0)
                                }
                            }
                            .frame(height: 8)
                            
                            Text("\(item.count)")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(width: 30, alignment: .trailing)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
        }
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Distribution")
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    let count = viewModel.moodDistribution[mood] ?? 0
                    let percentage = viewModel.outfits.isEmpty ? 0.0 : Double(count) / Double(viewModel.outfits.count)
                    
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: mood.icon)
                                .foregroundColor(mood.color)
                                .frame(width: 20)
                            
                            Text(mood.rawValue)
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(width: 80, alignment: .leading)
                        }
                        
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(mood.color)
                                    .frame(width: geometry.size.width * percentage)
                                    .cornerRadius(4)
                                
                                Spacer(minLength: 0)
                            }
                        }
                        .frame(height: 8)
                        
                        Text("\(count)")
                            .font(.playfairDisplay(14, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(width: 30, alignment: .trailing)
                        
                        Text(String(format: "%.0f%%", percentage * 100))
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                            .frame(width: 40, alignment: .trailing)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
        }
    }
    
    private var reactionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Others' Reactions")
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                ForEach(Reaction.allCases, id: \.self) { reaction in
                    let count = viewModel.reactionDistribution[reaction] ?? 0
                    let percentage = viewModel.outfits.isEmpty ? 0.0 : Double(count) / Double(viewModel.outfits.count)
                    
                    HStack {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(reaction.color)
                                .frame(width: 12, height: 12)
                            
                            Text(reaction.rawValue)
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(width: 100, alignment: .leading)
                        }
                        
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(reaction.color)
                                    .frame(width: geometry.size.width * percentage)
                                    .cornerRadius(4)
                                
                                Spacer(minLength: 0)
                            }
                        }
                        .frame(height: 8)
                        
                        Text("\(count)")
                            .font(.playfairDisplay(14, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
        }
    }
    
    private var topTagsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Most Used Tags")
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            if viewModel.mostUsedTags.isEmpty {
                Text("No tags yet")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(ColorManager.cardGradient)
                    .cornerRadius(16)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(viewModel.mostUsedTags.enumerated()), id: \.element.name) { index, tag in
                        HStack {
                            Text("#\(index + 1)")
                                .font(.playfairDisplay(16, weight: .bold))
                                .foregroundColor(ColorManager.accentYellow)
                                .frame(width: 30)
                            
                            Text(tag.name)
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            Text("\(tag.usageCount) times")
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(ColorManager.secondaryText)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(ColorManager.cardGradient)
                .cornerRadius(16)
            }
        }
    }
    
    private var bestOutfitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Comfort Days")
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            if viewModel.topOutfits.isEmpty {
                Text("No outfits yet")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(ColorManager.cardGradient)
                    .cornerRadius(16)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(viewModel.topOutfits.enumerated()), id: \.element.id) { index, outfit in
                        HStack {
                            Text("#\(index + 1)")
                                .font(.playfairDisplay(16, weight: .bold))
                                .foregroundColor(ColorManager.accentYellow)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(outfit.shortDescription)
                                    .font(.playfairDisplay(15, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                    .lineLimit(1)
                                
                                Text(outfit.dateString)
                                    .font(.playfairDisplay(12))
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text("\(outfit.comfort)/10")
                                .font(.playfairDisplay(16, weight: .bold))
                                .foregroundColor(ColorManager.accentYellow)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(ColorManager.cardGradient)
                .cornerRadius(16)
            }
        }
    }
    
    private var outfitsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.outfits.filter { outfit in
            calendar.isDate(outfit.date, equalTo: now, toGranularity: .month)
        }.count
    }
    
    private var comfortRanges: [(range: String, count: Int, percentage: Double)] {
        let ranges = [
            ("1-3", viewModel.outfits.filter { $0.comfort >= 1 && $0.comfort <= 3 }.count),
            ("4-6", viewModel.outfits.filter { $0.comfort >= 4 && $0.comfort <= 6 }.count),
            ("7-8", viewModel.outfits.filter { $0.comfort >= 7 && $0.comfort <= 8 }.count),
            ("9-10", viewModel.outfits.filter { $0.comfort >= 9 && $0.comfort <= 10 }.count)
        ]
        
        let total = viewModel.outfits.count
        return ranges.map { (range, count) in
            let percentage = total > 0 ? Double(count) / Double(total) : 0.0
            return (range: range, count: count, percentage: percentage)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Text(title)
                .font(.playfairDisplay(12, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorManager.cardGradient)
        .cornerRadius(12)
    }
}

#Preview {
    StatisticsView(viewModel: OutfitViewModel())
}

