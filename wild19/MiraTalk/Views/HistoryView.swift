import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedHistoryEntry: HistoryEntry?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.history.isEmpty {
                        emptyStateView
                    } else {
                        historyListView
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $selectedHistoryEntry) { entry in
            HistoryQuestionDetailView(entry: entry, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("History")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if !viewModel.history.isEmpty {
                Text("\(viewModel.history.count) questions")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.lightGray)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var historyListView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.groupedHistory(), id: \.0) { dateString, entries in
                    HistoryDateSection(
                        dateString: dateString,
                        entries: entries,
                        onQuestionTap: { entry in
                            selectedHistoryEntry = entry
                        },
                        viewModel: viewModel
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 80)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "clock")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No History Yet")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Questions you've seen will appear here. Start exploring to build your history!")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HistoryDateSection: View {
    let dateString: String
    let entries: [HistoryEntry]
    let onQuestionTap: (HistoryEntry) -> Void
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dateString)
                .font(.playfairDisplay(size: 18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                ForEach(entries) { entry in
                    HistoryQuestionCard(
                        entry: entry,
                        onTap: {
                            onQuestionTap(entry)
                        },
                        viewModel: viewModel
                    )
                }
            }
        }
    }
}

struct HistoryQuestionCard: View {
    let entry: HistoryEntry
    let onTap: () -> Void
    @ObservedObject var viewModel: AppViewModel
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(timeFormatter.string(from: entry.dateShown))
                        .font(.playfairDisplay(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: entry.question.category.icon)
                            .font(.system(size: 10, weight: .medium))
                        Text(entry.question.category.displayName)
                            .font(.playfairDisplay(size: 10, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.primaryBlue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Text(entry.question.text)
                    .font(.playfairDisplay(size: 15, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Button(action: {
                        UIPasteboard.general.string = entry.question.text
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.clipboard")
                                .font(.system(size: 10, weight: .medium))
                            Text("Copy")
                                .font(.playfairDisplay(size: 10, weight: .medium))
                        }
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.primaryBlue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        viewModel.addToFavorites(question: entry.question)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: viewModel.isFavorite(question: entry.question) ? "heart.fill" : "heart")
                                .font(.system(size: 10, weight: .medium))
                            Text(viewModel.isFavorite(question: entry.question) ? "Saved" : "Save")
                                .font(.playfairDisplay(size: 10, weight: .medium))
                        }
                        .foregroundColor(viewModel.isFavorite(question: entry.question) ? AppColors.accentPink : AppColors.accentPink.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.accentPink.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .disabled(viewModel.isFavorite(question: entry.question))
                    
                    Spacer()
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.08), radius: 3, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HistoryQuestionDetailView: View {
    let entry: HistoryEntry
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: entry.question.category.icon)
                                .font(.system(size: 16, weight: .medium))
                            Text(entry.question.category.displayName)
                                .font(.playfairDisplay(size: 16, weight: .medium))
                        }
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(AppColors.primaryBlue.opacity(0.1))
                        .cornerRadius(25)
                        
                        Text("Shown on \(dateFormatter.string(from: entry.dateShown))")
                            .font(.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Text(entry.question.text)
                        .font(.playfairDisplay(size: 28, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            UIPasteboard.general.string = entry.question.text
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.on.clipboard")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Copy Question")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(AppColors.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.primaryYellow, AppColors.primaryYellow.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(28)
                            .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: {
                            viewModel.addToFavorites(question: entry.question)
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: viewModel.isFavorite(question: entry.question) ? "heart.fill" : "heart")
                                    .font(.system(size: 18, weight: .semibold))
                                Text(viewModel.isFavorite(question: entry.question) ? "Already in Favorites" : "Add to Favorites")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(viewModel.isFavorite(question: entry.question) ? AppColors.primaryWhite : AppColors.accentPink)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                viewModel.isFavorite(question: entry.question) ?
                                AnyShapeStyle(LinearGradient(
                                    colors: [AppColors.accentPink, AppColors.accentPink.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )) :
                                    AnyShapeStyle(AppColors.primaryWhite)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(AppColors.accentPink.opacity(0.3), lineWidth: viewModel.isFavorite(question: entry.question) ? 0 : 1)
                            )
                            .cornerRadius(28)
                            .shadow(color: AppColors.accentPink.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        .disabled(viewModel.isFavorite(question: entry.question))
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
            }
            .navigationTitle("Question History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    HistoryView(viewModel: AppViewModel())
}
