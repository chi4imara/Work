import SwiftUI

struct CalendarView: View {
    @ObservedObject var moodViewModel: MoodViewModel
    @ObservedObject var settings: AppSettings
    @State private var showingMoodSettings = false
    @State private var showingMoodEntry = false
    @State private var selectedDateForEntry: DateWrapper?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        calendarView
                        
                        if moodViewModel.moodEntries.isEmpty {
                            emptyStateView
                        } else {
                            recentEntriesView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingMoodSettings) {
            MoodSettingsView(settings: settings)
        }
        .sheet(item: $selectedDateForEntry) { dateWrapper in
            MoodEntryView(
                moodViewModel: moodViewModel,
                settings: settings,
                selectedDate: dateWrapper.date
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Mood Diary")
                .font(FontManager.title)
                .foregroundColor(Color.textPrimary)
            
            Spacer()
            
            Button(action: {
                showingMoodSettings = true
            }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.primaryBlue)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.lightBlue.opacity(0.2))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var calendarView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        moodViewModel.currentMonth = Calendar.current.date(
                            byAdding: .month,
                            value: -1,
                            to: moodViewModel.currentMonth
                        ) ?? moodViewModel.currentMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.primaryBlue)
                }
                
                Spacer()
                
                Text(monthYearString(from: moodViewModel.currentMonth))
                    .font(FontManager.headline)
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        moodViewModel.currentMonth = Calendar.current.date(
                            byAdding: .month,
                            value: 1,
                            to: moodViewModel.currentMonth
                        ) ?? moodViewModel.currentMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.primaryBlue)
                }
            }
            .padding(.horizontal, 20)
            
            CalendarGridView(
                currentMonth: moodViewModel.currentMonth,
                moodEntries: moodViewModel.moodEntries,
                settings: settings,
                onDateTapped: { date in
                    handleDateTap(date)
                }
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var recentEntriesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Entries")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
                .padding(.horizontal, 4)
            
            LazyVStack(spacing: 12) {
                ForEach(moodViewModel.getRecentEntries()) { entry in
                    MoodEntryCard(entry: entry) {
                        selectedDateForEntry = DateWrapper(date: entry.date)
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "face.smiling")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.primaryBlue.opacity(0.6))
            
            Text("You haven't added any mood entries yet")
                .font(FontManager.subheadline)
                .foregroundColor(Color.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Add Entry") {
                selectedDateForEntry = DateWrapper(date: Date())
            }
            .font(FontManager.body)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.primaryBlue)
            )
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func handleDateTap(_ date: Date) {
        if !moodViewModel.canAddEntry(for: date) {
            return
        }
        
        selectedDateForEntry = DateWrapper(date: date)
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct MoodEntryCard: View {
    let entry: MoodEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(dayString(from: entry.date))
                        .font(FontManager.caption)
                        .foregroundColor(Color.textSecondary)
                    
                    Text(dateString(from: entry.date))
                        .font(FontManager.subheadline)
                        .foregroundColor(Color.textPrimary)
                }
                
                Text(entry.mood.emoji)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 4) {
                    if !entry.comment.isEmpty {
                        Text(entry.comment)
                            .font(FontManager.body)
                            .foregroundColor(Color.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("No comment")
                            .font(FontManager.body)
                            .foregroundColor(Color.textSecondary)
                            .italic()
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.textSecondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.backgroundWhite)
                    .shadow(color: Color.primaryBlue.opacity(0.08), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct DateWrapper: Identifiable {
    let id = UUID()
    let date: Date
}

#Preview {
    CalendarView(
        moodViewModel: MoodViewModel(),
        settings: AppSettings()
    )
}
