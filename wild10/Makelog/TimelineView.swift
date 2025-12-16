import SwiftUI

struct TimelineView: View {
    @ObservedObject var viewModel: WeatherEntriesViewModel
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.hasEntries {
                    timelineListView
                } else {
                    emptyStateView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Timeline")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.md)
    }
    
    private var timelineListView: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(sortedEntriesByDate, id: \.id) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry, viewModel: viewModel)) {
                        TimelineEntryView(entry: entry)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "calendar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.sm) {
                Text("No entries to display")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Start documenting your weather experiences to see them here")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { withAnimation { selectedTab = 3 } }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Entry")
                        .font(AppFonts.headline)
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(AppColors.buttonBackground)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
    }
    
    private var sortedEntriesByDate: [WeatherEntry] {
        return viewModel.entries.sorted { $0.date > $1.date }
    }
}

struct TimelineEntryView: View {
    let entry: WeatherEntry
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: entry.date))
                    .font(AppFonts.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(monthFormatter.string(from: entry.date))
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                    .textCase(.uppercase)
            }
            .frame(width: 50)
            
            VStack {
                Circle()
                    .fill(AppColors.primaryPurple)
                    .frame(width: 12, height: 12)
                
                Rectangle()
                    .fill(AppColors.primaryPurple.opacity(0.3))
                    .frame(width: 2)
            }
            .frame(width: 12)
            
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text(entry.category.name)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.buttonText)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: AppCornerRadius.small)
                                .fill(AppColors.primaryPurple)
                        )
                    
                    Spacer()
                    
                    Text(timeFormatter.string(from: entry.date))
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textTertiary)
                }
                
                Text(entry.truncatedDescription)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}


