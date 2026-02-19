import SwiftUI

struct StatisticsView: View {
    private let storage = StorageManager.shared
    @State private var habits: [Habit] = []
    @State private var entries: [DailyEntry] = []
    @State private var todayEntry: DailyEntry?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(FontManager.bold(size: 26))
                        .foregroundColor(ColorManager.darkGray)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        overviewSection
                        habitsStatsSection
                        activitySection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(FontManager.medium(size: 18))
                .foregroundColor(ColorManager.darkGray)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatOverviewCard(
                    title: "Total Habits",
                    value: "\(habits.count)",
                    icon: "heart.fill",
                    color: ColorManager.primaryBlue
                )
                StatOverviewCard(
                    title: "Days Tracked",
                    value: "\(entries.count)",
                    icon: "calendar",
                    color: ColorManager.primaryYellow
                )
                StatOverviewCard(
                    title: "Rituals Done",
                    value: "\(entries.filter(\.completedRitual).count)",
                    icon: "leaf.fill",
                    color: ColorManager.success
                )
                StatOverviewCard(
                    title: "Challenges Done",
                    value: "\(entries.filter(\.completedChallenge).count)",
                    icon: "target",
                    color: ColorManager.softPink
                )
            }
        }
    }
    
    private var habitsStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Habit Streaks")
                .font(FontManager.medium(size: 18))
                .foregroundColor(ColorManager.darkGray)
            
            if habits.isEmpty {
                Text("No habits yet")
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(habits) { habit in
                        HStack(spacing: 16) {
                            Image(systemName: habit.icon)
                                .font(.system(size: 20))
                                .foregroundColor(ColorManager.primaryBlue)
                                .frame(width: 32)
                            
                            Text(habit.name)
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("\(habit.streakDays) days")
                                .font(FontManager.medium(size: 14))
                                .foregroundColor(ColorManager.primaryYellow)
                        }
                        .padding(16)
                        .background(ColorManager.cardGradient)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(FontManager.medium(size: 18))
                .foregroundColor(ColorManager.darkGray)
            
            let recent = entries.suffix(7).reversed()
            if recent.isEmpty {
                Text("No activity recorded yet")
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(recent), id: \.id) { entry in
                        HStack {
                            Text(dayLabel(entry.date))
                                .font(FontManager.regular(size: 14))
                                .foregroundColor(ColorManager.darkGray)
                            
                            Spacer()
                            
                            Text("\(Int(entry.progressPercentage * 100))%")
                                .font(FontManager.medium(size: 14))
                                .foregroundColor(entry.progressPercentage >= 0.75 ? ColorManager.success : ColorManager.primaryBlue)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(ColorManager.lightBlue.opacity(0.5))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    private func loadData() {
        habits = storage.loadHabits()
        entries = storage.loadDailyEntries()
        todayEntry = storage.loadTodayEntry()
        if let today = todayEntry, !entries.contains(where: { Calendar.current.isDateInToday($0.date) }) {
            entries.append(today)
        }
    }
    
    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
}

struct StatOverviewCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.bold(size: 28))
                .foregroundColor(ColorManager.darkGray)
            
            Text(title)
                .font(FontManager.regular(size: 14))
                .foregroundColor(ColorManager.darkGray.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    StatisticsView()
}
