import SwiftUI
import Combine

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 50, weight: .medium))
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Text("Statistics")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    
                    if viewModel.statistics.totalBooks == 0 {
                        EmptyStatisticsView(selectedTab: $selectedTab)
                    } else {
                        VStack(spacing: 20) {
                            StatisticsCardsView(statistics: viewModel.statistics)
                            
                            CompletedBooksView(completedBooks: viewModel.statistics.completedBooksList)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            viewModel.loadStatistics()
        }
    }
}

struct StatisticsCardsView: View {
    let statistics: BookStatistics
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Reading Summary")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatisticCard(
                    title: "Total Books Added",
                    value: "\(statistics.totalBooks)",
                    icon: "books.vertical"
                )
                
                StatisticCard(
                    title: "Books Completed",
                    value: "\(statistics.completedBooks)",
                    icon: "checkmark.circle"
                )
                
                StatisticCard(
                    title: "Total Pages Read",
                    value: "\(statistics.totalPagesRead)",
                    icon: "doc.text"
                )
                
                StatisticCard(
                    title: "Average Pages/Day (30 days)",
                    value: "\(statistics.averagePagesPerDay)",
                    icon: "chart.line.uptrend.xyaxis"
                )
            }
            
            StatisticCard(
                title: "Record Pages in One Day (30 days)",
                value: "\(statistics.recordPagesPerDay) pages",
                icon: "trophy",
                isFullWidth: true
            )
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    var isFullWidth: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(isFullWidth ? 24 : 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
        )
    }
}

struct CompletedBooksView: View {
    let completedBooks: [BookModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Completed Books")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            
            if completedBooks.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Text("No completed books yet")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Keep reading to see your achievements here")
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppColors.cardBackground)
                )
            } else {
                VStack(spacing: 8) {
                    ForEach(completedBooks) { book in
                        CompletedBookRow(book: book)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppColors.cardBackground)
                )
            }
        }
    }
}

struct CompletedBookRow: View {
    let book: BookModel
    
    private var completionDateText: String {
        guard let completionDate = book.dateCompleted else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "completed \(formatter.string(from: completionDate))"
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                if let author = book.author, !author.isEmpty {
                    Text("\(author) (\(completionDateText))")
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.secondaryText)
                } else {
                    Text(completionDateText)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(AppColors.success)
        }
        .padding(.vertical, 4)
    }
}

struct EmptyStatisticsView: View {
    @Binding var selectedTab : Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 12) {
                Spacer()
                Spacer()
                Spacer()
                
                Text("No statistics yet")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add books and start reading to see your progress")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                withAnimation {
                    selectedTab = 2
                }
            } label: {
                Text("Add First Book")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.primaryYellow)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

class StatisticsViewModel: ObservableObject {
    @Published var statistics = BookStatistics(
        totalBooks: 0,
        completedBooks: 0,
        totalPagesRead: 0,
        averagePagesPerDay: 0,
        recordPagesPerDay: 0,
        completedBooksList: []
    )
    
    private let userDefaultsManager = UserDefaultsManager.shared
    
    func loadStatistics() {
        statistics = userDefaultsManager.getStatistics()
    }
}
