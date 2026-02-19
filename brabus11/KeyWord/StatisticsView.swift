import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: DictionaryViewModel
    @State private var presentedSheet: SheetType?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 25) {
                        overviewSection
                        wordsStatsSection
                        recentActivitySection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(item: Binding(
            get: { presentedSheet ?? viewModel.presentedSheet },
            set: { newValue in
                guard let sheetType = newValue else {
                    presentedSheet = nil
                    viewModel.presentedSheet = nil
                    return
                }
                
                switch sheetType {
                case .wordDetail:
                    presentedSheet = sheetType
                    viewModel.presentedSheet = nil
                case .editWord:
                    viewModel.presentedSheet = sheetType
                    presentedSheet = nil
                case .addWord:
                    viewModel.presentedSheet = sheetType
                    presentedSheet = nil
                }
            }
        )) { sheetType in
            sheetContent(for: sheetType)
        }
    }
    
    @ViewBuilder
    private func sheetContent(for sheetType: SheetType) -> some View {
        switch sheetType {
        case .addWord:
            WordFormView(
                viewModel: WordFormViewModel(),
                onSave: { word in
                    viewModel.addWord(word)
                    presentedSheet = nil
                    viewModel.presentedSheet = nil
                },
                onCancel: {
                    presentedSheet = nil
                    viewModel.presentedSheet = nil
                }
            )
        case .editWord(let wordId):
            if let word = viewModel.getWordById(wordId) {
                WordFormView(
                    viewModel: WordFormViewModel(editingWord: word),
                    editingWord: word,
                    onSave: { updatedWord in
                        viewModel.updateWord(updatedWord)
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    },
                    onCancel: {
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    }
                )
            } else {
                EmptyView()
                    .onAppear {
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    }
            }
        case .wordDetail(let wordId):
            if let word = viewModel.getWordById(wordId) {
                WordDetailView(
                    word: word,
                    onEdit: {
                        presentedSheet = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.showEditWordSheet(word)
                        }
                    },
                    onDelete: {
                        viewModel.confirmDelete(word)
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    },
                    onDismiss: {
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    }
                )
            } else {
                EmptyView()
                    .onAppear {
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var overviewSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Overview")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            HStack(spacing: 15) {
                StatCard(
                    title: "Total Words",
                    value: "\(viewModel.words.count)",
                    icon: "book.fill",
                    color: ColorManager.primaryBlue
                )
                
                StatCard(
                    title: "With Meaning",
                    value: "\(viewModel.words.filter { !$0.meaning.isEmpty }.count)",
                    icon: "lightbulb.fill",
                    color: ColorManager.primaryYellow
                )
            }
            
            HStack(spacing: 15) {
                StatCard(
                    title: "With Association",
                    value: "\(viewModel.words.filter { !$0.association.isEmpty }.count)",
                    icon: "link",
                    color: ColorManager.accentPurple
                )
                
                StatCard(
                    title: "This Month",
                    value: "\(wordsThisMonth)",
                    icon: "calendar",
                    color: ColorManager.accentGreen
                )
            }
        }
    }
    
    private var wordsStatsSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Word Statistics")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            VStack(spacing: 0) {
                statsRow(title: "Average word length", value: "\(averageWordLength) characters")
                Divider().padding(.horizontal, 20)
                statsRow(title: "Longest word", value: longestWord)
                Divider().padding(.horizontal, 20)
                statsRow(title: "Shortest word", value: shortestWord)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var recentActivitySection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Recent Activity")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            if viewModel.words.isEmpty {
                emptyStateView
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.words.sorted(by: { $0.dateModified > $1.dateModified }).prefix(5))) { word in
                        activityRow(word: word)
                        if word.id != viewModel.words.sorted(by: { $0.dateModified > $1.dateModified }).prefix(5).last?.id {
                            Divider().padding(.horizontal, 20)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Text("No activity yet")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorManager.darkGray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    @ViewBuilder
    private func statsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorManager.primaryBlue)
        }
        .padding(20)
    }
    
    @ViewBuilder
    private func activityRow(word: WordEntry) -> some View {
        Button(action: {
            HapticManager.selection()
            presentedSheet = .wordDetail(word.id)
        }) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(word.word)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(ColorManager.textBlue)
                    
                    Text(formatDate(word.dateModified))
                        .font(.playfairDisplay(13, weight: .regular))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            }
            .padding(20)
        }
    }
    
    private var wordsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.words.filter { word in
            calendar.isDate(word.dateCreated, equalTo: now, toGranularity: .month)
        }.count
    }
    
    private var averageWordLength: Int {
        guard !viewModel.words.isEmpty else { return 0 }
        let totalLength = viewModel.words.reduce(0) { $0 + $1.word.count }
        return totalLength / viewModel.words.count
    }
    
    private var longestWord: String {
        viewModel.words.max(by: { $0.word.count < $1.word.count })?.word ?? "N/A"
    }
    
    private var shortestWord: String {
        viewModel.words.min(by: { $0.word.count < $1.word.count })?.word ?? "N/A"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(ColorManager.textBlue)
            
            Text(title)
                .font(.playfairDisplay(13, weight: .regular))
                .foregroundColor(ColorManager.darkGray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}
