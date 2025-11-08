import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var bookStore: BookStore
    @State private var selectedStatsPeriod: StatsPeriod = .allTime
    
    enum StatsPeriod: String, CaseIterable {
        case thisMonth = "This Month"
        case thisYear = "This Year"
        case allTime = "All Time"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        periodSelectorView
                        
                        statisticsCardsView
                        
                        readingProgressView
                        
                        recentActivityView
                        
                        readingGoalsView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
                .navigationBarHidden(true)
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("My Library")
                .font(FontManager.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Text("Track your reading journey")
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var periodSelectorView: some View {
        HStack(spacing: 12) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    selectedStatsPeriod = period
                }) {
                    Text(period.rawValue)
                        .font(FontManager.caption)
                        .foregroundColor(selectedStatsPeriod == period ? .white : AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                   RoundedRectangle(cornerRadius: 20)
                                       .fill(selectedStatsPeriod == period ? AppColors.primaryBlue : AppColors.cardBackground)
                                   RoundedRectangle(cornerRadius: 20)
                                       .stroke(AppColors.lightBlue, lineWidth: 1)
                               }
                        )
                }
            }
            
            Spacer()
        }
    }
    
    private var statisticsCardsView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Total Books",
                value: "\(bookStore.books.count)",
                icon: "books.vertical",
                color: AppColors.primaryBlue
            )
            
            StatCard(
                title: "Completed",
                value: "\(bookStore.completedBooks.count)",
                icon: "checkmark.circle",
                color: AppColors.completedColor
            )
            
            StatCard(
                title: "Currently Reading",
                value: "\(bookStore.readingBooks.count)",
                icon: "book.circle",
                color: AppColors.readingColor
            )
            
            StatCard(
                title: "Want to Read",
                value: "\(bookStore.wantToReadBooks.count)",
                icon: "star.circle",
                color: AppColors.wantToReadColor
            )
        }
    }
    
    private var readingProgressView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reading Progress")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ProgressBarView(
                    title: "Completed",
                    value: bookStore.completedBooks.count,
                    total: bookStore.books.count,
                    color: AppColors.completedColor
                )
                
                ProgressBarView(
                    title: "Reading",
                    value: bookStore.readingBooks.count,
                    total: bookStore.books.count,
                    color: AppColors.readingColor
                )
                
                ProgressBarView(
                    title: "Want to Read",
                    value: bookStore.wantToReadBooks.count,
                    total: bookStore.books.count,
                    color: AppColors.wantToReadColor
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var recentActivityView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                if bookStore.books.isEmpty {
                    Text("No activity yet")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    ForEach(recentBooks.prefix(3), id: \.id) { book in
                        RecentActivityRow(book: book)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var readingGoalsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reading Goals")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 16) {
                GoalCard(
                    title: "Books This Year",
                    current: yearlyCompletedBooks,
                    target: 12,
                    icon: "target",
                    color: AppColors.primaryBlue
                )
                
                GoalCard(
                    title: "Books This Month",
                    current: monthlyCompletedBooks,
                    target: 1,
                    icon: "calendar",
                    color: AppColors.completedColor
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var recentBooks: [Book] {
        bookStore.books.sorted { $0.lastModified > $1.lastModified }
    }
    
    private var yearlyCompletedBooks: Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        return bookStore.completedBooks.filter { book in
            if let completedDate = book.dateCompleted {
                return calendar.component(.year, from: completedDate) == currentYear
            }
            return false
        }.count
    }
    
    private var monthlyCompletedBooks: Int {
        let calendar = Calendar.current
        let now = Date()
        
        return bookStore.completedBooks.filter { book in
            if let completedDate = book.dateCompleted {
                return calendar.isDate(completedDate, equalTo: now, toGranularity: .month)
            }
            return false
        }.count
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
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}

struct ProgressBarView: View {
    let title: String
    let value: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(value) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(value)/\(total)")
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.lightBlue.opacity(0.3))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .animation(.easeInOut(duration: 0.5), value: percentage)
                }
            }
            .frame(height: 8)
        }
    }
}

struct RecentActivityRow: View {
    let book: Book
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: statusIcon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(statusColor)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(statusColor.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(book.title)
                    .font(FontManager.cardSubtitle)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(activityText)
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text(book.lastModified, style: .relative)
                .font(FontManager.caption)
                .foregroundColor(AppColors.secondaryText)
        }
    }
    
    private var statusIcon: String {
        switch book.status {
        case .reading:
            return "book"
        case .completed:
            return "checkmark.circle"
        case .wantToRead:
            return "star"
        }
    }
    
    private var statusColor: Color {
        switch book.status {
        case .reading:
            return AppColors.readingColor
        case .completed:
            return AppColors.completedColor
        case .wantToRead:
            return AppColors.wantToReadColor
        }
    }
    
    private var activityText: String {
        switch book.status {
        case .reading:
            return "Started reading"
        case .completed:
            return "Completed"
        case .wantToRead:
            return "Added to wishlist"
        }
    }
}

struct GoalCard: View {
    let title: String
    let current: Int
    let target: Int
    let icon: String
    let color: Color
    
    private var progress: Double {
        guard target > 0 else { return 0 }
        return min(Double(current) / Double(target), 1.0)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text("\(current)/\(target)")
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: color))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
            }
        }
    }
}
