import SwiftUI

struct StatisticsView: View {
    @StateObject private var contentIdeasViewModel = ContentIdeasViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        statisticsCards
                        
                        contentBreakdown
                        
                        statusDistribution
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Your Content Overview")
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Track your progress and productivity")
                .font(.playfairDisplay(14, weight: .regular))
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(.vertical, 10)
    }
    
    private var statisticsCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Ideas",
                    value: "\(contentIdeasViewModel.ideas.count)",
                    icon: "lightbulb.fill",
                    color: Color.theme.primaryYellow
                )
                
                StatCard(
                    title: "Published",
                    value: "\(publishedCount)",
                    icon: "checkmark.circle.fill",
                    color: Color.theme.statusCompleted
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "In Progress",
                    value: "\(inProgressCount)",
                    icon: "clock.fill",
                    color: Color.theme.statusInProgress
                )
                
                StatCard(
                    title: "Notes",
                    value: "\(notesViewModel.notes.count)",
                    icon: "note.text",
                    color: Color.theme.primaryBlue
                )
            }
        }
    }
    
    private var contentBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Content Type Breakdown")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                ContentTypeStatRow(
                    type: "Photo",
                    count: photoCount,
                    total: contentIdeasViewModel.ideas.count,
                    icon: "photo",
                    color: Color.theme.primaryBlue
                )
                
                ContentTypeStatRow(
                    type: "Video",
                    count: videoCount,
                    total: contentIdeasViewModel.ideas.count,
                    icon: "video",
                    color: Color.theme.primaryPurple
                )
                
                ContentTypeStatRow(
                    type: "Text",
                    count: textCount,
                    total: contentIdeasViewModel.ideas.count,
                    icon: "text.alignleft",
                    color: Color.theme.primaryYellow
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardGradient)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var statusDistribution: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status Distribution")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                StatusStatRow(
                    status: "Ideas",
                    count: ideaCount,
                    total: contentIdeasViewModel.ideas.count,
                    color: Color.theme.statusIdea
                )
                
                StatusStatRow(
                    status: "In Progress",
                    count: inProgressCount,
                    total: contentIdeasViewModel.ideas.count,
                    color: Color.theme.statusInProgress
                )
                
                StatusStatRow(
                    status: "Published",
                    count: publishedCount,
                    total: contentIdeasViewModel.ideas.count,
                    color: Color.theme.statusCompleted
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardGradient)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var publishedCount: Int {
        contentIdeasViewModel.ideas.filter { $0.status == .published }.count
    }
    
    private var inProgressCount: Int {
        contentIdeasViewModel.ideas.filter { $0.status == .inProgress }.count
    }
    
    private var ideaCount: Int {
        contentIdeasViewModel.ideas.filter { $0.status == .idea }.count
    }
    
    private var photoCount: Int {
        contentIdeasViewModel.ideas.filter { $0.contentType == .photo }.count
    }
    
    private var videoCount: Int {
        contentIdeasViewModel.ideas.filter { $0.contentType == .video }.count
    }
    
    private var textCount: Int {
        contentIdeasViewModel.ideas.filter { $0.contentType == .text }.count
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
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text(title)
                .font(.playfairDisplay(12, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.cardGradient)
                .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
        )
    }
}

struct ContentTypeStatRow: View {
    let type: String
    let count: Int
    let total: Int
    let icon: String
    let color: Color
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(type)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.secondaryText.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

struct StatusStatRow: View {
    let status: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                
                Text(status)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.secondaryText.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    StatisticsView()
}
