import SwiftUI

struct UsageHistoryView: View {
    @ObservedObject var viewModel: ToolsViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Usage History")
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                if viewModel.usages.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    contentView
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.lightBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No Usage Records")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(Color.theme.white)
                
                Text("Start using your tools to see history")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(sortedDates, id: \.self) { date in
                    UsageDateSection(
                        date: date,
                        usages: viewModel.groupedUsages[date] ?? [],
                        viewModel: viewModel
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var sortedDates: [Date] {
        Array(viewModel.groupedUsages.keys).sorted { $0 > $1 }
    }
}

struct UsageDateSection: View {
    let date: Date
    let usages: [Usage]
    let viewModel: ToolsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(formattedDate(date))
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(Color.theme.white)
                
                Spacer()
                
                Text("\(usages.count) tool\(usages.count == 1 ? "" : "s")")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(Color.theme.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.theme.orange.opacity(0.2))
                    )
            }
            
            VStack(spacing: 8) {
                ForEach(usages.sorted { $0.date > $1.date }) { usage in
                    UsageItemView(usage: usage, viewModel: viewModel)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
        )
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

struct UsageItemView: View {
    let usage: Usage
    let viewModel: ToolsViewModel
    @State private var showingToolDetail = false
    
    var body: some View {
        Button(action: {
            showingToolDetail = true
        }) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(formattedTime(usage.date))
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(Color.theme.lightBlue)
                    
                    Text("Used")
                        .font(.playfairDisplay(12))
                        .foregroundColor(Color.theme.white.opacity(0.6))
                }
                .frame(width: 60, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(usage.toolName)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(Color.theme.white)
                        .multilineTextAlignment(.leading)
                    
                    if let tool = findTool(by: usage.toolId) {
                        Text(tool.category.displayName)
                            .font(.playfairDisplay(12))
                            .foregroundColor(Color.theme.orange)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.white.opacity(0.5))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.theme.white.opacity(0.05))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingToolDetail) {
            if let tool = findTool(by: usage.toolId) {
                ToolDetailView(tool: tool, viewModel: viewModel)
            }
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func findTool(by id: UUID) -> Tool? {
        return viewModel.tools.first { $0.id == id }
    }
}

#Preview {
    UsageHistoryView(viewModel: ToolsViewModel())
}
