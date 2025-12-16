import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: NoticeViewModel
    @Binding var selectedTab: TabItem
    
    private var todayEntry: DayEntry {
        viewModel.getTodayEntry()
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                Text("Today you noticed...")
                    .font(.ubuntu(24, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .padding(.top, 60)
                
                if todayEntry.hasAnyEntry {
                    VStack(spacing: 20) {
                        SummaryEntryRow(
                            icon: "sun.max",
                            title: "Morning",
                            text: todayEntry.morningEntry
                        )
                        
                        SummaryEntryRow(
                            icon: "sun.max.fill",
                            title: "Day",
                            text: todayEntry.dayEntry
                        )
                        
                        SummaryEntryRow(
                            icon: "moon",
                            title: "Evening",
                            text: todayEntry.eveningEntry
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Text("Every day can be lived more mindfully. And that's already a miracle.")
                        .font(.ubuntuItalic(16, weight: .light))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Button(action: {
                        selectedTab = .archive
                    }) {
                        Text("View Archive")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.theme.primaryPurple.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 100)
                    
                } else {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "heart")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Text("Nothing to remember today yet. But the day continues.")
                            .font(.ubuntu(18, weight: .light))
                            .foregroundColor(Color.theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            selectedTab = .home
                        }) {
                            Text("Start Noticing")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.theme.primaryPurple)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct SummaryEntryRow: View {
    let icon: String
    let title: String
    let text: String?
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.theme.accentGold)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Text(text ?? "—")
                    .font(.ubuntu(15, weight: .light))
                    .foregroundColor(text != nil ? Color.theme.primaryText : Color.theme.placeholderText)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(text != nil ? Color.theme.cardBackground : Color.theme.cardBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(text != nil ? Color.theme.cardBorder : Color.theme.cardBorder.opacity(0.5), lineWidth: 1)
                )
        )
    }
}


