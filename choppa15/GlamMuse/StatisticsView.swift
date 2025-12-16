import SwiftUI

struct StatisticsView: View {
    @StateObject private var looksViewModel = MakeupLooksViewModel()
    @StateObject private var productsViewModel = ProductsViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    
                    statisticsCardsView
                    
                    categoryBreakdownView
                    
                    recentActivityView
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Statistics")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Your makeup journey overview")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.top, 20)
    }
    
    private var statisticsCardsView: some View {
        VStack(spacing: 16) {
            StatisticsCard(
                title: "Makeup Looks",
                value: "\(looksViewModel.looks.count)",
                icon: "paintbrush",
                color: AppColors.accent
            )
            
            StatisticsCard(
                title: "Products",
                value: "\(productsViewModel.products.count)",
                icon: "bag",
                color: AppColors.primaryYellow
            )
            
            StatisticsCard(
                title: "Notes",
                value: "\(notesViewModel.notes.count)",
                icon: "note.text",
                color: AppColors.primaryBlue
            )
        }
    }
    
    private var categoryBreakdownView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Looks by Category")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                CategoryStatRow(
                    category: "Daily",
                    count: looksViewModel.looks.filter { $0.category == .daily }.count,
                    icon: "sun.max",
                    color: AppColors.primaryYellow
                )
                
                CategoryStatRow(
                    category: "Evening",
                    count: looksViewModel.looks.filter { $0.category == .evening }.count,
                    icon: "moon",
                    color: AppColors.primaryBlue
                )
                
                CategoryStatRow(
                    category: "Festive",
                    count: looksViewModel.looks.filter { $0.category == .festive }.count,
                    icon: "star",
                    color: AppColors.accent
                )
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
    
    private var recentActivityView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            if looksViewModel.looks.isEmpty && productsViewModel.products.isEmpty && notesViewModel.notes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("No activity yet")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .background(AppColors.cardBackground.opacity(0.5))
                .cornerRadius(12)
            } else {
                VStack(spacing: 12) {
                    if let latestLook = looksViewModel.looks.sorted(by: { $0.dateCreated > $1.dateCreated }).first {
                        ActivityRow(
                            title: "Latest Look",
                            subtitle: latestLook.name,
                            date: latestLook.dateCreated,
                            icon: "paintbrush"
                        )
                    }
                    
                    if let latestProduct = productsViewModel.products.sorted(by: { $0.dateAdded > $1.dateAdded }).first {
                        ActivityRow(
                            title: "Latest Product",
                            subtitle: latestProduct.name,
                            date: latestProduct.dateAdded,
                            icon: "bag"
                        )
                    }
                    
                    if let latestNote = notesViewModel.notes.sorted(by: { $0.dateCreated > $1.dateCreated }).first {
                        ActivityRow(
                            title: "Latest Note",
                            subtitle: latestNote.title.isEmpty ? "Untitled" : latestNote.title,
                            date: latestNote.dateCreated,
                            icon: "note.text"
                        )
                    }
                }
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
    }
}

struct StatisticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.darkText.opacity(0.7))
                
                Text(value)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.darkText)
            }
            
            Spacer()
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CategoryStatRow: View {
    let category: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(category)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.darkText)
            
            Spacer()
            
            Text("\(count)")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(color)
        }
        .padding(.vertical, 8)
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let date: Date
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.accent)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.darkText.opacity(0.6))
                
                Text(subtitle)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.darkText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(DateFormatter.shortDate.string(from: date))
                .font(.ubuntu(12))
                .foregroundColor(AppColors.darkText.opacity(0.5))
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView()
}
