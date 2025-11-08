import SwiftUI

struct BarChartView: View {
    let tagStatistics: [(tag: String, count: Int)]
    
    private var maxCount: Int {
        tagStatistics.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(tagStatistics.prefix(8), id: \.tag) { stat in
                HStack(spacing: 12) {
                    Text(stat.tag)
                        .font(.nunitoMedium(size: 14))
                        .foregroundColor(.textPrimary)
                        .frame(width: 80, alignment: .leading)
                        .lineLimit(1)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.backgroundGray)
                                .frame(height: 20)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.tagColor(for: stat.tag))
                                .frame(
                                    width: geometry.size.width * (Double(stat.count) / Double(maxCount)),
                                    height: 20
                                )
                                .animation(.easeInOut(duration: 0.8), value: stat.count)
                        }
                    }
                    .frame(height: 20)
                    
                    Text("\(stat.count)")
                        .font(.nunitoMedium(size: 12))
                        .foregroundColor(.textSecondary)
                        .frame(width: 30, alignment: .trailing)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct HorizontalBarChartView: View {
    let tagStatistics: [(tag: String, count: Int)]
    
    private var maxCount: Int {
        tagStatistics.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(tagStatistics.prefix(6), id: \.tag) { stat in
                VStack(spacing: 4) {
                    HStack {
                        Text(stat.tag)
                            .font(.nunitoMedium(size: 12))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Text("\(stat.count)")
                            .font(.nunitoMedium(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.backgroundGray)
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.tagColor(for: stat.tag))
                                .frame(
                                    width: geometry.size.width * (Double(stat.count) / Double(maxCount)),
                                    height: 8
                                )
                                .animation(.easeInOut(duration: 0.8), value: stat.count)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let sampleData = [
        (tag: "work", count: 15),
        (tag: "travel", count: 8),
        (tag: "family", count: 12),
        (tag: "friends", count: 6),
        (tag: "hobby", count: 4)
    ]
    
    VStack(spacing: 20) {
        BarChartView(tagStatistics: sampleData)
        
        HorizontalBarChartView(tagStatistics: sampleData)
    }
    .padding()
}
