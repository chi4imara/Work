import SwiftUI
import Combine

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showFilters = false
    @State private var selectedAnswer: DailyAnswer?
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Question History")
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showFilters.toggle() }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.filteredAnswers.isEmpty {
                    EmptyHistoryState(selectedTab: $selectedTab)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredAnswers) { answer in
                                HistoryCard(answer: answer) {
                                    selectedAnswer = answer
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadAnswers()
        }
        .sheet(isPresented: $showFilters) {
            FilterSheet(viewModel: viewModel)
        }
        .sheet(item: $selectedAnswer) { answer in
            AnswerDetailView(
                answer: answer,
                onDelete: {
                    viewModel.deleteAnswer(answer)
                    selectedAnswer = nil
                },
                onEdit: { updatedAnswer in
                    viewModel.updateAnswer(updatedAnswer)
                }
            )
        }
    }
}

struct HistoryCard: View {
    let answer: DailyAnswer
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(formatDate(answer.date))
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Text(answer.questionText)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(answer.answer)
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppGradients.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct EmptyHistoryState: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "doc.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 16) {
                Text("No saved answers yet")
                    .font(.playfairDisplay(20, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Start answering daily questions to see your reflection journey")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = 0
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle")
                            .font(.system(size: 18, weight: .medium))
                        
                        Text("Answer First Question")
                            .font(.playfairDisplay(16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 14)
                    .background(AppGradients.buttonGradient)
                    .cornerRadius(20)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FilterSheet: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Search")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                    
                    TextField("Search in questions and answers...", text: $viewModel.searchText)
                        .font(.playfairDisplay(16, weight: .regular))
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                }
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Time Period")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Picker("Period", selection: $viewModel.selectedPeriod) {
                        ForEach(FilterPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button {
                        viewModel.resetFilters()
                    } label: {
                        Text("Reset")
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(AppColors.textSecondary, lineWidth: 1)
                            )
                    }
                    
                    Button {
                        viewModel.applyFilters()
                        dismiss()
                    } label: {
                        Text("Apply")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppGradients.buttonGradient)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(20)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct AnswerDetailView: View {
    let answer: DailyAnswer
    let onDelete: () -> Void
    let onEdit: (DailyAnswer) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false
    @State private var currentAnswer: DailyAnswer
    
    init(answer: DailyAnswer, onDelete: @escaping () -> Void, onEdit: @escaping (DailyAnswer) -> Void) {
        self.answer = answer
        self.onDelete = onDelete
        self.onEdit = onEdit
        self._currentAnswer = State(initialValue: answer)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(formatDate(currentAnswer.date))
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text(currentAnswer.questionText)
                                .font(.playfairDisplay(20, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Divider()
                            .background(AppColors.textLight)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Answer")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(currentAnswer.answer)
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.textPrimary)
                                .lineSpacing(4)
                        }
                        
                        Spacer(minLength: 20)
                        
                        Text("Answer recorded at \(formatTime(currentAnswer.createdAt))")
                            .font(.playfairDisplay(14, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Answer Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Edit") {
                            showEditSheet = true
                        }
                        .foregroundColor(AppColors.primaryBlue)
                        
                        Button("Delete") {
                            showDeleteAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("Delete Answer", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this answer? This action cannot be undone.")
        }
        .sheet(isPresented: $showEditSheet) {
            EditAnswerView(answer: currentAnswer) { updatedAnswer in
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentAnswer = updatedAnswer
                }
                onEdit(updatedAnswer)
                showEditSheet = false
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var answers: [DailyAnswer] = []
    @Published var filteredAnswers: [DailyAnswer] = []
    @Published var searchText = ""
    @Published var selectedPeriod: FilterPeriod = .all
    
    private let dataManager = DataManager.shared
    
    func loadAnswers() {
        answers = dataManager.getDailyAnswers()
        applyFilters()
    }
    
    func applyFilters() {
        var filtered = answers
        
        if !searchText.isEmpty {
            filtered = filtered.filter { answer in
                answer.questionText.localizedCaseInsensitiveContains(searchText) ||
                answer.answer.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            filtered = filtered.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            filtered = filtered.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            filtered = filtered.filter { $0.date >= yearAgo }
        case .all:
            break
        }
        
        filteredAnswers = filtered
    }
    
    func resetFilters() {
        searchText = ""
        selectedPeriod = .all
        applyFilters()
    }
    
    func deleteAnswer(_ answer: DailyAnswer) {
        dataManager.deleteDailyAnswer(answer)
        answers = dataManager.getDailyAnswers()
        applyFilters()
        
        objectWillChange.send()
    }
    
    func updateAnswer(_ answer: DailyAnswer) {
        dataManager.saveDailyAnswer(answer)
        answers = dataManager.getDailyAnswers()
        applyFilters()
        
        objectWillChange.send()
    }
}

enum FilterPeriod: String, CaseIterable {
    case all = "All"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

#Preview {
    HistoryView(selectedTab: .constant(2))
}
