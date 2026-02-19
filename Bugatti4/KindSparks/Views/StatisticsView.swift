import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var dataManager = DataManager.shared
    
    private var totalPeople: Int {
        dataManager.people.count
    }
    
    private var totalIdeas: Int {
        dataManager.getAllIdeas().count
    }
    
    private var averageIdeasPerPerson: Double {
        guard totalPeople > 0 else { return 0 }
        return Double(totalIdeas) / Double(totalPeople)
    }
    
    private var ideasPerPersonData: [(name: String, count: Int)] {
        dataManager.people
            .map { (name: $0.name, count: $0.ideas.count) }
            .sorted { $0.count > $1.count }
    }
    
    private var ideasByMonthData: [(month: String, count: Int)] {
        let ideas = dataManager.getAllIdeas()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        let grouped = Dictionary(grouping: ideas) { idea -> String in
            formatter.string(from: idea.createdAt)
        }
        return grouped
            .map { (month: $0.key, count: $0.value.count) }
            .sorted { $0.month < $1.month }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 24) {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                StatCard(title: "Total People", value: "\(totalPeople)", icon: "person.2.fill")
                                StatCard(title: "Total Ideas", value: "\(totalIdeas)", icon: "lightbulb.fill")
                            }
                            HStack(spacing: 12) {
                                StatCard(title: "Avg per person", value: String(format: "%.1f", averageIdeasPerPerson), icon: "chart.bar.doc.horizontal")
                                if let top = ideasPerPersonData.first, top.count > 0 {
                                    StatCard(title: "Most ideas", value: "\(top.count)", subtitle: top.name, icon: "star.fill")
                                } else {
                                    StatCard(title: "Most ideas", value: "0", icon: "star.fill")
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        if !ideasPerPersonData.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Ideas per person")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(.appTextPrimary)
                                    .padding(.horizontal, 20)
                                
                                Chart(ideasPerPersonData, id: \.name) { item in
                                    BarMark(
                                        x: .value("Person", item.name),
                                        y: .value("Ideas", item.count)
                                    )
                                    .foregroundStyle(Color.appAccent.gradient)
                                    .cornerRadius(6)
                                }
                                .frame(height: 220)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.appCard)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        if totalIdeas > 0 && !ideasPerPersonData.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Share of all ideas")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(.appTextPrimary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    ForEach(ideasPerPersonData, id: \.name) { item in
                                        HStack(spacing: 12) {
                                            Text(item.name)
                                                .font(.ubuntu(14))
                                                .foregroundColor(.appTextPrimary)
                                                .lineLimit(1)
                                                .frame(width: 80, alignment: .leading)
                                            
                                            GeometryReader { geo in
                                                ZStack(alignment: .leading) {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(Color.appTextSecondary.opacity(0.2))
                                                        .frame(height: 20)
                                                    
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(Color.appAccent)
                                                        .frame(width: max(0, geo.size.width * CGFloat(item.count) / CGFloat(totalIdeas)), height: 20)
                                                }
                                            }
                                            .frame(height: 20)
                                            
                                            Text("\(item.count)")
                                                .font(.ubuntu(14, weight: .medium))
                                                .foregroundColor(.appTextPrimary)
                                                .frame(width: 28, alignment: .trailing)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.appCard)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        if !ideasByMonthData.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Ideas by month")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(.appTextPrimary)
                                    .padding(.horizontal, 20)
                                
                                Chart(ideasByMonthData, id: \.month) { item in
                                    BarMark(
                                        x: .value("Month", item.month),
                                        y: .value("Ideas", item.count)
                                    )
                                    .foregroundStyle(Color.purple)
                                    .cornerRadius(6)
                                }
                                .frame(height: 200)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.appCard)
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        if dataManager.people.isEmpty && totalIdeas == 0 {
                            VStack(spacing: 16) {
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.system(size: 50))
                                    .foregroundColor(.appTextSecondary)
                                Text("Add people and ideas to see charts here.")
                                    .font(.ubuntu(14))
                                    .foregroundColor(.appTextSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 40)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    var subtitle: String? = nil
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.appAccent)
                .frame(width: 44)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(12))
                    .foregroundColor(.appTextSecondary)
                
                Text(value)
                    .font(.ubuntu(22, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.ubuntu(12))
                        .foregroundColor(.appTextSecondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCard)
        )
    }
}

#Preview {
    StatisticsView()
}
