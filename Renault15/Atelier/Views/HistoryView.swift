import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: HairstyleViewModel
    @State private var selectedDate = Date()
    @State private var showingCalendar = true
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("History")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingCalendar.toggle()
                        }
                    }) {
                        Image(systemName: showingCalendar ? "calendar.badge.minus" : "calendar.badge.plus")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.primaryYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        if showingCalendar {
                            calendarSection
                        }
                        
                        selectedDateSection
                        
                        statisticsSection
                    }
                    .padding(.horizontal, AppDimensions.screenPadding)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Your Hair Journey")
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.primaryWhite)
                Spacer()
            }
            
            Text("Track your hairstyles and looks over time")
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
        }
    }
    
    private var calendarSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                Spacer()
                
                Text(DateFormatter.monthYear.string(from: selectedDate))
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.primaryWhite)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            .padding(.horizontal, 20)
            
            CalendarGridView(
                selectedDate: $selectedDate,
                hairstyles: viewModel.hairstyles,
                looks: viewModel.looks
            )
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
    
    private var selectedDateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Selected Date")
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.primaryWhite)
                
                Spacer()
                
                Text(DateFormatter.fullDate.string(from: selectedDate))
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            let dayHairstyles = getHairstylesForDate(selectedDate)
            let dayLooks = getLooksForDate(selectedDate)
            
            if dayHairstyles.isEmpty && dayLooks.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.5))
                    
                    Text("No hairstyles or looks for this date")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                VStack(spacing: 12) {
                    if !dayHairstyles.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hairstyles (\(dayHairstyles.count))")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryWhite)
                            
                            ForEach(dayHairstyles) { hairstyle in
                                NavigationLink(destination: HairstyleDetailView(hairstyleId: hairstyle.id).environmentObject(viewModel)) {
                                    HistoryItemCard(
                                        title: hairstyle.name,
                                        subtitle: hairstyle.category.displayName,
                                        icon: "scissors"
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    if !dayLooks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Looks (\(dayLooks.count))")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryWhite)
                            
                            ForEach(dayLooks) { look in
                                NavigationLink(destination: LookDetailView(lookId: look.id).environmentObject(viewModel)) {
                                    HistoryItemCard(
                                        title: look.name,
                                        subtitle: "\(look.hairstyles.count) hairstyles",
                                        icon: "photo"
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
    
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Total Hairstyles",
                    value: "\(viewModel.hairstyles.count)",
                    icon: "scissors"
                )
                
                StatCard(
                    title: "Total Looks",
                    value: "\(viewModel.looks.count)",
                    icon: "photo.on.rectangle"
                )
                
                StatCard(
                    title: "Favorite Category",
                    value: getFavoriteCategory(),
                    icon: "heart.fill"
                )
                
                StatCard(
                    title: "This Month",
                    value: "\(getThisMonthCount())",
                    icon: "calendar"
                )
            }
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
        }
    }
    
    private func getHairstylesForDate(_ date: Date) -> [Hairstyle] {
        return viewModel.hairstyles.filter { Calendar.current.isDate($0.dateCreated, inSameDayAs: date) }
    }
    
    private func getLooksForDate(_ date: Date) -> [Look] {
        return viewModel.looks.filter { Calendar.current.isDate($0.dateCreated, inSameDayAs: date) }
    }
    
    private func getFavoriteCategory() -> String {
        let categories = viewModel.hairstyles.map { $0.category }
        let counts = Dictionary(grouping: categories, by: { $0 }).mapValues { $0.count }
        let favorite = counts.max { $0.value < $1.value }
        return favorite?.key.displayName ?? "None"
    }
    
    private func getThisMonthCount() -> Int {
        let thisMonth = Calendar.current.dateInterval(of: .month, for: Date())
        let hairstylesThisMonth = viewModel.hairstyles.filter { thisMonth?.contains($0.dateCreated) == true }
        let looksThisMonth = viewModel.looks.filter { thisMonth?.contains($0.dateCreated) == true }
        return hairstylesThisMonth.count + looksThisMonth.count
    }
}

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    let hairstyles: [Hairstyle]
    let looks: [Look]
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        hasActivity: hasActivityForDate(date)
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
    }
    
    private func getDaysInMonth() -> [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.start ?? Date()
        let range = calendar.range(of: .day, in: .month, for: selectedDate) ?? 1..<32
        
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    private func hasActivityForDate(_ date: Date) -> Bool {
        let hasHairstyles = hairstyles.contains { Calendar.current.isDate($0.dateCreated, inSameDayAs: date) }
        let hasLooks = looks.contains { Calendar.current.isDate($0.dateCreated, inSameDayAs: date) }
        return hasHairstyles || hasLooks
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasActivity: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? AppColors.darkBlue : AppColors.primaryWhite)
                
                if hasActivity {
                    Circle()
                        .fill(AppColors.primaryYellow)
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(width: 32, height: 32)
            .background(isSelected ? AppColors.primaryYellow : Color.clear)
            .cornerRadius(8)
        }
    }
}

struct HistoryItemCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.primaryYellow)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryWhite)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.smallCornerRadius)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primaryYellow)
            
            Text(value)
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
}

extension DateFormatter {
    static let monthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}

#Preview {
    HistoryView()
        .environmentObject(HairstyleViewModel())
}
