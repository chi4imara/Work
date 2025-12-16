import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if dataManager.history.isEmpty {
                emptyStateView
            } else {
                historyList
            }
        }
        .navigationTitle("Challenge History")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.primary)
            }
        }
    }
    
    private var historyList: some View {
        List {
            ForEach(dataManager.history) { entry in
                HistoryEntryCard(entry: entry)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .leading) {
                        Button("Favorite") {
                            dataManager.addHistoryToFavorites(entry)
                        }
                        .tint(AppColors.secondary)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete") {
                            dataManager.deleteFromHistory(entry)
                        }
                        .tint(AppColors.error)
                    }
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            Text("History is empty")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Generated challenges will appear here")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

struct HistoryEntryCard: View {
    let entry: HistoryEntry
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(entry.challengeText)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .lineSpacing(4)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Category: \(entry.categoryName)")
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(dateFormatter.string(from: entry.generatedAt))
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.textSecondary.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "clock.fill")
                    .foregroundColor(AppColors.primary.opacity(0.6))
                    .font(.system(size: 14))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationView {
        HistoryView()
            .environmentObject(DataManager.shared)
    }
}
